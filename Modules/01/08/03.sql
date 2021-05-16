/*
3. ¬ таблице Warehouse.StockItems в колонке CustomFields есть данные в JSON.
Ќаписать SELECT дл€ вывода:
- StockItemID
- StockItemName
- CountryOfManufacture (из CustomFields)
- FirstTag (из пол€ CustomFields, первое значение из массива Tags)
*/

SELECT 
      si.[StockItemID]                                       AS [ID]
    , si.[StockItemName]                                     AS [Name]
    , JSON_VALUE(si.CustomFields, '$.CountryOfManufacture')  AS [Country]
    , JSON_VALUE(si.CustomFields, '$.Tags[0]')               AS [First Tag]
FROM 
    Warehouse.StockItems si



SELECT 
      si.[StockItemID]    AS [ID]
    , si.[StockItemName]  AS [Name]
    , cf.[Country]        AS [Country]
    , cf.[FirstTag]       AS [First Tag]
FROM 
    Warehouse.StockItems si
    CROSS APPLY
    (   
        SELECT
              Country  AS [Country]
            , FirstTag AS [FirstTag]
        FROM OPENJSON (si.CustomFields)
        WITH (
            Country nvarchar(100)    '$.CountryOfManufacture'   
            , FirstTag nvarchar(100) '$.Tags[0]'   
        )
    ) as cf