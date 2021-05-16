/*
���������� � �������� 1, 2:
* ���� � ��������� � ���� ����� ��������, �� ����� ������� ������ SELECT c ����������� � ���� XML. 
* ���� � ��� � ������� ������������ �������/������ � XML, �� ������ ����� ���� XML � ���� �������.
* ���� � ���� XML ��� ����� ������, �� ������ ����� ����� �������� ������ � ������������� �� � ������� (��������, � https://data.gov.ru).
* ������ ��������/������� � ���� https://docs.microsoft.com/en-us/sql/relational-databases/import-export/examples-of-bulk-import-and-export-of-xml-documents-sql-server
*/


/*
1. � ������ �������� ���� ���� StockItems.xml.
��� ������ �� ������� Warehouse.StockItems.
������������� ��� ������ � ������� ������� � ������, ������������ Warehouse.StockItems.
����: StockItemName, SupplierID, UnitPackageID, OuterPackageID, QuantityPerOuter, TypicalWeightPerUnit, LeadTimeDays, IsChillerStock, TaxRate, UnitPrice 

����������� - ���� �� ������� � insert, update, merge, �� ��������� ��� ������ � ������� Warehouse.StockItems.
������������ ������ � ������� ��������, ������������� �������� (������������ ������ �� ���� StockItemName). 
*/

DECLARE 
      @Directory nvarchar(max) = 'C:\Temp\Otus\'
    , @docHandle          int    
    , @OpenXmlCommand  nvarchar(max)
    , @OpenXmlParams   nvarchar(max) = N'@docHandle int OUTPUT'
    , @OpenXmlTemplate nvarchar(max) = '
DECLARE @xmlDoc xml;
SELECT 
    @xmlDoc = d.[BulkColumn]
FROM
    OPENROWSET(BULK ''%s'', SINGLE_CLOB) as d;

EXEC sp_xml_preparedocument @docHandle OUTPUT, @xmlDoc;
'
;

DECLARE @StockItemFilePath  nvarchar(max) = CONCAT(@Directory, 'stockitems.xml');

DROP TABLE IF EXISTS [dbo].[StockItems_ab]
CREATE TABLE [dbo].[StockItems_ab]
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

INSERT INTO [dbo].[StockItems_ab]
    ([StockItemName], [SupplierID], [UnitPackageID], [OuterPackageID], [QuantityPerOuter], [LeadTimeDays], [IsChillerStock], [TaxRate], [UnitPrice], [TypicalWeightPerUnit])
SELECT 
    *
FROM
    OPENXML(@docHandle, N'StockItems/Item')
    WITH
    (	  
        [StockItemName]           nvarchar(100)   '@Name'
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

SELECT * FROM [dbo].[StockItems_ab];
DROP TABLE IF EXISTS [dbo].[StockItems_ab];