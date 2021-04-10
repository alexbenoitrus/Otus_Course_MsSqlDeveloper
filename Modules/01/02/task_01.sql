/*
1. ��� ������, � �������� ������� ���� "urgent" ��� �������� ���������� � "Animal".
�������: �� ������ (StockItemID), ������������ ������ (StockItemName).
�������: Warehouse.StockItems.
*/

SELECT
	si.[StockItemID]		as [StockItemID]
	, si.[StockItemName]	as [StockItemName]
FROM
	Warehouse.StockItems si WITH (NOLOCK)
WHERE 1=1
	AND [StockItemName] LIKE 'Animal%' 
	OR [StockItemName] LIKE '%urgent%'