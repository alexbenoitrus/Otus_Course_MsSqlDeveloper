/*
7. ��������� ������� ���� ������, ����� ����� ������� �� �������
�������:
* ��� ������� (��������, 2015)
* ����� ������� (��������, 4)
* ������� ���� �� ����� �� ���� �������
* ����� ����� ������ �� �����

������� �������� � ������� Sales.Invoices � ��������� ��������.
*/

SELECT 
	YEAR(i.[InvoiceDate])			AS [Year]
	, MONTH(i.[InvoiceDate])		AS [Month]
	, AVG (ol.UnitPrice)			AS [Average of Unit Price]
	, SUM (ct.TransactionAmount)	AS [Summ of Transaction Amount]
FROM 
	Sales.Invoices i WITH (NOLOCK)
	LEFT JOIN Sales.Orders o WITH (NOLOCK)					ON o.[OrderID] = i.[OrderID]
	LEFT JOIN Sales.OrderLines ol WITH (NOLOCK)				ON ol.[OrderID] = o.[OrderID]
	LEFT JOIN Sales.CustomerTransactions ct WITH (NOLOCK)	ON ct.[InvoiceID] = i.[InvoiceID]
GROUP BY 
	YEAR(i.[InvoiceDate])
	, MONTH(i.[InvoiceDate])
ORDER BY 
	[Year]
	, [Month]



	
	select * from Sales.Invoices
	select * from Sales.Orders
	select * from Sales.OrderLines
	select * from.Sales.CustomerTransactions


SELECT 
	i.InvoiceID
	, i.InvoiceDate
	, ol.UnitPrice
	, ct.TransactionAmount
FROM 
	Sales.Invoices i WITH (NOLOCK)
	LEFT JOIN Sales.Orders o ON o.[OrderID] = i.[OrderID]
	LEFT JOIN Sales.OrderLines ol ON ol.[OrderID] = o.[OrderID]
	LEFT JOIN Sales.CustomerTransactions ct ON ct.[InvoiceID] = i.[InvoiceID]
ORDER BY 
	InvoiceID