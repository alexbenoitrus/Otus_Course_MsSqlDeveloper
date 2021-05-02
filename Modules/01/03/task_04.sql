/*
4. ¬ыберите города (ид и название), в которые были доставлены товары, 
вход€щие в тройку самых дорогих товаров, а также им€ сотрудника, 
который осуществл€л упаковку заказов (PackedByPersonID).
*/


DECLARE @TopRich INT = 5;


WITH TopRichItems (ID) AS 
(
	SELECT TOP (@TopRich)
		si.[StockItemID] AS [ID]
	FROM 
		Warehouse.StockItems si 
	ORDER BY 
		si.[UnitPrice]
)
SELECT DISTINCT
	t.ID
	, csm.[DeliveryCityID] as [City ID]
	, (SELECT [CityName] FROM Application.Cities WHERE [CityID] = csm.[DeliveryCityID]) as [City Name]
	, (SELECT [FullName] FROM Application.People WHERE [PersonID] = i.[PackedByPersonID]) as [Packager Name]
FROM
	TopRichItems t
	LEFT JOIN Sales.InvoiceLines il WITH (NOLOCK) ON il.StockItemID = t.ID
	LEFT JOIN Sales.Invoices i WITH (NOLOCK) ON i.[InvoiceID] = il.[InvoiceID]
	LEFT JOIN Sales.Customers csm WITH (NOLOCK) ON i.[CustomerID] = csm.[CustomerID]
;


--WITH TopRichItems (ID) AS 
--(
--	SELECT TOP (@TopRich)
--		si.[StockItemID] AS [ID]
--	FROM 
--		Warehouse.StockItems si 
--	ORDER BY 
--		si.[UnitPrice]
--)
--SELECT DISTINCT
--	c.[CityID]      as [City ID]
--	, c.[CityName]  as [City Name]
--	, (SELECT [FullName] FROM Application.People WHERE [PersonID] = i.[PackedByPersonID]) as [Packager Name]
--FROM
--	Application.Cities c WITH (NOLOCK)
--	LEFT JOIN Sales.Customers csm WITH (NOLOCK) ON csm.[DeliveryCityID] = c.[CityID]
--	LEFT JOIN Sales.Invoices i WITH (NOLOCK) ON i.[CustomerID] = csm.[CustomerID]
--	LEFT JOIN Sales.InvoiceLines il WITH (NOLOCK) ON il.StockItemID = i.InvoiceID
--WHERE 1=1
--	AND il.[StockItemID] = ANY (SELECT [ID] FROM TopRichItems)
--;


SELECT DISTINCT
	c.[CityID]      as [City ID]
	, c.[CityName]  as [City Name]
	, p.[FullName]  as [Packager Name]
FROM
	Application.Cities c WITH (NOLOCK)
	LEFT JOIN Sales.Customers csm WITH (NOLOCK) ON csm.[DeliveryCityID] = c.[CityID]
	LEFT JOIN Sales.Invoices i WITH (NOLOCK) ON i.[CustomerID] = csm.[CustomerID]
	LEFT JOIN Sales.InvoiceLines il WITH (NOLOCK) ON il.[StockItemID] = i.[InvoiceID]
	LEFT JOIN Application.People p WITH (NOLOCK) ON p.[PersonID] = i.[PackedByPersonID]
WHERE 1=1
	AND il.[StockItemID] = ANY (SELECT TOP (@TopRich) si.[StockItemID] AS ID FROM Warehouse.StockItems si ORDER BY si.[UnitPrice] DESC)
;


WITH TopRichItems (ID) AS 
(
    SELECT TOP (@TopRich) 
        si.[StockItemID]
    FROM 
        Warehouse.StockItems si 
    ORDER BY 
        si.[UnitPrice] DESC
)
SELECT DISTINCT
	c.[CityID]      as [City ID]
	, c.[CityName]  as [City Name]
	, p.[FullName]  as [Packager Name]
FROM
	Application.Cities c WITH (NOLOCK)
	LEFT JOIN Sales.Customers csm WITH (NOLOCK) ON csm.[DeliveryCityID] = c.[CityID]
	LEFT JOIN Sales.Invoices i WITH (NOLOCK) ON i.[CustomerID] = csm.[CustomerID]
	LEFT JOIN Sales.InvoiceLines il WITH (NOLOCK) ON il.[StockItemID] = i.[InvoiceID]
	LEFT JOIN Application.People p WITH (NOLOCK) ON p.[PersonID] = i.[PackedByPersonID]
WHERE 1=1
	AND il.[StockItemID] = ANY (SELECT * FROM TopRichItems)
;



--SELECT DISTINCT
--	c.[CityID]      as [City ID]
--	, c.[CityName]  as [City Name]
--	, p.[FullName]  as [Packager Name]
--FROM
--	Application.Cities c WITH (NOLOCK)
--	LEFT JOIN Sales.Customers csm WITH (NOLOCK) ON csm.[DeliveryCityID] = c.[CityID]
--	LEFT JOIN Sales.Invoices i WITH (NOLOCK) ON i.[CustomerID] = csm.[CustomerID]
--	JOIN Application.People p WITH (NOLOCK) ON p.[PersonID] = i.[PackedByPersonID]
--WHERE 1=1
--    and EXISTS (SELECT TOP(1) * FROM Sales.InvoiceLines il WITH (NOLOCK) 
--        WHERE il.StockItemID = i.InvoiceID 
--    AND il.[StockItemID] IN 
--    (SELECT TOP (@TopRich) si.[StockItemID] AS ID FROM Warehouse.StockItems si ORDER BY si.[UnitPrice] DESC)) 
--;