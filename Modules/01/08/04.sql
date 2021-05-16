/*
4. Найти в StockItems строки, где есть тэг "Vintage".
Вывести: 
- StockItemID
- StockItemName
- (опционально) все теги (из CustomFields) через запятую в одном поле

Тэги искать в поле CustomFields, а не в Tags.
Запрос написать через функции работы с JSON.
Для поиска использовать равенство, использовать LIKE запрещено.

Должно быть в таком виде:
... where ... = 'Vintage'

Так принято не будет:
... where ... Tags like '%Vintage%'
... where ... CustomFields like '%Vintage%' 
*/

DECLARE @SearchedTag nvarchar(max) = 'Vintage';

-- #1
SELECT 
      si.[StockItemID]                                         AS [ID]
    , si.[StockItemName]                                       AS [Name]
    , JSON_VALUE(si.CustomFields, '$.CountryOfManufacture')    AS [Country]
    , (
        SELECT STRING_AGG(value, ', ')
        FROM OPENJSON (JSON_QUERY(si.CustomFields, '$.Tags'))
      )                                                        AS [Tags]
FROM 
    Warehouse.StockItems si
WHERE 1=1
    AND @SearchedTag IN (SELECT value as [tags] FROM OPENJSON (JSON_QUERY(si.CustomFields, '$.Tags')))

-- #2
SELECT 
      si.[StockItemID]                                         AS [ID]
    , si.[StockItemName]                                       AS [Name]
    , JSON_VALUE(si.CustomFields, '$.CountryOfManufacture')    AS [Country]
    , (
        SELECT STRING_AGG(value, ', ')
        FROM OPENJSON (JSON_QUERY(si.CustomFields, '$.Tags'))
      )                                                        AS [Tags]
    , JSON_VALUE(si.CustomFields, '$.Tags[0]')                 AS [1st Tag]
    , JSON_VALUE(si.CustomFields, '$.Tags[1]')                 AS [2nd Tag]
    , JSON_VALUE(si.CustomFields, '$.Tags[2]')                 AS [3rd Tag]
    , JSON_VALUE(si.CustomFields, '$.Tags[3]')                 AS [4th Tag]
    , JSON_VALUE(si.CustomFields, '$.Tags[4]')                 AS [5th Tag]
    , JSON_VALUE(si.CustomFields, '$.Tags[5]')                 AS [6th Tag]
    , JSON_VALUE(si.CustomFields, '$.Tags[6]')                 AS [7th Tag]
    , JSON_VALUE(si.CustomFields, '$.Tags[7]')                 AS [8th Tag]
    , JSON_VALUE(si.CustomFields, '$.Tags[8]')                 AS [9th Tag]
    , JSON_VALUE(si.CustomFields, '$.Tags[9]')                 AS [10th Tag]
FROM 
    Warehouse.StockItems si
WHERE 1=1
    AND 
    (
           JSON_VALUE(si.CustomFields, '$.Tags[0]') = @SearchedTag 
        OR JSON_VALUE(si.CustomFields, '$.Tags[1]') = @SearchedTag 
        OR JSON_VALUE(si.CustomFields, '$.Tags[2]') = @SearchedTag 
        OR JSON_VALUE(si.CustomFields, '$.Tags[3]') = @SearchedTag 
        OR JSON_VALUE(si.CustomFields, '$.Tags[4]') = @SearchedTag 
        OR JSON_VALUE(si.CustomFields, '$.Tags[5]') = @SearchedTag 
        OR JSON_VALUE(si.CustomFields, '$.Tags[6]') = @SearchedTag 
        OR JSON_VALUE(si.CustomFields, '$.Tags[7]') = @SearchedTag 
        OR JSON_VALUE(si.CustomFields, '$.Tags[8]') = @SearchedTag 
        OR JSON_VALUE(si.CustomFields, '$.Tags[9]') = @SearchedTag 
    )

-- #3
DROP TABLE IF EXISTS #Tags
CREATE TABLE #Tags
(
      [StockItemID] int
    , [Tag]         nvarchar(max)
)

INSERT INTO #Tags
SELECT 
        si.[StockItemID]
      , t.[value]
FROM 
    Warehouse.StockItems si
    CROSS APPLY 
    (
        SELECT value AS [value]
        FROM OPENJSON (JSON_QUERY(si.CustomFields, '$.Tags'))
    ) AS t

SELECT 
      si.[StockItemID]                                         AS [ID]
    , si.[StockItemName]                                       AS [Name]
    , JSON_VALUE(si.CustomFields, '$.CountryOfManufacture')    AS [Country]
    , (
        SELECT STRING_AGG(value, ', ')
        FROM OPENJSON (JSON_QUERY(si.CustomFields, '$.Tags'))
      )                                                        AS [Tags]
FROM 
    Warehouse.StockItems si
WHERE 1=1
    AND EXISTS (SELECT TOP(1) * FROM #Tags t WHERE t.[StockItemID] = si.[StockItemID] AND t.[Tag] = @SearchedTag)
;

DROP TABLE IF EXISTS #Tags

-- ==================================================================================================================


SELECT 
      si.[StockItemID]                                       AS [ID]
    , si.[StockItemName]                                     AS [Name]
    , t.[tags]                                               AS [Tags]
    , JSON_VALUE(si.CustomFields, '$.CountryOfManufacture')  AS [Country]
FROM 
    Warehouse.StockItems si
    CROSS APPLY
    (
        SELECT
            STRING_AGG(value, ', ') as [tags]
        FROM OPENJSON (JSON_QUERY(si.CustomFields, '$.Tags'))
    ) AS T
WHERE 1=1
    AND 'Vintage' IN (SELECT value as [tags] FROM OPENJSON (JSON_QUERY(si.CustomFields, '$.Tags')))

SELECT 
      si.[StockItemID]    AS [ID]
    , si.[StockItemName]  AS [Name]
    , cf.[Country]        AS [Country]
    , cf.[FirstTag]       AS [First Tag]
    , cf.[Vintage]       AS [Vintage]
FROM 
    Warehouse.StockItems si
    CROSS APPLY
    (   
        SELECT
              Country  AS [Country]
            , FirstTag AS [FirstTag]
            , Vintage AS [Vintage]
        FROM OPENJSON (si.CustomFields)
        WITH (
            Country nvarchar(100)    '$.CountryOfManufacture'   
            , FirstTag nvarchar(100) '$.Tags[0]'   
            , Vintage nvarchar(100)  '$.Vintage'   
        )
    ) as cf


SELECT 
    si.StockItemID
    , CustomFields
    , Tags
    , JSON_QUERY(CustomFields, '$.Tags')
FROM 
    Warehouse.StockItems si



SELECT 
    CustomFields
    , Tags
    , JSON_QUERY(CustomFields, '$.Tags')
FROM 
    Warehouse.StockItems si
    CROSS APPLY
    (   
        SELECT
              Country  AS [Country]
            , FirstTag AS [FirstTag]
            , Vintage AS [Vintage]
        FROM OPENJSON (si.CustomFields)
        WITH (
            Country nvarchar(100)    '$.CountryOfManufacture'   
            , FirstTag nvarchar(100) '$.Tags[0]'   
            , Vintage nvarchar(100)  '$.Vintage'   
        )
    ) as cf
--WHERE JSON_QUERY(CustomFields, '$[~]')
--where Tags like '%Vintage%'
--WHERE StockItemID = 63



--SELECT TOP(1) *
--FROM Warehouse.StockItems
--FOR JSON PATH



DECLARE @Data nvarchar(max) = '["Radio Control","Realistic Sound","Vintage"]';
SELECT * FROM OPENJSON(@Data);

-- ==============================================================================================