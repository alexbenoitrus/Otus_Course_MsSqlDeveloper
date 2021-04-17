/*
6. ��� �� � ����� �������� � �� ���������� ��������,
������� �������� ����� "Chocolate frogs 250g".
��� ������ �������� � ������� Warehouse.StockItems.
*/

SELECT DISTINCT
	c.[CustomerID]		AS [CustomerID]
	, c.[CustomerName]	AS [CustomerName]
	, c.[PhoneNumber]	AS [PhoneNumber]
FROM
	Sales.Customers c WITH (NOLOCK)
	LEFT JOIN Sales.Orders o WITH (NOLOCK)			ON o.[CustomerID] = c.[CustomerID] 
	LEFT JOIN Sales.OrderLines ol WITH (NOLOCK)		ON ol.[OrderID] = o.[OrderID]
	LEFT JOIN Warehouse.StockItems si WITH (NOLOCK)	ON si.[StockItemID] = ol.[StockItemID] and si.[StockItemName] = 'Chocolate frogs 250g'
ORDER BY
	[CustomerID]