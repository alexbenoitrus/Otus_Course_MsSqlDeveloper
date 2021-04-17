
/*
3. Заказы (Orders) с ценой товара (UnitPrice) более 100$ 
либо количеством единиц (Quantity) товара более 20 штук
и присутствующей датой комплектации всего заказа (PickingCompletedWhen).
Вывести:
* OrderID
* дату заказа (OrderDate) в формате ДД.ММ.ГГГГ
* название месяца, в котором был сделан заказ
* номер квартала, в котором был сделан заказ
* треть года, к которой относится дата заказа (каждая треть по 4 месяца)
* имя заказчика (Customer)
Добавьте вариант этого запроса с постраничной выборкой,
пропустив первую 1000 и отобразив следующие 100 записей.

Сортировка должна быть по номеру квартала, трети года, дате заказа (везде по возрастанию).

Таблицы: Sales.Orders, Sales.OrderLines, Sales.Customers.
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