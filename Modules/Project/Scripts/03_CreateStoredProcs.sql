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
				(@Id, 3, 2, @BuyerId, 1);

			-- Added Seller
			INSERT INTO [Event].[Invite]
				([EventId], [TypeId], [StatusId], [PersonId], [IsRequired])
			VALUES
				(@Id, 4, 2, @SellerId, 1);

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
GO
