/*
4. Функции одним запросом
Посчитайте по таблице товаров (в вывод также должен попасть ид товара, название, брэнд и цена):
* + пронумеруйте записи по названию товара, так чтобы при изменении буквы алфавита нумерация начиналась заново
* + посчитайте общее количество товаров и выведете полем в этом же запросе
* + посчитайте общее количество товаров в зависимости от первой буквы названия товара
* + отобразите следующий id товара исходя из того, что порядок отображения товаров по имени 
* + предыдущий ид товара с тем же порядком отображения (по имени)
* названия товара 2 строки назад, в случае если предыдущей строки нет нужно вывести "No items"
* + сформируйте 30 групп товаров по полю вес товара на 1 шт

Для этой задачи НЕ нужно писать аналог без аналитических функций.
*/

SELECT
    item.[StockItemID]                                                                                   AS [StockItemID]
    , item.[StockItemName]                                                                               AS [StockItemName]
    , item.[Brand]                                                                                       AS [Brand]
    , item.[UnitPrice]                                                                                   AS [UnitPrice]
    , ROW_NUMBER() OVER(PARTITION BY SUBSTRING(item.StockItemName, 0, 2) ORDER BY item.StockItemName)    AS [Abc Rank]
    , COUNT(1)                            OVER()                                                         AS [Total]
    , COUNT(1)                            OVER(PARTITION BY SUBSTRING(item.StockItemName, 0, 2))         AS [Total in Abc Rank]
	, LAG(item.StockItemID)               OVER(ORDER BY item.StockItemName)                              AS [Prev ID]
	, LEAD(item.StockItemID)              OVER(ORDER BY item.StockItemName)                              AS [Next ID]
	, ISNULL(LAG(item.StockItemName, 2)   OVER(ORDER BY item.StockItemName), '"NO ITEMS"')               AS [Prev 2 Row Name]
    , NTILE(30)                           OVER(ORDER BY item.QuantityPerOuter)                           AS [QPO Group]
FROM
    Warehouse.StockItems item WITH (NOLOCK)