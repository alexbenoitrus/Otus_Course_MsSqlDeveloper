/*
3. Выберите информацию по клиентам, которые перевели компании пять максимальных платежей 
из Sales.CustomerTransactions. 
Представьте несколько способов (в том числе с CTE). 
*/

DECLARE @TopSize INT = 5
;

SELECT
	c.[CustomerID]      AS [ID]
	, c.[CustomerName]  AS [Name]
	, c.[WebsiteURL]    AS [URL]
	, c.[CreditLimit]   AS [CreditLimit]
FROM
	Sales.Customers c WITH (NOLOCK)
WHERE 1=1
	AND c.[CustomerID] IN 
		(
			SELECT TOP (@TopSize) 
				cs.[CustomerID] 
			FROM 
				Sales.CustomerTransactions cs WITH (NOLOCK)
			ORDER BY
				cs.[TransactionAmount] DESC
		)
;

WITH TopInvoiceCustomersCTO (ID) AS
(
	SELECT TOP (@TopSize) 
		cs.[CustomerID] AS [ID]
	FROM 
		Sales.CustomerTransactions cs WITH (NOLOCK)
	ORDER BY
		cs.[TransactionAmount] DESC
)
SELECT
	c.[CustomerID]      AS [ID]
	, c.[CustomerName]  AS [Name]
	, c.[WebsiteURL]    AS [URL]
	, c.[CreditLimit]   AS [CreditLimit]
FROM
	Sales.Customers c WITH (NOLOCK)
WHERE 1=1
	AND c.[CustomerID] IN (SELECT [ID] FROM TopInvoiceCustomersCTO)
;