

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