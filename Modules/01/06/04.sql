/*
4. ������� ����� ��������
���������� �� ������� ������� (� ����� ����� ������ ������� �� ������, ��������, ����� � ����):
* + ������������ ������ �� �������� ������, ��� ����� ��� ��������� ����� �������� ��������� ���������� ������
* + ���������� ����� ���������� ������� � �������� ����� � ���� �� �������
* + ���������� ����� ���������� ������� � ����������� �� ������ ����� �������� ������
* + ���������� ��������� id ������ ������ �� ����, ��� ������� ����������� ������� �� ����� 
* + ���������� �� ������ � ��� �� �������� ����������� (�� �����)
* �������� ������ 2 ������ �����, � ������ ���� ���������� ������ ��� ����� ������� "No items"
* + ����������� 30 ����� ������� �� ���� ��� ������ �� 1 ��

��� ���� ������ �� ����� ������ ������ ��� ������������� �������.
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