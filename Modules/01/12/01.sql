/*
1) Написать функцию возвращающую Клиента с наибольшей суммой покупки.
*/

CREATE FUNCTION Sales.fn_Customers_GetTopByInoviceAmount
(
	@TopSize int
)
RETURNS TABLE AS
RETURN 
	SELECT TOP(@TopSize)
		  i.[InvoiceID]
		, i.[CustomerID]
		, a.[Amount]
	FROM Sales.Invoices i
	CROSS APPLY (
		SELECT TOP(1)
			CONVERT(decimal, SUM(il.[Quantity] * il.[UnitPrice]) OVER()) as [Amount]
		FROM 
			Sales.InvoiceLines il 
		WHERE 1=1 
			AND il.[InvoiceID] = i.[InvoiceID]
	 ) AS a
	 ORDER BY a.Amount DESC
;

Select * from Sales.fn_Customers_GetTopByInoviceAmount(1);

DROP FUNCTION IF EXISTS Sales.fn_Customers_GetTopByInoviceAmount;