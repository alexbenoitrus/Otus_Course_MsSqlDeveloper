/*
4) Создайте табличную функцию покажите как ее можно вызвать для каждой строки result set'а без использования цикла. 
*/

DROP FUNCTION IF EXISTS Sales.fn_Customer_CalculateHash

CREATE FUNCTION Sales.fn_Customer_CalculateHash(@CustomerId int)
RETURNS nvarchar(32)
BEGIN

	DECLARE @IdentityString nvarchar(max);

	SELECT 
		@IdentityString = 
			c.CustomerName
			+ c.DeliveryAddressLine1
			+ c.DeliveryAddressLine2
			+ CONVERT(nvarchar(max), c.DeliveryCityID)
			+ c.FaxNumber
			+ CONVERT(nvarchar(max), c.BuyingGroupID)
	FROM
		Sales.Customers c WITH (NOLOCK)
	WHERE 1=1
		AND c.CustomerID = @CustomerId

	RETURN SUBSTRING(
		master.dbo.fn_varbintohexstr(HASHBYTES('MD5', @IdentityString))
		, 3
		, 32);
END

SELECT 
	c.CustomerID                                      AS [ID]
	, c.CustomerName                                  AS [Name]
	, Sales.fn_Customer_CalculateHash(c.CustomerID)   AS [HashCode]
FROM 
	Sales.Customers c WITH (NOLOCK)

DROP FUNCTION IF EXISTS Sales.fn_Customer_CalculateHash