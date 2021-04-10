/*
2. Поставщиков (Suppliers), у которых не было сделано ни одного заказа (PurchaseOrders).
Сделать через JOIN, с подзапросом задание принято не будет.
Вывести: ИД поставщика (SupplierID), наименование поставщика (SupplierName).
Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders.
По каким колонкам делать JOIN подумайте самостоятельно.
*/

SELECT
	s.[SupplierID] as [SupplierID]
FROM 
	Purchasing.Suppliers s WITH (NOLOCK)
	LEFT JOIN Purchasing.PurchaseOrders o WITH (NOLOCK) ON s.[SupplierID] = o.[SupplierID]
GROUP BY s.[SupplierID]
HAVING COUNT(o.[SupplierID]) = 0