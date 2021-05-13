/*
4. ¬ыберите по каждому клиенту два самых дорогих товара, которые он покупал.
¬ результатах должно быть ид клиета, его название, ид товара, цена, дата покупки.
*/

DECLARE @TopSize int = 2;

SELECT
    c.[CustomerID]
    , p.[Name]
    , p.[ID]
    , p.[Price]
    , p.[Date]
FROM 
    Sales.Customers c WITH (NOLOCK)
    CROSS APPLY 
    (
        SELECT TOP(@TopSize)
            si.[StockItemName]   as [Name]
            , si.[StockItemID]   as [ID]
            , il.[UnitPrice]     as [Price]
            , i.[InvoiceDate]    as [Date]
        FROM 
            Sales.Invoices i
            LEFT JOIN Sales.[InvoiceLines] il WITH (NOLOCK)     ON il.[InvoiceID] = i.[InvoiceID]
            LEFT JOIN Warehouse.[StockItems] si WITH (NOLOCK)   ON si.[StockItemID] = il.[StockItemID]
        WHERE 1=1
            AND i.[CustomerID] = c.[CustomerID]
    ) AS p
ORDER BY 
    c.[CustomerID]
    


--SELECT * FROM Sales.Invoices
--SELECT * FROM Sales.InvoiceLines


--SELECT * FROM Sales.Orders
--SELECT * FROM Sales.OrderLines