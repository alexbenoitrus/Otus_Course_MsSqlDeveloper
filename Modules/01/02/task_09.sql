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
	t.[Year]					AS [Year]
	, t.[Month]					AS [Month]
	, si.[StockItemName]		AS [StockItemName]
	, t.[InvocesSummByItem]		AS [Summ of Invoices]
	, t.[FirstInvoiceItem]		AS [Date of First Invoice]
	, t.[QuantitySumm]			AS [Summ of Quantity]
FROM
	Warehouse.StockItems si WITH (NOLOCK)			
	LEFT JOIN 
		(
			SELECT 
				YEAR(i.[InvoiceDate])				AS [Year]
				, MONTH(i.[InvoiceDate])			AS [Month]
				, ol.[StockItemID]					AS [StockItemID]
				, SUM (ol.Quantity * ol.UnitPrice)	AS [InvocesSummByItem]
				, MIN (i.[InvoiceDate])				AS [FirstInvoiceItem]
				, SUM (ol.Quantity)					AS [QuantitySumm]
			FROM 
				Sales.Invoices i WITH (NOLOCK)
				LEFT JOIN Sales.Orders o WITH (NOLOCK)					ON o.[OrderID] = i.[OrderID]
				LEFT JOIN Sales.OrderLines ol WITH (NOLOCK)				ON ol.[OrderID] = o.[OrderID]
				LEFT JOIN Sales.CustomerTransactions ct WITH (NOLOCK)	ON ct.[InvoiceID] = i.[InvoiceID]
			GROUP BY 
				YEAR(i.[InvoiceDate])
				, MONTH(i.[InvoiceDate])
				, ol.[StockItemID]
		) t ON si.[StockItemID] = t.[StockItemID]  
ORDER BY 
	[Year] 
	, [Month]
	, t.[StockItemID]