/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "03 - Подзапросы, CTE, временные таблицы".

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
-- Для всех заданий, где возможно, сделайте два варианта запросов:
--  1) через вложенный запрос
--  2) через WITH (для производных таблиц)
-- ---------------------------------------------------------------------------

USE WideWorldImporters

/*
1. Выберите сотрудников (Application.People), которые являются продажниками (IsSalesPerson), 
и не сделали ни одной продажи 04 июля 2015 года. 
Вывести ИД сотрудника и его полное имя. 
Продажи смотреть в таблице Sales.Invoices.
*/

DECLARE @SalesDay DATE = '20150704'
;


SELECT
	p.[PersonID]     AS [PersonID]
	, p.[FullName]   AS [FullName]
FROM
	Application.People p WITH (NOLOCK)
WHERE 1=1
	AND p.[IsSalesperson] = 1
	AND p.[PersonID] != ALL 
		(
			SELECT DISTINCT
				i.[SalespersonPersonID]
			FROM
				Sales.Invoices i WITH (NOLOCK)
			WHERE 1=1
				AND i.[SalespersonPersonID] IS NOT NULL
				AND i.[InvoiceDate] = @SalesDay
		)
;


WITH SalesPersonByDayCTE AS
(
	SELECT DISTINCT
		i.[SalespersonPersonID] AS ID
	FROM
		Sales.Invoices i WITH (NOLOCK)
	WHERE 1=1
		AND i.[SalespersonPersonID] IS NOT NULL
		AND i.[InvoiceDate] = @SalesDay
)
SELECT
	p.[PersonID]     AS [PersonID]
	, p.[FullName]   AS [FullName]
FROM
	Application.People p WITH (NOLOCK)
WHERE 1=1
	AND p.[IsSalesperson] = 1
	AND p.[PersonID] != ALL (SELECT [ID] FROM SalesPersonByDayCTE)
;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------

/*
2. Выберите товары с минимальной ценой (подзапросом). Сделайте два варианта подзапроса. 
Вывести: ИД товара, наименование товара, цена.
*/

SELECT
	si.[StockItemID]       AS [StockItemID]
	, si.[StockItemName]   AS [StockItemName]
	, si.[UnitPrice]       AS [UnitPrice] 
FROM
	Warehouse.StockItems si WITH (NOLOCK)
WHERE
	si.[UnitPrice] = (SELECT MIN([UnitPrice]) FROM Warehouse.StockItems)
;


WITH MinimalPriceCTE (Amount) AS  
(
	SELECT MIN([UnitPrice]) AS Amount FROM Warehouse.StockItems
)
SELECT
	si.[StockItemID]       AS [StockItemID]
	, si.[StockItemName]   AS [StockItemName]
	, si.[UnitPrice]       AS [UnitPrice] 
FROM
	Warehouse.StockItems si WITH (NOLOCK)
WHERE
	si.[UnitPrice] = (SELECT [Amount] FROM MinimalPriceCTE)
;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------

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

-- ------------------------------------------------------------------------------------------------------------------------------------------------------

/*
4. Выберите города (ид и название), в которые были доставлены товары, 
входящие в тройку самых дорогих товаров, а также имя сотрудника, 
который осуществлял упаковку заказов (PackedByPersonID).
*/

DECLARE @TopRich INT = 3;


SELECT DISTINCT
	c.[CityID]      as [City ID]
	, c.[CityName]  as [City Name]
	, p.[FullName]  as [Packager Name]
FROM
	Application.Cities c WITH (NOLOCK)
	LEFT JOIN Sales.Customers csm WITH (NOLOCK)     ON csm.[DeliveryCityID] = c.[CityID]
	LEFT JOIN Sales.Invoices i WITH (NOLOCK)        ON i.[CustomerID] = csm.[CustomerID]
	LEFT JOIN Sales.InvoiceLines il WITH (NOLOCK)   ON il.[StockItemID] = i.[InvoiceID]
	LEFT JOIN Application.People p WITH (NOLOCK)    ON p.[PersonID] = i.[PackedByPersonID]
WHERE 1=1
	AND il.[StockItemID] = ANY (SELECT TOP (@TopRich) si.[StockItemID] AS ID FROM Warehouse.StockItems si ORDER BY si.[UnitPrice] DESC)
;


WITH TopRichItems (ID) AS 
(
    SELECT TOP (@TopRich) 
        si.[StockItemID]
    FROM 
        Warehouse.StockItems si 
    ORDER BY 
        si.[UnitPrice] DESC
)
SELECT DISTINCT
	c.[CityID]      as [City ID]
	, c.[CityName]  as [City Name]
	, p.[FullName]  as [Packager Name]
FROM
	Application.Cities c WITH (NOLOCK)
	LEFT JOIN Sales.Customers csm WITH (NOLOCK)    ON csm.[DeliveryCityID] = c.[CityID]
	LEFT JOIN Sales.Invoices i WITH (NOLOCK)       ON i.[CustomerID] = csm.[CustomerID]
	LEFT JOIN Sales.InvoiceLines il WITH (NOLOCK)  ON il.[StockItemID] = i.[InvoiceID]
	LEFT JOIN Application.People p WITH (NOLOCK)   ON p.[PersonID] = i.[PackedByPersonID]
WHERE 1=1
	AND il.[StockItemID] = ANY (SELECT * FROM TopRichItems)
;


-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------
-- Опциональное задание
-- ---------------------------------------------------------------------------
-- Можно двигаться как в сторону улучшения читабельности запроса, 
-- так и в сторону упрощения плана\ускорения. 
-- Сравнить производительность запросов можно через SET STATISTICS IO, TIME ON. 
-- Если знакомы с планами запросов, то используйте их (тогда к решению также приложите планы). 
-- Напишите ваши рассуждения по поводу оптимизации. 

-- 5. Объясните, что делает и оптимизируйте запрос

SELECT 
	Invoices.InvoiceID, 
	Invoices.InvoiceDate,
	(SELECT People.FullName
		FROM Application.People
		WHERE People.PersonID = Invoices.SalespersonPersonID
	) AS SalesPersonName,
	SalesTotals.TotalSumm AS TotalSummByInvoice, 
	(SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
		FROM Sales.OrderLines
		WHERE OrderLines.OrderId = (SELECT Orders.OrderId 
			FROM Sales.Orders
			WHERE Orders.PickingCompletedWhen IS NOT NULL	
				AND Orders.OrderId = Invoices.OrderId)	
	) AS TotalSummForPickedItems
FROM Sales.Invoices 
	JOIN
	(SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
	FROM Sales.InvoiceLines
	GROUP BY InvoiceId
	HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals
		ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC

-- --

/*

    Запрос выводит суммы по выставленным счетам и относящимся к ним заказам,
    если сумма выставаленного счёт больше, чем указанное значение. 

*/

DECLARE @MinimalInvoiceSumm INT = 27000;

DROP TABLE IF EXISTS #InvoicesSumm;
CREATE TABLE #InvoicesSumm 
(
    [InvoiceId] INT
    , [InvoiceSumm] INT
);

INSERT INTO #InvoicesSumm (InvoiceId, InvoiceSumm)
(
	SELECT 
		il.[InvoiceId]
		, SUM(il.[Quantity] * il.[UnitPrice])
	FROM 
		Sales.InvoiceLines il
	GROUP BY 
		il.[InvoiceId]
	HAVING 
		SUM(il.[Quantity] * il.[UnitPrice]) > @MinimalInvoiceSumm 
);

WITH CompletedOrdersSumm (ID, Summ) AS
(
	SELECT 
		ol.[OrderID]
		, SUM(ol.[PickedQuantity] * ol.[UnitPrice])	AS [Summ]
	FROM 
		Sales.OrderLines ol
    WHERE 
        EXISTS (SELECT 1 FROM Sales.Orders o WHERE o.[OrderId] = ol.[OrderID] AND o.[PickingCompletedWhen] IS NOT NULL)
	GROUP BY
		ol.[OrderID]
)
SELECT 
	i.[InvoiceID]         AS [InvoiceID]
	, i.[InvoiceDate]     AS [InvoiceDate]
	, p.[FullName]        AS [SalesPersonName]
	, isum.[InvoiceSumm]  AS [TotalSummByInvoice]
	, cosum.[Summ]        AS [TotalSummForPickedItems]
FROM 
	#InvoicesSumm isum              
    LEFT JOIN Sales.Invoices i            ON isum.[InvoiceID] = i.[InvoiceID]
    LEFT JOIN Application.People p        ON p.[PersonID] = i.[SalespersonPersonID]
    LEFT JOIN CompletedOrdersSumm cosum   ON cosum.[ID] = i.[OrderID]
ORDER BY 
	[TotalSummByInvoice] DESC


DROP TABLE IF EXISTS #InvoicesSumm;

GO
