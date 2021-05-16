/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "08 - Выборки из XML и JSON полей".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
Нужен WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- Задание - написать выборки для получения указанных ниже данных.
-- ---------------------------------------------------------------------------

USE WideWorldImporters

DECLARE @Directory nvarchar(max) = 'C:\Temp\Otus\';

/*
Примечания к заданиям 1, 2:
* Если с выгрузкой в файл будут проблемы, то можно сделать просто SELECT c результатом в виде XML. 
* Если у вас в проекте предусмотрен экспорт/импорт в XML, то можете взять свой XML и свои таблицы.
* Если с этим XML вам будет скучно, то можете взять любые открытые данные и импортировать их в таблицы (например, с https://data.gov.ru).
* Пример экспорта/импорта в файл https://docs.microsoft.com/en-us/sql/relational-databases/import-export/examples-of-bulk-import-and-export-of-xml-documents-sql-server
*/


/*
1. В личном кабинете есть файл StockItems.xml.
Это данные из таблицы Warehouse.StockItems.
Преобразовать эти данные в плоскую таблицу с полями, аналогичными Warehouse.StockItems.
Поля: StockItemName, SupplierID, UnitPackageID, OuterPackageID, QuantityPerOuter, TypicalWeightPerUnit, LeadTimeDays, IsChillerStock, TaxRate, UnitPrice 

Опционально - если вы знакомы с insert, update, merge, то загрузить эти данные в таблицу Warehouse.StockItems.
Существующие записи в таблице обновить, отсутствующие добавить (сопоставлять записи по полю StockItemName). 
*/

DECLARE
      @StockItemFilePath  nvarchar(max) = CONCAT(@Directory, 'stockitems.xml')
    , @EditorUserId       int           = 1
    , @docHandle          int    
    , @OpenXmlCommand     nvarchar(max)
    , @OpenXmlParams      nvarchar(max) = N'@docHandle int OUTPUT'
    , @OpenXmlTemplate    nvarchar(max) = '
DECLARE @xmlDoc xml;
SELECT 
    @xmlDoc = d.[BulkColumn]
FROM
    OPENROWSET(BULK ''%s'', SINGLE_CLOB) as d;

EXEC sp_xml_preparedocument @docHandle OUTPUT, @xmlDoc;
'
;

DROP TABLE IF EXISTS #StockItems_buffer
CREATE TABLE #StockItems_buffer
(
	  [StockItemName]        nvarchar(100)  NOT NULL
    , [SupplierID]           int            NOT NULL
    , [UnitPackageID]        int            NOT NULL
    , [OuterPackageID]       int            NOT NULL
    , [QuantityPerOuter]     int            NOT NULL
    , [LeadTimeDays]         int            NOT NULL
    , [IsChillerStock]       bit            NOT NULL
    , [TaxRate]              decimal(18, 3) NOT NULL
    , [UnitPrice]            decimal(18, 2) NOT NULL
    , [TypicalWeightPerUnit] decimal(18, 3) NOT NULL
);

SET @OpenXmlCommand = FORMATMESSAGE(@OpenXmlTemplate, @StockItemFilePath);
EXEC sp_executesql
    @OpenXmlCommand
    , @OpenXmlParams
    , @docHandle = @docHandle OUTPUT

INSERT INTO #StockItems_buffer
    ([StockItemName], [SupplierID], [UnitPackageID], [OuterPackageID], [QuantityPerOuter], [LeadTimeDays], [IsChillerStock], [TaxRate], [UnitPrice], [TypicalWeightPerUnit])
SELECT 
    *
FROM
    OPENXML(@docHandle, N'StockItems/Item')
    WITH
    (	  
          [StockItemName]         nvarchar(100)   '@Name'
        , [SupplierID]            int             'SupplierID'
        , [UnitPackageID]         int             'Package/UnitPackageID'
        , [OuterPackageID]        int             'Package/OuterPackageID'
        , [QuantityPerOuter]      int             'Package/QuantityPerOuter'
        , [LeadTimeDays]          int             'LeadTimeDays'
        , [IsChillerStock]        bit             'IsChillerStock'
        , [TaxRate]               decimal(18, 3)  'TaxRate'
        , [UnitPrice]             decimal(18, 2)  'UnitPrice'
        , [TypicalWeightPerUnit]  decimal(18, 3)  'Package/TypicalWeightPerUnit'
    )
;

EXEC sp_xml_removedocument @docHandle

MERGE Warehouse.Stockitems AS [target]
    USING #StockItems_buffer AS [source]
    ON 
    (
        [target].[StockItemName] = [source].[StockItemName] COLLATE Cyrillic_General_CI_AS
    )
    WHEN MATCHED THEN
        UPDATE SET
              [target].[StockItemName]        = [source].[StockItemName]       
            , [target].[SupplierID]           = [source].[SupplierID]          
            , [target].[UnitPackageID]        = [source].[UnitPackageID]       
            , [target].[OuterPackageID]       = [source].[OuterPackageID]      
            , [target].[QuantityPerOuter]     = [source].[QuantityPerOuter]    
            , [target].[LeadTimeDays]         = [source].[LeadTimeDays]        
            , [target].[IsChillerStock]       = [source].[IsChillerStock]      
            , [target].[TaxRate]              = [source].[TaxRate]             
            , [target].[UnitPrice]            = [source].[UnitPrice]           
            , [target].[TypicalWeightPerUnit] = [source].[TypicalWeightPerUnit]
    WHEN NOT MATCHED THEN
        INSERT 
        ([StockItemName], [SupplierID], [UnitPackageID], [OuterPackageID], [QuantityPerOuter], [LeadTimeDays], [IsChillerStock], [TaxRate], [UnitPrice], [TypicalWeightPerUnit], [LastEditedBy])
        VALUES
        (
              [source].[StockItemName]
            , [source].[SupplierID]
            , [source].[UnitPackageID]
            , [source].[OuterPackageID]
            , [source].[QuantityPerOuter]
            , [source].[LeadTimeDays]
            , [source].[IsChillerStock]
            , [source].[TaxRate]
            , [source].[UnitPrice]
            , [source].[TypicalWeightPerUnit]
            , @EditorUserId
        )
    OUTPUT 
          $action                   AS [Action]
        , inserted.[StockItemId]    AS [Name]
        , inserted.[StockItemName]  AS [Name]
;

DROP TABLE IF EXISTS #StockItems_buffer;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------

/*
2. Выгрузить данные из таблицы StockItems в такой же xml-файл, как StockItems.xml
*/

DECLARE 
      @ServerName            nvarchar(max) = 'localhost'
    , @BcpCommand            nvarchar(max)
    , @BcpTemplate           nvarchar(max) = 'EXEC master..xp_cmdshell ''bcp "SELECT tb.[dataXml] FROM ##TempBuffer tb" queryout "%s" -T -c -t, -S%s'''
    , @StockItemOutFilePath  nvarchar(max) = CONCAT(@Directory, 'StockItems_out.xml')
;

DROP TABLE IF EXISTS ##TempBuffer 
CREATE TABLE ##TempBuffer
(
    [dataXml] xml
)

INSERT INTO ##TempBuffer ([dataXml])
SELECT
(
    SELECT 
          si.[StockItemName]           AS [@Name]          
        , si.[SupplierID]              AS [SupplierID]
        , si.[UnitPackageID]           AS [Package/UnitPackageID]
        , si.[OuterPackageID]          AS [Package/OuterPackageID]
        , si.[QuantityPerOuter]        AS [Package/QuantityPerOuter]
        , si.[LeadTimeDays]            AS [LeadTimeDays]
        , si.[IsChillerStock]          AS [IsChillerStock]
        , si.[TaxRate]                 AS [TaxRate]
        , si.[UnitPrice]               AS [UnitPrice]
        , si.[TypicalWeightPerUnit]    AS [Package/TypicalWeightPerUnit]
    FROM
        Warehouse.StockItems si WITH (NOLOCK)
    FOR 
        XML PATH('Item'), ROOT('StockItems')
);

SET @BcpCommand = FORMATMESSAGE(@BcpTemplate, @StockItemOutFilePath, @ServerName);

-- -----------(ALLOW CMDSHELL)------------
EXEC master.dbo.sp_configure 'show advanced options', 1
RECONFIGURE
EXEC master.dbo.sp_configure 'xp_cmdshell', 1
RECONFIGURE
-- ---------------------------------------

SELECT @BcpCommand;
EXEC (@BcpCommand);

-- ------------(DENY CMDSHELL)------------
EXEC master.dbo.sp_configure 'xp_cmdshell', 0
RECONFIGURE
EXEC master.dbo.sp_configure 'show advanced options', 0
RECONFIGURE
-- ---------------------------------------

DROP TABLE IF EXISTS ##TempBuffer

-- ------------------------------------------------------------------------------------------------------------------------------------------------------

/*
3. В таблице Warehouse.StockItems в колонке CustomFields есть данные в JSON.
Написать SELECT для вывода:
- StockItemID
- StockItemName
- CountryOfManufacture (из CustomFields)
- FirstTag (из поля CustomFields, первое значение из массива Tags)
*/

SELECT 
      si.[StockItemID]                                       AS [ID]
    , si.[StockItemName]                                     AS [Name]
    , JSON_VALUE(si.CustomFields, '$.CountryOfManufacture')  AS [Country]
    , JSON_VALUE(si.CustomFields, '$.Tags[0]')               AS [First Tag]
FROM 
    Warehouse.StockItems si

-- ------------------------------------------------------------------------------------------------------------------------------------------------------

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
-- Не подходит под задание, но универсально
--
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
-- Подходит под задание, но не универсально
--
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
-- А вот тут вроде и универсально, и подходит под задание
--
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