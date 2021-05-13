/*
3. Вывести список 2х самых популярных продуктов (по количеству проданных) 
в каждом месяце за 2016 год (по 2 самых популярных продукта в каждом месяце).
*/

--напишите здесь свое решение

DECLARE @ReportLowerBorder datetime = DATEFROMPARTS(2016, 01, 01)
DECLARE @ReportUpperBorder datetime = DATEFROMPARTS(2016, 12, 31)

DROP TABLE IF EXISTS #TopByMonth
CREATE TABLE #TopByMonth
(
    [year]      int
    , [month]   int
    , [itemId]  int
    , [count]   int
    , [rank]    int
)

INSERT INTO #TopByMonth ([year], [month], [itemId], [count], [rank])
SELECT 
    items.[Year]
    , items.[Month]
    , items.[Item]
    , items.[Count]
    , ROW_NUMBER() OVER(PARTITION BY items.[Year], items.[Month] ORDER BY items.[Count] DESC)
FROM
(
    SELECT
        year(i.InvoiceDate)      AS [Year]
        , month(i.InvoiceDate)   AS [Month]
        , il.StockItemID         AS [Item]
        , sum(il.Quantity)       AS [Count]
    FROM
        Sales.Invoices i
        LEFT JOIN Sales.InvoiceLines il ON il.[InvoiceID] = i.[InvoiceID] 
    WHERE 1=1
        AND i.[InvoiceDate] >= @ReportLowerBorder
        AND i.[InvoiceDate] <= @ReportUpperBorder
    GROUP BY 
        year(i.[InvoiceDate])
        , month(i.[InvoiceDate])
        , il.[StockItemID]
) AS items

SELECT DISTINCT
    t.[Year]
    , t.[Month]
    , (SELECT [itemId] FROM #TopByMonth WHERE [year] = t.[year] AND [month] = t.[month] AND [rank] = 1) AS [TOP-1]
    , (SELECT [itemId] FROM #TopByMonth WHERE [year] = t.[year] AND [month] = t.[month] AND [rank] = 2) AS [TOP-2]
FROM 
    #TopByMonth t
ORDER BY 
    t.[Year]



--SELECT DISTINCT
--    t.[Year]
--    , t.[Month]
--    , STRING_AGG([itemId], ', ') OVER(PARTITION BY t.[Year], t.[Month] ROWS BETWEEN UNBOUNDED PRECEDING AND 1 FOLLOWING) AS [TOP]
--FROM 
--    #TopByMonth t
--order by 
--    1



SELECT DISTINCT
    t.[Year]
    , t.[Month]
    , STRING_AGG([itemId], ', ')
FROM 
    #TopByMonth t
GROUP BY
    t.[Year]
    , t.[Month]
order by 
    1


--SELECT * FROM #TopByMonth ORDER BY 1, 2, 5
--SELECT * FROM #TopByMonth t WHERE t.[rank] = 1
--SELECT * FROM #TopByMonth t WHERE t.[rank] = 2

--SELECT
--    i.InvoiceDate
--    , i.InvoiceID
--    , il.StockItemID
--    , il.Quantity
--FROM
--    Sales.Invoices i
--    LEFT JOIN Sales.InvoiceLines il ON il.[InvoiceID] = i.[InvoiceID] 
--WHERE 1=1
--    AND i.InvoiceDate >= '2013-01-01' AND i.InvoiceDate < '2013-02-01'
--    AND il.StockItemID = 1