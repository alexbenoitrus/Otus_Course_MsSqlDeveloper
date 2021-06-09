/*
2) Написать хранимую процедуру с входящим параметром СustomerID, выводящую сумму покупки по этому клиенту.
Использовать таблицы :
Sales.Customers
Sales.Invoices
Sales.InvoiceLines
*/

DROP PROCEDURE IF EXISTS Sales.p_Customer_GetTotalAmount
CREATE PROCEDURE Sales.p_Customer_GetTotalAmount
	@CustomerId int
AS
BEGIN

	WITH InvoicesByCustomerCTO(InvoiceID) AS
	(
		SELECT 
			i.[InvoiceID] 
		FROM 
			Sales.Invoices i WITH (NOLOCK) 
		WHERE 1=1
			AND i.[CustomerID] = @CustomerId
	)
	SELECT TOP(1)
		  CONVERT(decimal, SUM(a.[Amount]) OVER()) as [Amount]
	FROM InvoicesByCustomerCTO i
	CROSS APPLY (
		SELECT TOP(1)
			CONVERT(decimal, SUM(il.[Quantity] * il.[UnitPrice]) OVER()) as [Amount]
		FROM 
			Sales.InvoiceLines il 
		WHERE 1=1 
			AND il.[InvoiceID] = i.[InvoiceID]
	 ) AS a
;

END
GO

EXEC Sales.p_Customer_GetTotalAmount @CustomerId = 12
DROP PROCEDURE IF EXISTS Sales.p_Customer_GetTotalAmount

	--WITH InvoicesByCustomerCTO(InvoiceID) AS
	--(
	--	SELECT 
	--		i.[InvoiceID] 
	--	FROM 
	--		Sales.Invoices i WITH (NOLOCK) 
	--	WHERE 1=1
	--		AND i.[CustomerID] = '12'
	--)
	--SELECT TOP(1)
	--	  CONVERT(decimal, SUM(a.[Amount]) OVER()) as [Amount]
	--FROM InvoicesByCustomerCTO i
	--CROSS APPLY (
	--	SELECT TOP(1)
	--		CONVERT(decimal, SUM(il.[Quantity] * il.[UnitPrice]) OVER()) as [Amount]
	--	FROM 
	--		Sales.InvoiceLines il 
	--	WHERE 1=1 
	--		AND il.[InvoiceID] = i.[InvoiceID]
	-- ) AS a;

	-- WITH InvoicesByCustomerCTO(InvoiceID) AS
	--(
	--	SELECT 
	--		i.[InvoiceID] 
	--	FROM 
	--		Sales.Invoices i WITH (NOLOCK) 
	--	WHERE 1=1
	--		AND i.[CustomerID] = '12'
	--)
	--SELECT
	--	  i.InvoiceID, il.[Quantity], il.[UnitPrice]
	--FROM InvoicesByCustomerCTO i
	--LEFT JOIN Sales.InvoiceLines il ON il.[InvoiceID] = i.[InvoiceID]