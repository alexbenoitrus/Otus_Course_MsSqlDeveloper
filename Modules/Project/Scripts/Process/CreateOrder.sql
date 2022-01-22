-- Find data

SELECT * FROM [Org].[Person];
SELECT * FROM [Catalog].[Product];

-- Declare
DECLARE
	@OrderId BIGINT
	, @Products [TVP].[ProductList]
	, @Buyer BIGINT
	, @Seller BIGINT;

-- INIT
INSERT INTO @Products VALUES (4, 1);
SET @Seller = 1;
SET @Buyer = 5;

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