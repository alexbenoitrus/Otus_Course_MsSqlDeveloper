-- Find data
use Otus_Project_2

SELECT * FROM [Org].[Person];
SELECT * FROM [Catalog].[Product];

-- Declare
DECLARE
	@OrderId BIGINT
	, @Products [TVP].[ProductList]
	, @Buyer BIGINT
	, @Seller BIGINT;

-- INIT
INSERT INTO @Products VALUES (2, 2), (1, 3), (3, 9);
SET @Seller = 1;
SET @Buyer = 3;

-- EXEC
EXEC [UI].[p_order_create_instant]
	@Seller
	, @Buyer
	, NULL
	, @Products
	, @Id = @OrderId OUTPUT;

SELECT 'New order ID' = @OrderId;

SELECT * FROM [Event].[Event] ORDER BY 1 DESC;
SELECT * FROM [Event].[Invite] i WHERE i.[EventId] = @OrderId;
SELECT * FROM [Event].[ProductOnEvent] p where p.[EventId] = @OrderId;


-- EXEC WITH ERROR

SET @Seller = 2;

EXEC [UI].[p_order_create_instant]
	@Seller
	, @Buyer
	, NULL
	, @Products
	, @Id = @OrderId OUTPUT;

SELECT 'New order ID' = @OrderId;

----- =(

SELECT * FROM [Log].[Error]

EXEC [SB].[p_OrderReport_Create_Send] 9