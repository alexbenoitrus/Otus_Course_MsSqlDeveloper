/*
2. ����������� (Suppliers), � ������� �� ���� ������� �� ������ ������ (PurchaseOrders).
������� ����� JOIN, � ����������� ������� ������� �� �����.
�������: �� ���������� (SupplierID), ������������ ���������� (SupplierName).
�������: Purchasing.Suppliers, Purchasing.PurchaseOrders.
�� ����� �������� ������ JOIN ��������� ��������������.
*/

SELECT
	s.[SupplierID] as [SupplierID]
FROM 
	Purchasing.Suppliers s WITH (NOLOCK)
	LEFT JOIN Purchasing.PurchaseOrders o WITH (NOLOCK) ON s.[SupplierID] = o.[SupplierID]
GROUP BY s.[SupplierID]
HAVING COUNT(o.[SupplierID]) = 0