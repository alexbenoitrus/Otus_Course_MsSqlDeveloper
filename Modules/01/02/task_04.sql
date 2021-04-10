/*
4. Заказы поставщикам (Purchasing.Suppliers),
которые должны быть исполнены (ExpectedDeliveryDate) в январе 2013 года
с доставкой "Air Freight" или "Refrigerated Air Freight" (DeliveryMethodName)
и которые исполнены (IsOrderFinalized).
Вывести:
* способ доставки (DeliveryMethodName)
* дата доставки (ExpectedDeliveryDate)
* имя поставщика
* имя контактного лица принимавшего заказ (ContactPerson)

Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders, Application.DeliveryMethods, Application.People.
*/

SELECT 
	dm.[DeliveryMethodName]		AS [DeliveryMethodName]
	, o.[ExpectedDeliveryDate]	AS [ExpectedDeliveryDate]
	, s.[SupplierName]			AS [SupplierName]
	, p.[FullName]				AS [FullName]
FROM
	Purchasing.PurchaseOrders o WITH (NOLOCK)
	LEFT JOIN Application.DeliveryMethods dm WITH (NOLOCK) ON dm.[DeliveryMethodID] = o.[DeliveryMethodID] 
	LEFT JOIN Purchasing.Suppliers s WITH (NOLOCK) ON o.[SupplierID] = s.[SupplierID]
	LEFT JOIN Application.People p WITH (NOLOCK) ON o.[ContactPersonID] = p.[PersonID] 
WHERE 1=1
	AND [ExpectedDeliveryDate] BETWEEN '20130101' AND '20130201'
	AND [DeliveryMethodName] IN ('Air Freight', 'Refrigerated Air Freight')
	AND o.[IsOrderFinalized] = 1
	