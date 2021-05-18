/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "07 - Динамический SQL".

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

Это задание из занятия "Операторы CROSS APPLY, PIVOT, UNPIVOT."
Нужно для него написать динамический PIVOT, отображающий результаты по всем клиентам.
Имя клиента указывать полностью из поля CustomerName.

Требуется написать запрос, который в результате своего выполнения 
формирует сводку по количеству покупок в разрезе клиентов и месяцев.
В строках должны быть месяцы (дата начала месяца), в столбцах - клиенты.

Дата должна иметь формат dd.mm.yyyy, например, 25.12.2019.

Пример, как должны выглядеть результаты:
-------------+--------------------+--------------------+----------------+----------------------
InvoiceMonth | Aakriti Byrraju    | Abel Spirlea       | Abel Tatarescu | ... (другие клиенты)
-------------+--------------------+--------------------+----------------+----------------------
01.01.2013   |      3             |        1           |      4         | ...
01.02.2013   |      7             |        3           |      4         | ...
-------------+--------------------+--------------------+----------------+----------------------
*/

DECLARE
       @CustomersNames          nvarchar(MAX)
     , @DynamicSqlQuery         nvarchar(MAX)
;

DROP TABLE IF EXISTS #DataForPivot
CREATE TABLE #DataForPivot
(
      [CustomerName]  nvarchar(max)
    , [InvoiceId]     int
    , [InvoiceMonth]  nvarchar(max)
);


INSERT INTO #DataForPivot ([InvoiceId], [CustomerName], [InvoiceMonth])
SELECT 
      i.[InvoiceID]                                                            AS [InvoiceID]
    , c.[CustomerName]                                                         AS [CustomerName]
    , CONVERT(                                                               
        varchar                                                              
        , DATEFROMPARTS(YEAR(i.[InvoiceDate]), MONTH(i.[InvoiceDate]), 1)      
        , 104 )                                                                AS [InvoiceMonth]
FROM 
    Sales.Customers c WITH (NOLOCK)
    LEFT JOIN Sales.Invoices i WITH (NOLOCK) ON i.[CustomerID] = c.[CustomerID]
;

WITH NamesCte ([Name]) AS 
(
    SELECT DISTINCT dfp.[CustomerName] FROM #DataForPivot dfp
)
SELECT 
    @CustomersNames = STRING_AGG
        (
            CONVERT(
                NVARCHAR(max), 
                QUOTENAME(
                    REPLACE(n.[Name], '''', '''''') ,
                    '[]')),
            ', '
        ) WITHIN GROUP (ORDER BY n.[Name] ASC)
FROM 
    NamesCte n
    
SET @DynamicSqlQuery = '
    SELECT 
         [InvoiceMonth]
         , ' + @CustomersNames + '
     FROM
         #DataForPivot d
     PIVOT 
     (
         COUNT(InvoiceId) 
         FOR CustomerName 
             IN (' + @CustomersNames + ')
     ) AS PivotData';
     
EXEC sp_executesql @DynamicSqlQuery;

DROP TABLE IF EXISTS #DataForPivot;