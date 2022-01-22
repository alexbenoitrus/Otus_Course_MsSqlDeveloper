
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