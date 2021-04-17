/*
1. Все товары, в названии которых есть "urgent" или название начинается с "Animal".
Вывести: ИД товара (StockItemID), наименование товара (StockItemName).
Таблицы: Warehouse.StockItems.
*/

SELECT
	si.[StockItemID]		as [StockItemID]
	, si.[StockItemName]	as [StockItemName]
FROM
	Warehouse.StockItems si WITH (NOLOCK)
WHERE 1=1
	AND [StockItemName] LIKE 'Animal%' 
	OR [StockItemName] LIKE '%urgent%'