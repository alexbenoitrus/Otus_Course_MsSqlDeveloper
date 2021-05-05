/*
2. ƒл€ всех клиентов с именем, в котором есть "Tailspin Toys"
вывести все адреса, которые есть в таблице, в одной колонке.

ѕример результата:
----------------------------+--------------------
CustomerName                | AddressLine
----------------------------+--------------------
Tailspin Toys (Head Office) | Shop 38
Tailspin Toys (Head Office) | 1877 Mittal Road
Tailspin Toys (Head Office) | PO Box 8975
Tailspin Toys (Head Office) | Ribeiroville
----------------------------+--------------------
*/

DROP TABLE IF EXISTS #DataForUnpivot
CREATE TABLE #DataForUnpivot
(
    [CustomerName]    nvarchar(100)
    , [Address1]      nvarchar(100)
    , [Address2]      nvarchar(100)
    , [Address3]      nvarchar(100)
    , [Address4]      nvarchar(100)
)

INSERT INTO #DataForUnpivot
    ([CustomerName], [Address1], [Address2], [Address3], [Address4])
SELECT
    c.[CustomerName]
    , c.[DeliveryAddressLine1]
    , c.[DeliveryAddressLine2]
    , c.[PostalAddressLine1]
    , c.[PostalAddressLine2]
FROM
    Sales.Customers c WITH (NOLOCK)
WHERE c.CustomerName LIKE '%Tailspin Toys%'

SELECT 
    [CustomerName]
    , [AddressLine]
FROM #DataForUnpivot
UNPIVOT
(
    [AddressLine] FOR [UndisplayField]
    IN ([Address1], [Address2], [Address3], [Address4])
) AS [UnpivotData];

DROP TABLE IF EXISTS #DataForUnpivot;


WITH DataForUnpivot ([CustomerName], [Address1], [Address2], [Address3], [Address4]) AS 
(
    SELECT
        c.[CustomerName]
        , c.[DeliveryAddressLine1]
        , c.[DeliveryAddressLine2]
        , c.[PostalAddressLine1]
        , c.[PostalAddressLine2]
    FROM
        Sales.Customers c WITH (NOLOCK)
    WHERE c.CustomerName LIKE '%Tailspin Toys%'
)
SELECT 
    [CustomerName]
    , [AddressLine]
FROM DataForUnpivot
UNPIVOT
(
    [AddressLine] FOR [UndisplayField]
    IN ([Address1], [Address2], [Address3], [Address4])
) AS [UnpivotData];