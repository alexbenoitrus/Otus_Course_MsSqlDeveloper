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



--DROP TABLE IF EXISTS #DataForPivot
--CREATE TABLE #DataForPivot
--(
--    [CustomerName] nvarchar(30)
--    , [InvoiceId] int
--    , [InvoiceDate] date
--)


--INSERT INTO #DataForPivot ([InvoiceId], [InvoiceDate], [CustomerName])
--SELECT 
--    i.[InvoiceID]                                                       AS [InvoiceID]
--    , DATEFROMPARTS(YEAR(i.[InvoiceDate]),MONTH(i.[InvoiceDate]),1)     AS [InvoiceDate]
--    , SUBSTRING(
--        SUBSTRING(c.[CustomerName], 0, LEN(c.[CustomerName])) 
--        , CHARINDEX('(', c.[CustomerName]) + 1
--        , LEN(c.[CustomerName]))                                        AS [CustomerName]
--FROM 
--    Sales.Customers c WITH (NOLOCK)
--    LEFT JOIN Sales.Invoices i WITH (NOLOCK) ON i.[CustomerID] = c.[CustomerID]
--WHERE 1=1
--    AND c.[CustomerID] BETWEEN @LowerBorder AND @UpperBorder


--SELECT 
--    CONVERT(varchar, [InvoiceDate], 104) AS [InvoiceMonth]
--    , [Sylvanite, MT], [Peeples Valley, AZ], [Medicine Lodge, KS], [Gasport, NY], [Jessie, ND]
--FROM
--    #DataForPivot d
--PIVOT 
--(
--    COUNT(InvoiceId) 
--    FOR CustomerName 
--        IN ([Sylvanite, MT], [Peeples Valley, AZ], [Medicine Lodge, KS], [Gasport, NY], [Jessie, ND])
--) AS [CustomerPivot];

--DROP TABLE IF EXISTS #DataForPivot;


--WITH DataForPivot ([InvoiceID], [InvoiceMonth], [CustomerName]) AS
--(
--    SELECT 
--        i.[InvoiceID]                                                          AS [InvoiceID]
--        , CONVERT(                                                             
--            varchar                                                            
--            , DATEFROMPARTS(YEAR(i.[InvoiceDate]),MONTH(i.[InvoiceDate]),1)    
--            , 104 )                                                            AS [InvoiceMonth]
--        , SUBSTRING(                                                           
--            SUBSTRING(c.[CustomerName], 0, LEN(c.[CustomerName]))              
--            , CHARINDEX('(', c.[CustomerName]) + 1                             
--            , LEN(c.[CustomerName]))                                           AS [CustomerName]
--    FROM 
--        Sales.Customers c WITH (NOLOCK)
--        LEFT JOIN Sales.Invoices i WITH (NOLOCK) ON i.[CustomerID] = c.[CustomerID]
--    WHERE 1=1
--        AND c.[CustomerID] BETWEEN @LowerBorder AND @UpperBorder
--)
--SELECT 
--    [InvoiceMonth]
--    , [Sylvanite, MT], [Peeples Valley, AZ], [Medicine Lodge, KS], [Gasport, NY], [Jessie, ND]
--FROM
--    DataForPivot
--PIVOT 
--(
--    COUNT(InvoiceId) 
--    FOR CustomerName 
--        IN ([Sylvanite, MT], [Peeples Valley, AZ], [Medicine Lodge, KS], [Gasport, NY], [Jessie, ND])
--) AS [CustomerPivot]

--DROP TABLE IF EXISTS #DataForPivot




--SELECT 
--    SUBSTRING(
--        SUBSTRING(c.[CustomerName], 0, LEN(c.[CustomerName])) 
--        , CHARINDEX('(', c.[CustomerName]) + 1
--        , LEN(c.[CustomerName]))                                        AS [Customer]
--FROM 
--    Sales.Customers c WITH (NOLOCK)
--WHERE 1=1
--    AND c.[CustomerID] BETWEEN @LowerBorder AND @UpperBorder