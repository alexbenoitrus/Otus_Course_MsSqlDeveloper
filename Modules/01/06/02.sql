/*
Сделать расчет суммы продаж нарастающим итогом по месяцам с 2015 года 
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

/*
2. Сделайте расчет суммы нарастающим итогом в предыдущем запросе с помощью оконной функции.
   Сравните производительность запросов 1 и 2 с помощью set statistics time, io on
*/

DECLARE @LowerBorder datetime = DATEFROMPARTS(2015, 01, 01);

--DROP TABLE IF EXISTS #OrdersSum
--CREATE TABLE #OrdersSum
--(
--    [id] int
--    , [date] date
--    , [sum] decimal
--);

--INSERT INTO #OrdersSum ([id], [date], [sum])
--SELECT
--    i.InvoiceID 
--    , i.InvoiceDate
--    , s.[InvoiceSum]
--FROM 
--    Sales.Invoices i WITH (NOLOCK)
--    CROSS APPLY 
--    (
--        SELECT 
--            SUM(il.[Quantity] * il.[UnitPrice]) as [InvoiceSum] 
--        FROM 
--            Sales.InvoiceLines il 
--        WHERE 
--            il.[InvoiceID] = i.[InvoiceID]
--        GROUP BY 
--            il.[InvoiceID]
--    ) as s
--WHERE
--    i.[InvoiceDate] >= @LowerBorder
--;

--SELECT DISTINCT
--    [date]                                                        AS [Дата продажи]
--    , SUM ([sum])  OVER (ORDER BY YEAR([date]), MONTH([date]))    AS [Нарастающий итог по месяцу]
--FROM
--    #OrdersSum
--ORDER BY 
--    [date]





--INSERT INTO #OrdersSum ([id], [date], [sum])
--SELECT
--    i.InvoiceID 
--    , i.InvoiceDate
--    , s.[InvoiceSum]
--FROM 
--    Sales.Invoices i WITH (NOLOCK)
--    CROSS APPLY 
--    (
--        SELECT 
--            SUM(il.[Quantity] * il.[UnitPrice]) as [InvoiceSum] 
--        FROM 
--            Sales.InvoiceLines il 
--        WHERE 
--            il.[InvoiceID] = i.[InvoiceID]
--        GROUP BY 
--            il.[InvoiceID]
--    ) as s
--WHERE
--    i.[InvoiceDate] >= @LowerBorder
--;


SELECT DISTINCT
    i.[InvoiceDate]                                                                         AS [Дата продажи]
    , SUM (s.[InvoiceAmount])  OVER (ORDER BY YEAR(i.InvoiceDate), MONTH(i.InvoiceDate))    AS [Нарастающий итог по месяцу]
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
    ) as s
WHERE
    i.[InvoiceDate] >= @LowerBorder
ORDER BY 
    i.[InvoiceDate]