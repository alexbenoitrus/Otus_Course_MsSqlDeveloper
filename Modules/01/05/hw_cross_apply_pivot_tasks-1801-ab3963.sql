/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "05 - Операторы CROSS APPLY, PIVOT, UNPIVOT".

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

/*
1. Требуется написать запрос, который в результате своего выполнения 
формирует сводку по количеству покупок в разрезе клиентов и месяцев.
В строках должны быть месяцы (дата начала месяца), в столбцах - клиенты.

Клиентов взять с ID 2-6, это все подразделение Tailspin Toys.
Имя клиента нужно поменять так чтобы осталось только уточнение.
Например, исходное значение "Tailspin Toys (Gasport, NY)" - вы выводите только "Gasport, NY".
Дата должна иметь формат dd.mm.yyyy, например, 25.12.2019.

Пример, как должны выглядеть результаты:
-------------+--------------------+--------------------+-------------+--------------+------------
InvoiceMonth | Peeples Valley, AZ | Medicine Lodge, KS | Gasport, NY | Sylvanite, MT | Jessie, ND
-------------+--------------------+--------------------+-------------+--------------+------------
01.01.2013   |      3             |        1           |      4      |      2        |     2
01.02.2013   |      7             |        3           |      4      |      2        |     1
-------------+--------------------+--------------------+-------------+--------------+------------
*/

DECLARE 
    @UpperBorder     int = 6
    , @LowerBorder   int = 2


DROP TABLE IF EXISTS #DataForPivot
CREATE TABLE #DataForPivot
(
    [CustomerName]    nvarchar(30)
    , [InvoiceId]     int
    , [InvoiceMonth]   nvarchar(max)
)


INSERT INTO #DataForPivot ([InvoiceId], [InvoiceMonth], [CustomerName])
SELECT 
    i.[InvoiceID]                                                            AS [InvoiceID]
    , CONVERT(                                                               
        varchar                                                              
        , DATEFROMPARTS(YEAR(i.[InvoiceDate]), MONTH(i.[InvoiceDate]), 1)      
        , 104 )                                                              AS [InvoiceMonth]
    , SUBSTRING(                                                             
        SUBSTRING(c.[CustomerName], 0, LEN(c.[CustomerName]))                
        , CHARINDEX('(', c.[CustomerName]) + 1 
        , LEN(c.[CustomerName]))                                             AS [CustomerName]
FROM 
    Sales.Customers c WITH (NOLOCK)
    LEFT JOIN Sales.Invoices i WITH (NOLOCK) ON i.[CustomerID] = c.[CustomerID]
WHERE 1=1
    AND c.[CustomerID] BETWEEN @LowerBorder AND @UpperBorder


SELECT 
    [InvoiceMonth]
    , [Sylvanite, MT], [Peeples Valley, AZ], [Medicine Lodge, KS], [Gasport, NY], [Jessie, ND]
FROM
    #DataForPivot d
PIVOT 
(
    COUNT(InvoiceId) 
    FOR CustomerName 
        IN ([Sylvanite, MT], [Peeples Valley, AZ], [Medicine Lodge, KS], [Gasport, NY], [Jessie, ND])
) AS PivotData

DROP TABLE IF EXISTS #DataForPivot

-- ------------------------------------------------------------------------------------------------------------------------------------------------------

/*
2. Для всех клиентов с именем, в котором есть "Tailspin Toys"
вывести все адреса, которые есть в таблице, в одной колонке.

Пример результата:
----------------------------+--------------------
CustomerName                | AddressLine
----------------------------+--------------------
Tailspin Toys (Head Office) | Shop 38
Tailspin Toys (Head Office) | 1877 Mittal Road
Tailspin Toys (Head Office) | PO Box 8975
Tailspin Toys (Head Office) | Ribeiroville
----------------------------+--------------------
*/

WITH DataForUnpivot ([CustomerName], [Address1], [Address2], [Address3], [Address4]) AS 
(
    SELECT
        c.[CustomerName]
        , c.[DeliveryAddressLine1]
        , c.[DeliveryAddressLine2]
        , c.[PostalAddressLine1]
        , c.[PostalAddressLine2]
    FROM
        Sales.Customers c WITH (NOLOCK)
    WHERE c.CustomerName LIKE '%Tailspin Toys%'
)
SELECT 
    [CustomerName]
    , [AddressLine]
FROM DataForUnpivot
UNPIVOT
(
    [AddressLine] FOR [UndisplayField]
    IN ([Address1], [Address2], [Address3], [Address4])
) AS [UnpivotData];

-- ------------------------------------------------------------------------------------------------------------------------------------------------------

/*
3. В таблице стран (Application.Countries) есть поля с цифровым кодом страны и с буквенным.
Сделайте выборку ИД страны, названия и ее кода так, 
чтобы в поле с кодом был либо цифровой либо буквенный код.

Пример результата:
--------------------------------
CountryId | CountryName | Code
----------+-------------+-------
1         | Afghanistan | AFG
1         | Afghanistan | 4
3         | Albania     | ALB
3         | Albania     | 8
----------+-------------+-------
*/

WITH DataForUnpivot ([CountryID], [CountryName], [Code1], [Code2]) AS
(
    SELECT
        c.[CountryID]                              AS [CountryID]
        , c.[CountryName]                          AS [CountryName]
        , CONVERT(nvarchar, c.[IsoAlpha3Code])     AS [Code1]
        , CONVERT(nvarchar, c.[IsoNumericCode])    AS [Code2]
    FROM
        Application.Countries c WITH (NOLOCK)
)
SELECT
    [CountryID]
    , [CountryName]
    , [Code]
FROM DataForUnpivot
UNPIVOT 
(
    [Code] FOR [HiddenField]
        IN ([Code1], [Code2])
) AS UnpivotData;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------

/*
4. Выберите по каждому клиенту два самых дорогих товара, которые он покупал.
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки.
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
