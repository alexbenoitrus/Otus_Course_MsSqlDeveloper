/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.
Занятие "02 - Оператор SELECT и простые фильтры, GROUP BY, HAVING".

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

USE WideWorldImporters

-- ------------------------------------------------------------------------------------------------------------------------------------------------------

/*
1. Все товары, в названии которых есть "urgent" или название начинается с "Animal".
Вывести: ИД товара (StockItemID), наименование товара (StockItemName).
Таблицы: Warehouse.StockItems.
*/

SELECT
	si.[StockItemID]		as [StockItemID]
	, si.[StockItemName]	as [StockItemName]
FROM
	Warehouse.StockItems si WITH (NOLOCK)
WHERE 1=1
	AND [StockItemName] LIKE 'Animal%' 
	OR [StockItemName] LIKE '%urgent%'

-- ------------------------------------------------------------------------------------------------------------------------------------------------------

/*
2. Поставщиков (Suppliers), у которых не было сделано ни одного заказа (PurchaseOrders).
Сделать через JOIN, с подзапросом задание принято не будет.
Вывести: ИД поставщика (SupplierID), наименование поставщика (SupplierName).
Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders.
По каким колонкам делать JOIN подумайте самостоятельно.
*/

SELECT
	s.[SupplierID] as [SupplierID]
FROM 
	Purchasing.Suppliers s WITH (NOLOCK)
	LEFT JOIN Purchasing.PurchaseOrders o WITH (NOLOCK) ON s.[SupplierID] = o.[SupplierID]
GROUP BY s.[SupplierID]
HAVING COUNT(o.[SupplierID]) = 0

-- ------------------------------------------------------------------------------------------------------------------------------------------------------

/*
3. Заказы (Orders) с ценой товара (UnitPrice) более 100$ 
либо количеством единиц (Quantity) товара более 20 штук
и присутствующей датой комплектации всего заказа (PickingCompletedWhen).
Вывести:
* OrderID
* дату заказа (OrderDate) в формате ДД.ММ.ГГГГ
* название месяца, в котором был сделан заказ
* номер квартала, в котором был сделан заказ
* треть года, к которой относится дата заказа (каждая треть по 4 месяца)
* имя заказчика (Customer)
Добавьте вариант этого запроса с постраничной выборкой,
пропустив первую 1000 и отобразив следующие 100 записей.

Сортировка должна быть по номеру квартала, трети года, дате заказа (везде по возрастанию).

Таблицы: Sales.Orders, Sales.OrderLines, Sales.Customers.
*/

DECLARE @Take INT = 100
DECLARE @Skip INT = 1000

SELECT 
	o.[OrderID]                              AS [OrderId]
	, FORMAT(o.[OrderDate], 'dd.MM.yyyy')    AS [OrderDate]
	, DATEPART(QUARTER, o.OrderDate)         AS [Quarter]
	, (((MONTH(o.[OrderDate]) + 3) / 4))     AS [Third]
	, c.[CustomerName]                       AS [CustomerName]
FROM
	Sales.Orders o WITH (NOLOCK)
	LEFT JOIN Sales.Customers c WITH (NOLOCK) ON o.[CustomerID] = c.[CustomerID]
WHERE 1=1
	AND o.[PickingCompletedWhen] IS NOT NULL
	AND o.[OrderID] IN 
		(
			SELECT 
				o.[OrderID]
			FROM
				Sales.Orders o WITH (NOLOCK)
				LEFT JOIN Sales.OrderLines l WITH (NOLOCK) ON o.[OrderID] = l.[OrderID] AND (l.[UnitPrice] > 100 OR l.[Quantity] > 20)
			GROUP BY o.OrderID
		)
ORDER BY
	[Quarter]
	, [Third]
	, [OrderDate]
OFFSET @Skip ROWS
FETCH NEXT @Take ROWS ONLY

-- ------------------------------------------------------------------------------------------------------------------------------------------------------

/*
4. Заказы поставщикам (Purchasing.Suppliers),
которые должны быть исполнены (ExpectedDeliveryDate) в январе 2013 года
с доставкой "Air Freight" или "Refrigerated Air Freight" (DeliveryMethodName)
и которые исполнены (IsOrderFinalized).
Вывести:
* способ доставки (DeliveryMethodName)
* дата доставки (ExpectedDeliveryDate)
* имя поставщика
* имя контактного лица принимавшего заказ (ContactPerson)

Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders, Application.DeliveryMethods, Application.People.
*/

SELECT 
	dm.[DeliveryMethodName]     AS [DeliveryMethodName]
	, o.[ExpectedDeliveryDate]  AS [ExpectedDeliveryDate]
	, s.[SupplierName]          AS [SupplierName]
	, p.[FullName]              AS [FullName]
FROM
	Purchasing.PurchaseOrders o WITH (NOLOCK)
	LEFT JOIN Application.DeliveryMethods dm WITH (NOLOCK)  ON dm.[DeliveryMethodID] = o.[DeliveryMethodID] 
	LEFT JOIN Purchasing.Suppliers s WITH (NOLOCK)          ON o.[SupplierID] = s.[SupplierID]
	LEFT JOIN Application.People p WITH (NOLOCK)            ON o.[ContactPersonID] = p.[PersonID] 
WHERE 1=1
	AND [ExpectedDeliveryDate] BETWEEN '20130101' AND '20130201'
	AND [DeliveryMethodName] IN ('Air Freight', 'Refrigerated Air Freight')
	AND o.[IsOrderFinalized] = 1

-- ------------------------------------------------------------------------------------------------------------------------------------------------------

/*
5. Десять последних продаж (по дате продажи) с именем клиента и именем сотрудника,
который оформил заказ (SalespersonPerson).
Сделать без подзапросов.
*/

SELECT TOP(10)
	c.[CustomerName]    AS [CustomerName]
	, p.[FullName]      AS [SalespersonPersonName]
	, i.*
FROM
	Sales.Invoices i WITH (NOLOCK)
	LEFT JOIN Sales.Customers c WITH (NOLOCK)       ON c.[CustomerID] = i.[CustomerID]
	LEFT JOIN Application.People p WITH (NOLOCK)    ON p.[PersonID] = i.[SalespersonPersonID]
ORDER BY
	i.[InvoiceDate] DESC

-- ------------------------------------------------------------------------------------------------------------------------------------------------------

/*
6. Все ид и имена клиентов и их контактные телефоны,
которые покупали товар "Chocolate frogs 250g".
Имя товара смотреть в таблице Warehouse.StockItems.
*/

SELECT DISTINCT
	c.[CustomerID]        AS [CustomerID]
	, c.[CustomerName]    AS [CustomerName]
	, c.[PhoneNumber]     AS [PhoneNumber]
FROM
	Sales.Customers c WITH (NOLOCK)
	LEFT JOIN Sales.Orders o WITH (NOLOCK)             ON o.[CustomerID] = c.[CustomerID] 
	LEFT JOIN Sales.OrderLines ol WITH (NOLOCK)        ON ol.[OrderID] = o.[OrderID]
	LEFT JOIN Warehouse.StockItems si WITH (NOLOCK)    ON si.[StockItemID] = ol.[StockItemID] and si.[StockItemName] = 'Chocolate frogs 250g'
ORDER BY
	[CustomerID]

-- ------------------------------------------------------------------------------------------------------------------------------------------------------

/*
7. Посчитать среднюю цену товара, общую сумму продажи по месяцам
Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Средняя цена за месяц по всем товарам
* Общая сумма продаж за месяц

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

SELECT 
	YEAR(i.[InvoiceDate])           AS [Year]
	, MONTH(i.[InvoiceDate])        AS [Month]
	, AVG (ol.UnitPrice)            AS [Average of Unit Price]
	, SUM (ct.TransactionAmount)    AS [Summ of Transaction Amount]
FROM 
	Sales.Invoices i WITH (NOLOCK)
	LEFT JOIN Sales.Orders o WITH (NOLOCK)                  ON o.[OrderID] = i.[OrderID]
	LEFT JOIN Sales.OrderLines ol WITH (NOLOCK)             ON ol.[OrderID] = o.[OrderID]
	LEFT JOIN Sales.CustomerTransactions ct WITH (NOLOCK)   ON ct.[InvoiceID] = i.[InvoiceID]
GROUP BY 
	YEAR(i.[InvoiceDate])
	, MONTH(i.[InvoiceDate])
ORDER BY 
	[Year], 
	[Month]

-- ------------------------------------------------------------------------------------------------------------------------------------------------------

/*
8. Отобразить все месяцы, где общая сумма продаж превысила 10 000

Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Общая сумма продаж

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

SELECT 
	YEAR(i.[InvoiceDate])           AS [Year]
	, MONTH(i.[InvoiceDate])        AS [Month]
	, SUM (ct.TransactionAmount)    AS [Summ of Transaction Amount]
FROM 
	Sales.Invoices i WITH (NOLOCK)
	LEFT JOIN Sales.Orders o WITH (NOLOCK)                  ON o.[OrderID] = i.[OrderID]
	LEFT JOIN Sales.OrderLines ol WITH (NOLOCK)             ON ol.[OrderID] = o.[OrderID]
	LEFT JOIN Sales.CustomerTransactions ct WITH (NOLOCK)   ON ct.[InvoiceID] = i.[InvoiceID]
GROUP BY 
	YEAR(i.[InvoiceDate])
	, MONTH(i.[InvoiceDate])
HAVING
	SUM (ct.TransactionAmount) > 10000
ORDER BY 
	[Year], 
	[Month]

-- ------------------------------------------------------------------------------------------------------------------------------------------------------

/*
9. Вывести сумму продаж, дату первой продажи
и количество проданного по месяцам, по товарам,
продажи которых менее 50 ед в месяц.
Группировка должна быть по году,  месяцу, товару.

Вывести:
* Год продажи
* Месяц продажи
* Наименование товара
* Сумма продаж
* Дата первой продажи
* Количество проданного

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

SELECT 
	t.[Year]                    AS [Year]
	, t.[Month]                 AS [Month]
	, si.[StockItemName]        AS [StockItemName]
	, t.[InvocesSummByItem]     AS [Summ of Invoices]
	, t.[FirstInvoiceItem]      AS [Date of First Invoice]
	, t.[QuantitySumm]          AS [Summ of Quantity]
FROM
	Warehouse.StockItems si WITH (NOLOCK)			
	LEFT JOIN 
		(
			SELECT 
				YEAR(i.[InvoiceDate])               AS [Year]
				, MONTH(i.[InvoiceDate])            AS [Month]
				, ol.[StockItemID]                  AS [StockItemID]
				, SUM (ol.Quantity * ol.UnitPrice)  AS [InvocesSummByItem]
				, MIN (i.[InvoiceDate])             AS [FirstInvoiceItem]
				, SUM (ol.Quantity)                 AS [QuantitySumm]
			FROM 
				Sales.Invoices i WITH (NOLOCK)
				LEFT JOIN Sales.Orders o WITH (NOLOCK)                  ON o.[OrderID] = i.[OrderID]
				LEFT JOIN Sales.OrderLines ol WITH (NOLOCK)             ON ol.[OrderID] = o.[OrderID]
				LEFT JOIN Sales.CustomerTransactions ct WITH (NOLOCK)   ON ct.[InvoiceID] = i.[InvoiceID]
			GROUP BY 
				YEAR(i.[InvoiceDate])
				, MONTH(i.[InvoiceDate])
				, ol.[StockItemID]
		) t ON si.[StockItemID] = t.[StockItemID]  
ORDER BY 
	[Year] 
	, [Month]
	, t.[StockItemID]

-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------
-- Опционально
-- ---------------------------------------------------------------------------
/*
Написать запросы 8-9 так, чтобы если в каком-то месяце не было продаж,
то этот месяц также отображался бы в результатах, но там были нули.
*/
