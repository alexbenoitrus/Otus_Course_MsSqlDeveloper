/*
2. �������� ������ � ����������� ����� (�����������). �������� ��� �������� ����������. 
�������: �� ������, ������������ ������, ����.
*/

SELECT
	si.[StockItemID]       AS [StockItemID]
	, si.[StockItemName]   AS [StockItemName]
	, si.[UnitPrice]       AS [UnitPrice] 
FROM
	Warehouse.StockItems si WITH (NOLOCK)
WHERE
	si.[UnitPrice] = (SELECT MIN([UnitPrice]) FROM Warehouse.StockItems)
;

WITH MinimalPriceCTE (Amount) AS  
(
	SELECT MIN([UnitPrice]) AS Amount FROM Warehouse.StockItems
)
SELECT
	si.[StockItemID]       AS [StockItemID]
	, si.[StockItemName]   AS [StockItemName]
	, si.[UnitPrice]       AS [UnitPrice] 
FROM
	Warehouse.StockItems si WITH (NOLOCK)
WHERE
	si.[UnitPrice] = (SELECT [Amount] FROM MinimalPriceCTE)
;



SELECT [UnitPrice] FROM Warehouse.StockItems ORDER BY 1 