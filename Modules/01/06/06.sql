/*
6. ¬ыберите по каждому клиенту два самых дорогих товара, которые он покупал.
¬ результатах должно быть ид клиета, его название, ид товара, цена, дата покупки.
*/

DECLARE @TopItemSize int = 2;

DROP TABLE IF EXISTS #ItemTopByCustomer
CREATE TABLE #ItemTopByCustomer
(
    [CustomerID]      int    
    , [StockItemID]   int
    , [UnitPrice]     decimal
    , [Rank]          int
)

INSERT INTO #ItemTopByCustomer ([CustomerID], [StockItemID], [UnitPrice], [Rank])
SELECT 
    ut.CustomerID    
    , ut.StockItemID
    , ut.UnitPrice
    , ROW_NUMBER() OVER (PARTITION BY ut.CustomerID ORDER BY ut.UnitPrice DESC)
FROM
(
    SELECT DISTINCT
        c.CustomerID
        , il.StockItemID
        , il.UnitPrice
    FROM
        Sales.Customers c
        LEFT JOIN Sales.Invoices i         ON i.CustomerID = c.CustomerID
        LEFT JOIN Sales.InvoiceLines il    ON il.InvoiceID = i.InvoiceID
) AS ut

--SELECT
--*
--FROM
--    #CustomerItemTop c
--ORDER BY
--    1
--    , 4

SELECT
    c.[CustomerID]        AS [Customer ID]
    , c.[CustomerName]    AS [Customer Name]
    , t.[StockItemID]     AS [Item ID]
    , t.[UnitPrice]       AS [Item Price]
    , li.[InvoiceDate]    AS [Invoice Date]
FROM
    Sales.Customers c WITH (NOLOCK)
    LEFT JOIN #ItemTopByCustomer t ON t.[CustomerID]= c.[CustomerID] AND t.[Rank] <= @TopItemSize
    CROSS APPLY
    (
        SELECT TOP(1)
            i.[InvoiceDate] AS [InvoiceDate]
        FROM 
            Sales.Invoices i WITH (NOLOCK)
            LEFT JOIN Sales.InvoiceLines il WITH (NOLOCK) ON i.[InvoiceID] = il.[InvoiceID]
        WHERE 1=1
            AND i.[CustomerID] = c.[CustomerID]
            AND il.[StockItemID] = t.[StockItemID]
        ORDER BY
            i.[InvoiceDate]
    ) AS li
ORDER BY
    c.[CustomerID]
    , t.[UnitPrice] DESC