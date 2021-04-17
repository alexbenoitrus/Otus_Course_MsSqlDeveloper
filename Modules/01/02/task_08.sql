/*
8. Отобразить все месяцы, где общая сумма продаж превысила 10 000

Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Общая сумма продаж

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

SELECT 
	YEAR(i.[InvoiceDate])			AS [Year]
	, MONTH(i.[InvoiceDate])		AS [Month]
	, SUM (ct.TransactionAmount)	AS [Summ of Transaction Amount]
FROM 
	Sales.Invoices i WITH (NOLOCK)
	LEFT JOIN Sales.Orders o WITH (NOLOCK)					ON o.[OrderID] = i.[OrderID]
	LEFT JOIN Sales.OrderLines ol WITH (NOLOCK)				ON ol.[OrderID] = o.[OrderID]
	LEFT JOIN Sales.CustomerTransactions ct WITH (NOLOCK)	ON ct.[InvoiceID] = i.[InvoiceID]
GROUP BY 
	YEAR(i.[InvoiceDate])
	, MONTH(i.[InvoiceDate])
HAVING
	SUM (ct.TransactionAmount) > 10000
ORDER BY 
	[Year]
	, [Month]
