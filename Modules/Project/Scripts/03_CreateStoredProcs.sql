GO
/****** Object:  StoredProcedure [Log].[p_error_save]    Script Date: 22.01.2022 3:13:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Log].[p_error_save]
(	
	@ProcedureName nvarchar(300)
	, @ErrorCode int
    , @Parameters nvarchar(max)
)
AS
BEGIN
	BEGIN TRY
		DECLARE @ErrorMessage nvarchar(max) = ERROR_MESSAGE();

		INSERT INTO [Log].[Error]
           ([ProcedureName], [ErrorCode], [ErrorMessage], [Parameters], [Datetime])
		VALUES
           (@ProcedureName, @ErrorCode, @ErrorMessage, @Parameters, GETDATE())
	END TRY
	BEGIN CATCH
	END CATCH
END
GO
/****** Object:  StoredProcedure [UI].[p_event_bind_product]    Script Date: 22.01.2022 3:13:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [UI].[p_person_check_is_employee]
(	
	@PersonId BIGINT
)
AS
BEGIN
	Declare 
		@BusinessDirectionTypeId BIGINT
		, @IsNotEmployeeError INT = 100001;

	SELECT 
		@BusinessDirectionTypeId = t.BusinessDirectionTypeId
	FROM 
		[Org].[Person] p WITH (NOLOCK)
		JOIN [Org].[PersonType] t WITH (NOLOCK) ON t.[Id] = p.[TypeId]
	WHERE
		p.[Id] = @PersonId

	IF @BusinessDirectionTypeId <> 1
	BEGIN
		raiserror(@IsNotEmployeeError, 16, 1)
	END
END
GO
/****** Object:  StoredProcedure [UI].[p_person_check_is_exist]    Script Date: 22.01.2022 3:13:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [UI].[p_person_check_is_exist]
(	
	@PersonId BIGINT
)
AS
BEGIN
	Declare 
		@PersonNotFoundError INT = 100002;

	IF NOT EXISTS (SELECT 1 FROM [Org].[Person] p WHERE p.[Id] = @PersonId)
	BEGIN
		raiserror(@PersonNotFoundError, 16, 1)
	END
END
GO
/****** Object:  StoredProcedure [UI].[p_person_create]    Script Date: 22.01.2022 3:13:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [UI].[p_event_bind_product]
(	
	@EventId BIGINT
	, @ProductId BIGINT
	, @Quantity DECIMAL(18,2) = 1
	, @Price DECIMAL(18,2) = NULL
	, @Id BIGINT output
)
AS
BEGIN
	DECLARE
		@OrderNumber BIGINT
		, @Parameters NVARCHAR(MAX);

	SELECT @Parameters =
	(
		SELECT
			@EventId as EventId
			, @ProductId as ProductId
		for
		xml path('')
	);

	BEGIN TRY
		IF @Price IS NULL
			SELECT @Price = p.[Price] 
			FROM [Catalog].[Product] p WITH (NOLOCK) 
			WHERE p.[id] = @ProductId

		INSERT INTO [Event].[ProductOnEvent]
			(
				[ProductId]
				, [EventId]
				, [Price]
				, [Quantity]
			)
		 VALUES
			(
				@ProductId
				, @EventId
				, @Price
				, @Quantity
			)
	END TRY
	BEGIN CATCH

		DECLARE
			@ErrorNumber   int = error_number()
			, @ErrorSeverity int = error_severity()
			, @ErrorState    int = error_state();
			
		EXEC [Log].[p_error_save] '[UI].[p_event_bind_product]', @@ERROR, @Parameters
		raiserror(@ErrorNumber, @ErrorSeverity, @ErrorState);

	END CATCH
END
GO
/****** Object:  StoredProcedure [UI].[p_order_create_instant]    Script Date: 22.01.2022 3:13:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [UI].[p_order_create_instant]
(	
	@SellerId BIGINT
	, @BuyerId BIGINT
	, @Description NVARCHAR(MAX) = NULL
	, @Products [TVP].[ProductList] READONLY
	, @Id BIGINT output
)
AS
BEGIN
	DECLARE
		@OrderNumber BIGINT
		, @ProductId BIGINT
		, @Quantity	DECIMAL(18,3)
		, @Parameters NVARCHAR(MAX);

	SELECT @Parameters =
	(
		SELECT
			@SellerId AS SellerId
			, @BuyerId AS BuyerId
			, @Description AS Description
		FOR
		XML PATH('')
	);

	DECLARE ProductsCoursor CURSOR FAST_FORWARD FOR
		SELECT [Id], [Quantity] FROM @Products;

	OPEN ProductsCoursor;

	BEGIN TRY
		--BEGIN TRAN
		
			-- Checks
			EXEC [UI].[p_person_check_is_exist] @SellerId
			EXEC [UI].[p_person_check_is_exist] @BuyerId
			EXEC [UI].[p_person_check_is_employee] @SellerId

			-- Create Order
			SET @OrderNumber = NEXT VALUE FOR OrderNumberSequence;

			INSERT INTO [Event].[Event]
			(
				[Name]
				,[PreviosEventId]
				,[StatusId]
				,[TypeId]
				,[Desctiption]
				,[StartOn]
				,[EndOn]
				,[IsPlanned]
				,[BusinessDirectionTypeId]
			)
			VALUES
			(
				'Заказ #' + CONVERT(NVARCHAR(10), @OrderNumber)
				, NULL
				, 7
				, 4
				, @Description
				, GETDATE()
				, GETDATE()
				, 0
				, 2
			);

			SET @Id = @@IDENTITY;
				
			-- Added Buyer
			INSERT INTO [Event].[Invite]
				([EventId], [TypeId], [StatusId], [PersonId], [IsRequired])
			VALUES
				(@Id, 4, 2, @BuyerId, 1);

			-- Added Seller
			INSERT INTO [Event].[Invite]
				([EventId], [TypeId], [StatusId], [PersonId], [IsRequired])
			VALUES
				(@Id, 3, 2, @SellerId, 1);

			-- Bind products
			FETCH NEXT FROM ProductsCoursor INTO @ProductId, @Quantity;
			
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				DECLARE @BindId BIGINT;
				EXEC [UI].[p_event_bind_product] 
					@Id, 
					@ProductId, 
					@Quantity, 
					@Id = @BindId OUTPUT;

				FETCH NEXT FROM ProductsCoursor INTO @ProductId, @Quantity;
			END;

		--COMMIT TRAN

		CLOSE ProductsCoursor;
		DEALLOCATE ProductsCoursor;

		-- Send to create report
		-- EXEC [SB].[p_OrderReport_Create_Send] @Id

	END TRY
	BEGIN CATCH
		
		DECLARE
			@ErrorNumber   int = error_number()
			, @ErrorSeverity int = error_severity()
			, @ErrorState    int = error_state();

		EXEC [Log].[p_error_save] '[UI].[p_order_create_instant]', @ErrorNumber, @Parameters;
		raiserror(@ErrorNumber, @ErrorSeverity, @ErrorState);

		--ROLLBACK

		CLOSE ProductsCoursor;
		DEALLOCATE ProductsCoursor;

	END CATCH
END
GO
/****** Object:  StoredProcedure [UI].[p_person_check_is_employee]    Script Date: 22.01.2022 3:13:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [UI].[p_person_create]
(	
	  @FirstName			nvarchar(100)	
	, @Description			nvarchar(max)	= NULL
	, @AddressAdditional	nvarchar(100)	= NULL
	, @Icon					nvarchar(max)	= NULL
	, @BirthDay				datetime2(7)	= NULL
	, @LastName				nvarchar(100)	= NULL
	, @MiddleName			nvarchar(100)	= NULL
	, @AddressLevelId		bigint			= NULL
	, @ExternalId			nvarchar(50)	= NULL
	, @StatusId				bigint			= 1
	, @BusinessUnitId		bigint			= 1
	, @TypeId				bigint			= 1
	, @GenderTypeId			bigint			= 1
	, @Id					bigint	output
)
AS
BEGIN
	INSERT INTO [Org].[Person]
           ([StatusId]
           ,[FirstName]
           ,[LastName]
           ,[MiddleName]
           ,[GenderTypeId]
           ,[BusinessUnitId]
           ,[Description]
           ,[TypeId]
           ,[AddressLevelId]
           ,[AddressAdditional]
           ,[Icon]
           ,[ExternalId]
           ,[BirthDay]
           ,[RegisterOn])
     VALUES
           (@StatusId
           , @FirstName
           ,@LastName
           ,@MiddleName
           ,@GenderTypeId
           ,@BusinessUnitId
           ,@Description
           ,@TypeId
           ,@AddressLevelId
           ,@AddressAdditional
           ,@Icon
           ,@ExternalId
           ,@BirthDay
           ,GETDATE() - 1);

	SET @Id = @@IDENTITY;
END
GO
/****** Object:  StoredProcedure [UI].[p_product_create]    Script Date: 22.01.2022 3:13:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [UI].[p_product_create]
(	
	@Name nvarchar(100) 
	, @Price decimal(18, 2) 
	, @CatalogLevelId bigint  = NULL
	, @Icon nvarchar(max)  = NULL
	, @ExternalId nvarchar(50) = NULL
	, @MeasurementTypeId bigint = 2
	, @BusinessDirectionTypeId bigint = 2
	, @IsActive bit = 1
	, @Description nvarchar(300) = null
	, @Id bigint output
)
AS
BEGIN
	INSERT INTO [Catalog].[Product]
           (
			[Price]
			,[CatalogLevelId]
			,[MeasurementTypeId]
			,[Name]
			,[Description]
			,[IsActive]
			,[Icon]
			,[ExternalId]
			,[BusinessDirectionTypeId]
		   )
     VALUES
           (
			@Price
			,@CatalogLevelId
			,@MeasurementTypeId
			,@Name
			,@Description
			,@IsActive
			,@Icon
			,@ExternalId
			,@BusinessDirectionTypeId
		   )

	SET @Id = @@IDENTITY;
END


CREATE PROCEDURE [Report].[p_OrderReport_Create]
(	
	@EventId BIGINT
)
AS
BEGIN
	DECLARE @Parameters NVARCHAR(MAX);
	SELECT @Parameters =
	(
		SELECT
			@EventId as EventId
		FOR
		XML PATH('')
	);

	BEGIN TRY
		DECLARE	
			  @OrderId BIGINT
			, @SellerId BIGINT
			, @ClientId BIGINT
			
		    , @Date datetime2(7)
		    , @Sum decimal(18,2) = 0

		    , @EventName nvarchar(300)
		
		    , @SellerBusinessUnitId bigint
		    , @SellerFullName nvarchar(300)
		    , @SellerBusinessUnitName nvarchar(100)
		
		    , @ClientBusinessUnitId bigint
		    , @ClientFullName nvarchar(300)
		    , @ClientBusinessUnitName nvarchar(100);
			
		--- Fill fields
		SELECT 
			@Date = e.[EndOn]
			, @EventName = e.[Name]
		FROM 
			[Event].[Event] e WITH(NOLOCK)
		WHERE
			e.[Id] = @EventId
			
		SELECT 
			@ClientId = i.[PersonId] 
			, @ClientBusinessUnitId = p.[BusinessUnitId]
			, @ClientBusinessUnitName = bu.[Name]
			, @ClientFullName = TRIM(CONCAT(p.[LastName], ' ', p.[FirstName], ' ', p.[MiddleName]))
		FROM 
			[Event].[Invite] i WITH(NOLOCK) 
			JOIN [Org].[Person] p WITH(NOLOCK) ON p.[Id] = i.[PersonId]
			JOIN [Org].[BusinessUnit] bu WITH(NOLOCK) ON bu.[Id] = p.[BusinessUnitId]
		WHERE 1=1
			AND i.[EventId] = @EventId 
			AND i.[TypeId] = 4
		
			
		SELECT 
			@SellerId = i.[PersonId] 
			, @SellerBusinessUnitId = p.[BusinessUnitId]
			, @SellerBusinessUnitName = bu.[Name]
			, @SellerFullName = TRIM(CONCAT(p.[LastName], ' ', p.[FirstName], ' ', p.[MiddleName]))
		FROM 
			[Event].[Invite] i WITH(NOLOCK) 
			JOIN [Org].[Person] p WITH(NOLOCK) ON p.[Id] = i.[PersonId]
			JOIN [Org].[BusinessUnit] bu WITH(NOLOCK) ON bu.[Id] = p.[BusinessUnitId]
		WHERE 1=1
			AND i.[EventId] = @EventId 
			AND i.[TypeId] = 3

		-- Create order
		INSERT INTO [Report].[Order]
		(
			  [Date]
			, [Sum]
			, [Discount]
			, [EventId]				
			, [EventName]			
			, [SellerId]
			, [SellerBusinessUnitId]
			, [SellerFullName]
			, [SellerBusinessUnitName]
			, [ClientId]
			, [ClientBusinessUnitId]
			, [ClientFullName]
			, [ClientBusinessUnitName]
		)
		   VALUES
		   (
			  @Date
			, @Sum
			, 0
			, @EventId
			, @EventName
			, @SellerId
			, @SellerBusinessUnitId
			, @SellerFullName
			, @SellerBusinessUnitName
			, @ClientId
			, @ClientBusinessUnitId
			, @ClientFullName
			, @ClientBusinessUnitName
		);
		
		SET @OrderId = @@IDENTITY
		
		-- Create lines
		INSERT INTO [Report].[OrderLine]
		(
			  [Name]
			, [Externalid]
			, [OrderId]
			, [ProductId]
			, [Count]
			, [Price]
			, [Sum]
			, [Discount]
		)
		SELECT 
			  p.[Name]
			, p.[ExternalId]
			, @OrderId
			, p.[Id]
			, poe.Quantity
			, p.[Price]
			, poe.Quantity * p.[Price]
			, 0
		FROM 
			[Event].[ProductOnEvent] poe WITH(NOLOCK)
			JOIN [Catalog].[Product] p WITH(NOLOCK) ON p.[Id] = poe.[ProductId]
		WHERE 
			poe.[EventId] = @EventId

		-- Calculate order sum
		SELECT 
			@Sum = SUM(l.[Sum])
		FROM 
			[Report].[OrderLine] l WITH(NOLOCK)
		GROUP BY 
			l.[OrderId]
		HAVING 
			l.[OrderId] = @OrderId

		UPDATE [Report].[Order]
		SET [Sum] = @Sum
		WHERE [Id] = @OrderId

	END TRY
	BEGIN CATCH
		
		DECLARE
			@ErrorNumber   int = error_number()
			, @ErrorSeverity int = error_severity()
			, @ErrorState    int = error_state();

		EXEC [Log].[p_error_save] '[Report].[p_OrderReport_Create]', @ErrorNumber, @Parameters;
		raiserror(@ErrorNumber, @ErrorSeverity, @ErrorState);

	END CATCH
END;
GO

CREATE PROCEDURE [SB].[p_OrderReport_Create_Send]
(	
	@EventId BIGINT
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		  @InitDlgHandle UNIQUEIDENTIFIER
		, @RequestMessage NVARCHAR(4000);
	
	BEGIN TRY
		BEGIN TRAN
		
			SELECT @RequestMessage = 
				(
					SELECT @EventId AS EventId
					FOR XML PATH('RequestMessage')
				); 
		
			BEGIN DIALOG @InitDlgHandle
			FROM SERVICE [//WWI/SB/CreateOrderReportInitiatorService]
			TO SERVICE '//WWI/SB/CreateOrderReportTargetService'
			ON CONTRACT	[//WWI/SB/CreateOrderReportContract]
			WITH ENCRYPTION=OFF; 

			SEND ON CONVERSATION @InitDlgHandle 
			MESSAGE TYPE [//WWI/SB/CreateOrderReportRequestMessage] (@RequestMessage);
		COMMIT TRAN 
		
	END TRY
	BEGIN CATCH

		DECLARE
			@ErrorNumber   int = error_number()
			, @ErrorSeverity int = error_severity()
			, @ErrorState    int = error_state();
			
		EXEC [Log].[p_error_save] '[SB].[p_OrderReport_Create_Send]', @@ERROR, Null
		raiserror(@ErrorNumber, @ErrorSeverity, @ErrorState);

	END CATCH
END
GO

alter PROCEDURE [SB].[p_OrderReport_Create_Recieve]
AS
BEGIN
	BEGIN TRY

		DECLARE 
			  @TargetDlgHandle UNIQUEIDENTIFIER
			, @EventId BIGINT
			, @Message NVARCHAR(4000)
			, @MessageType Sysname
			, @ReplyMessage NVARCHAR(4000)
			, @ReplyMessageName Sysname
			, @Xml XML; 
		
		BEGIN TRAN; 

		--Receive
		RECEIVE TOP(1)
			@TargetDlgHandle = Conversation_Handle,
			@Message = Message_Body,
			@MessageType = Message_Type_Name
		FROM 
			dbo.CreateOrderReportTargetQueueWWI; 

		-- Parse
		
		SET @Xml = CAST(@Message AS XML);

		SELECT 
			@EventId = R.Iv.value('@EventId','BIGINT')
		FROM 
			@Xml.nodes('/RequestMessage/EventId') as R(Iv);

		-- Process
		EXEC [Report].[p_OrderReport_Create] @EventId;

		-- Confirm
		IF @MessageType=N'//WWI/SB/CreateOrderReportRequestMessage'
		BEGIN
			SELECT @ReplyMessage = 
				(
					SELECT 0 AS ResultCode
					FOR XML PATH('ResponseMessage')
				); 
		
			SEND ON CONVERSATION @TargetDlgHandle
			MESSAGE TYPE [//WWI/SB/CreateOrderReportReplyMessage] (@ReplyMessage);
			END CONVERSATION @TargetDlgHandle;
		END 

		COMMIT TRAN;

	END TRY
	BEGIN CATCH

		DECLARE
			@ErrorNumber   int = error_number()
			, @ErrorSeverity int = error_severity()
			, @ErrorState    int = error_state();
			
		EXEC [Log].[p_error_save] '[SB].[p_OrderReport_Create_Recieve]', @@ERROR, NULL
		raiserror(@ErrorNumber, @ErrorSeverity, @ErrorState);

	END CATCH
END
GO

CREATE PROCEDURE [SB].[p_OrderReport_Create_Confirm]
AS
BEGIN
	BEGIN TRY
		DECLARE 
			  @InitiatorReplyDlgHandle UNIQUEIDENTIFIER
			, @ReplyReceivedMessage NVARCHAR(1000) 
		
		BEGIN TRAN; 

			RECEIVE TOP(1)
				  @InitiatorReplyDlgHandle = Conversation_Handle
				, @ReplyReceivedMessage = Message_Body
			FROM 
				dbo.CreateOrderReportInitiatorQueueWWI; 
			
			END CONVERSATION @InitiatorReplyDlgHandle; 

		COMMIT TRAN; 

	END TRY
	BEGIN CATCH

		DECLARE
			@ErrorNumber   int = error_number()
			, @ErrorSeverity int = error_severity()
			, @ErrorState    int = error_state();
			
		EXEC [Log].[p_error_save] '[SB].[p_OrderReport_Create_Confirm]', @@ERROR, NULL
		raiserror(@ErrorNumber, @ErrorSeverity, @ErrorState);

	END CATCH
END
GO

CREATE PROCEDURE [Report].[p_Order_GetByBusinessUnit]
(
	@BusinessUnitId BIGINT = NULL
)
AS
BEGIN
	BEGIN TRY
		IF @BusinessUnitId IS NULL
			BEGIN
				SELECT 
					  o.[Date]                      AS [Date]
					, o.[Sum]                       AS [Sum]
					, o.[SellerBusinessUnitId]      AS [SellerBusinessUnitId]
					, o.[SellerFullName]            AS [SellerFullName]
					, o.[SellerBusinessUnitName]    AS [SellerBusinessUnitName]
					, o.[ClientBusinessUnitId]      AS [ClientBusinessUnitId]
					, o.[ClientFullName]            AS [ClientFullName]
					, o.[ClientBusinessUnitName]    AS [ClientBusinessUnitName]
				FROM [Report].[Order] o WITH(NOLOCK)
			END;
		ELSE
			BEGIN
				SELECT 
					  o.[Date]                      AS [Date]
					, o.[Sum]                       AS [Sum]
					, o.[SellerBusinessUnitId]      AS [SellerBusinessUnitId]
					, o.[SellerFullName]            AS [SellerFullName]
					, o.[SellerBusinessUnitName]    AS [SellerBusinessUnitName]
					, o.[ClientBusinessUnitId]      AS [ClientBusinessUnitId]
					, o.[ClientFullName]            AS [ClientFullName]
					, o.[ClientBusinessUnitName]    AS [ClientBusinessUnitName]
				FROM [Report].[Order] o WITH(NOLOCK)
				WHERE o.[SellerBusinessUnitId] = @BusinessUnitId
			END;

	END TRY
	BEGIN CATCH

		DECLARE
			@ErrorNumber   int = error_number()
			, @ErrorSeverity int = error_severity()
			, @ErrorState    int = error_state();
			
		EXEC [Log].[p_error_save] '[Report].[p_Order_GetByBusinessUnit]', @@ERROR, NULL
		raiserror(@ErrorNumber, @ErrorSeverity, @ErrorState);

	END CATCH
END
GO
