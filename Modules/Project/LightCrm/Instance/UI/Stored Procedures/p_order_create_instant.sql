
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