
/*
3. ������ (Orders) � ����� ������ (UnitPrice) ����� 100$ 
���� ����������� ������ (Quantity) ������ ����� 20 ����
� �������������� ����� ������������ ����� ������ (PickingCompletedWhen).
�������:
* OrderID
* ���� ������ (OrderDate) � ������� ��.��.����
* �������� ������, � ������� ��� ������ �����
* ����� ��������, � ������� ��� ������ �����
* ����� ����, � ������� ��������� ���� ������ (������ ����� �� 4 ������)
* ��� ��������� (Customer)
�������� ������� ����� ������� � ������������ ��������,
��������� ������ 1000 � ��������� ��������� 100 �������.

���������� ������ ���� �� ������ ��������, ����� ����, ���� ������ (����� �� �����������).

�������: Sales.Orders, Sales.OrderLines, Sales.Customers.
*/

DECLARE @Take INT = 100
DECLARE @Skip INT = 1000

SELECT 
	o.[OrderID]								AS [OrderId]
	, FORMAT(o.[OrderDate], 'dd.MM.yyyy')	AS [OrderDate]
	, DATEPART(QUARTER, o.OrderDate)		AS [Quarter]
	, (((MONTH(o.[OrderDate]) + 3) / 4))	AS [Third]
	, c.[CustomerName]						AS [CustomerName]
FROM
	Sales.Orders o WITH (NOLOCK)
	LEFT JOIN Sales.Customers c WITH (NOLOCK) ON o.[CustomerID] = c.[CustomerID]
WHERE 1=1
	AND o.[OrderID] IN 
		(
			SELECT 
				o.[OrderID]
			FROM
				Sales.Orders o WITH (NOLOCK)
				LEFT JOIN Sales.OrderLines l WITH (NOLOCK) ON o.[OrderID] = l.[OrderID] AND (l.[UnitPrice] > 100 OR l.[Quantity] > 20)
			GROUP BY o.OrderID
		)
	AND o.[PickingCompletedWhen] IS NOT NULL
ORDER BY
	[Quarter]
	, [Third]
	, [OrderDate]
OFFSET @Skip ROWS
FETCH NEXT @Take ROWS ONLY