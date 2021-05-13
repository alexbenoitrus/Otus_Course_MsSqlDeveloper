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
    [year] int,
    [month] int,
    [sum] decimal
)

DROP TABLE IF EXISTS #SumByMonthWithAccretion
CREATE TABLE #SumByMonthWithAccretion
(
    [year] int,
    [month] int,
    [sum] decimal
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
    s.[year] AS [Year]
    , s.[month] AS [Month]
    , sa.[AccretionSum] as [Sum]
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
    ) as sa

SELECT DISTINCT
    i.[InvoiceDate]    AS [Дата продажи]
    , s.[sum]          AS [Нарастающий итог по месяцу]
FROM 
    Sales.Invoices i WITH (NOLOCK)
    LEFT JOIN #SumByMonthWithAccretion s ON YEAR(i.InvoiceDate) = s.[year] AND MONTH(i.[InvoiceDate]) = s.[month]
WHERE
    i.[InvoiceDate] >= @LowerBorder
ORDER BY 1