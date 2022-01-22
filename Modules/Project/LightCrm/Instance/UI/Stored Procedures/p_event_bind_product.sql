
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
		EXEC [Log].[p_error_save] '[UI].[p_event_bind_product]', @@ERROR, @Parameters
	END CATCH
END