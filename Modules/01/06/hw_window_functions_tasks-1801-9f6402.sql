/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "06 - Оконные функции".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
Нужен WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- Задание - написать выборки для получения указанных ниже данных.
-- ---------------------------------------------------------------------------

set statistics time, io on

USE WideWorldImporters
/*
1. Сделать расчет суммы продаж нарастающим итогом по месяцам с 2015 года 
(в рамках одного месяца он будет одинаковый, нарастать будет в течение времени выборки).
Выведите: id продажи, название клиента, дату продажи, сумму продажи, сумму нарастающим итогом

Пример:
-------------+----------------------------
Дата продажи | Нарастающий итог по месяцу
-------------+----------------------------
 2015-01-29   | 4801725.31
 2015-01-30	 | 4801725.31
 2015-01-31	 | 4801725.31
 2015-02-01	 | 9626342.98
 2015-02-02	 | 9626342.98
 2015-02-03	 | 9626342.98
Продажи можно взять из таблицы Invoices.
Нарастающий итог должен быть без оконной функции.
*/

DECLARE @LowerBorder datetime = DATEFROMPARTS(2015, 01, 01);

DROP TABLE IF EXISTS #SumByMonth
CREATE TABLE #SumByMonth
(
    [year]    int,
    [month]   int,
    [sum]     decimal
)

DROP TABLE IF EXISTS #SumByMonthWithAccretion
CREATE TABLE #SumByMonthWithAccretion
(
    [year]    int,
    [month]   int,
    [sum]     decimal
)

INSERT INTO #SumByMonth ([year], [month], [sum])
SELECT
    YEAR(i.[InvoiceDate])
    , MONTH(i.[InvoiceDate])
    , SUM(s.[InvoiceSum])
FROM 
    Sales.Invoices i WITH (NOLOCK)
    CROSS APPLY 
    (
        SELECT 
            SUM(il.[Quantity] * il.[UnitPrice]) as [InvoiceSum] 
        FROM 
            Sales.InvoiceLines il 
        WHERE 
            il.[InvoiceID] = i.[InvoiceID]
        GROUP BY 
            il.[InvoiceID]
    ) as s
WHERE
    i.[InvoiceDate] >= @LowerBorder
GROUP BY
    YEAR(i.[InvoiceDate])
    , MONTH(i.[InvoiceDate])

INSERT INTO #SumByMonthWithAccretion ([year], [month], [sum])
SELECT
    s.[year]           
    , s.[month]        
    , sa.[AccretionSum]
FROM 
    #SumByMonth s
    CROSS APPLY 
    (
        SELECT
            sum([sum]) as [AccretionSum]
        FROM 
            #SumByMonth
        WHERE
            [month] <= s.[month] and [year] <= s.[year]
    ) AS sa

SELECT DISTINCT
    i.[InvoiceDate]    AS [Дата продажи]
    , s.[sum]          AS [Нарастающий итог по месяцу]
FROM 
    Sales.Invoices i WITH (NOLOCK)
    LEFT JOIN #SumByMonthWithAccretion s ON YEAR(i.InvoiceDate) = s.[year] AND MONTH(i.[InvoiceDate]) = s.[month]
WHERE 1=1
    AND i.[InvoiceDate] >= @LowerBorder
ORDER BY 
    i.[InvoiceDate]

-- ------------------------------------------------------------------------------------------------------------------------------------------------------

/*
2. Сделайте расчет суммы нарастающим итогом в предыдущем запросе с помощью оконной функции.
   Сравните производительность запросов 1 и 2 с помощью set statistics time, io on
*/

SELECT DISTINCT
    i.[InvoiceDate]                                                                         AS [Дата продажи]
    , SUM (ia.[InvoiceAmount])  OVER (ORDER BY YEAR(i.InvoiceDate), MONTH(i.InvoiceDate))    AS [Нарастающий итог по месяцу]
FROM
    Sales.Invoices i WITH (NOLOCK)
    CROSS APPLY 
    (
        SELECT TOP(1)
            SUM(il.[Quantity] * il.[UnitPrice]) OVER() as [InvoiceAmount] 
        FROM 
            Sales.InvoiceLines il 
        WHERE 
            il.[InvoiceID] = i.[InvoiceID]
    ) AS ia
WHERE
    i.[InvoiceDate] >= @LowerBorder
ORDER BY 
    i.[InvoiceDate]
    
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

/*
3. Вывести список 2х самых популярных продуктов (по количеству проданных) 
в каждом месяце за 2016 год (по 2 самых популярных продукта в каждом месяце).
*/

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
        year(i.InvoiceDate)       AS [Year]
        , month(i.InvoiceDate)    AS [Month]
        , il.StockItemID          AS [Item]
        , sum(il.Quantity)        AS [Count]
    FROM
        Sales.Invoices i WITH (NOLOCK)
        LEFT JOIN Sales.InvoiceLines il WITH (NOLOCK) ON il.[InvoiceID] = i.[InvoiceID] 
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
    
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

/*
4. Функции одним запросом
Посчитайте по таблице товаров (в вывод также должен попасть ид товара, название, брэнд и цена):
* пронумеруйте записи по названию товара, так чтобы при изменении буквы алфавита нумерация начиналась заново
* посчитайте общее количество товаров и выведете полем в этом же запросе
* посчитайте общее количество товаров в зависимости от первой буквы названия товара
* отобразите следующий id товара исходя из того, что порядок отображения товаров по имени 
* предыдущий ид товара с тем же порядком отображения (по имени)
* названия товара 2 строки назад, в случае если предыдущей строки нет нужно вывести "No items"
* сформируйте 30 групп товаров по полю вес товара на 1 шт

Для этой задачи НЕ нужно писать аналог без аналитических функций.
*/

SELECT
    item.[StockItemID]                                                                                   AS [StockItemID]
    , item.[StockItemName]                                                                               AS [StockItemName]
    , item.[Brand]                                                                                       AS [Brand]
    , item.[UnitPrice]                                                                                   AS [UnitPrice]
    , ROW_NUMBER() OVER(PARTITION BY SUBSTRING(item.StockItemName, 0, 2) ORDER BY item.StockItemName)    AS [Abc Rank]
    , COUNT(1)                            OVER()                                                         AS [Total]
    , COUNT(1)                            OVER(PARTITION BY SUBSTRING(item.StockItemName, 0, 2))         AS [Total in Abc Rank]
	, LAG(item.StockItemID)               OVER(ORDER BY item.StockItemName)                              AS [Prev ID]
	, LEAD(item.StockItemID)              OVER(ORDER BY item.StockItemName)                              AS [Next ID]
	, ISNULL(LAG(item.StockItemName, 2)   OVER(ORDER BY item.StockItemName), '"NO ITEMS"')               AS [Prev 2 Row Name]
    , NTILE(30)                           OVER(ORDER BY item.QuantityPerOuter)                           AS [QPO Group]
FROM
    Warehouse.StockItems item WITH (NOLOCK)
    
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

/*
5. По каждому сотруднику выведите последнего клиента, которому сотрудник что-то продал.
   В результатах должны быть ид и фамилия сотрудника, ид и название клиента, дата продажи, сумму сделки.
*/

DECLARE @IsEmployee bit = 1;

SELECT 
    p.[PersonID]          AS [Seller ID]
    , p.[FullName]        AS [Seller Name]
    , s.[CustomerId]      AS [Customer ID]
    , s.[Name]            AS [Customer Name]
    , s.[InvoiceID]       AS [Invoice ID]
    , s.[Date]            AS [Invoice Date]
    , a.[InvoiceAmount]   AS [Invoice Amount]
FROM
    Application.People p WITH (NOLOCK)
    CROSS APPLY 
    (
        SELECT TOP(1)
            c.[CustomerId]       AS [CustomerId]
            , c.[CustomerName]   AS [Name]
            , i.[InvoiceID]      AS [InvoiceID]
            , i.[InvoiceDate]    AS [Date]
        FROM 
            Sales.Invoices i WITH (NOLOCK)
            JOIN Sales.Customers c WITH (NOLOCK) ON i.[CustomerID] = c.[CustomerID]
        WHERE 
            i.[SalespersonPersonID] = p.[PersonID]
        ORDER BY
            [Date] DESC
    ) as s
    CROSS APPLY
    (        
        SELECT TOP(1)
            i.[InvoiceID]                                   AS [InvoiceID]
            , SUM(il.[Quantity] * il.[UnitPrice]) OVER()    AS [InvoiceAmount]
        FROM 
            Sales.Invoices i WITH (NOLOCK)
            LEFT JOIN Sales.InvoiceLines il WITH (NOLOCK) ON i.[InvoiceID] = il.[InvoiceID]
        WHERE 
            i.[InvoiceID] = s.[InvoiceID]
    ) as a
WHERE
    p.[IsEmployee] = @IsEmployee
    
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

/*
6. Выберите по каждому клиенту два самых дорогих товара, которые он покупал.
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки.
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
        Sales.Customers c WITH (NOLOCK)
        LEFT JOIN Sales.Invoices i WITH (NOLOCK)         ON i.CustomerID = c.CustomerID
        LEFT JOIN Sales.InvoiceLines il WITH (NOLOCK)    ON il.InvoiceID = i.InvoiceID
) AS ut

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

--Опционально можете для каждого запроса без оконных функций сделать вариант запросов с оконными функциями и сравнить их производительность. 