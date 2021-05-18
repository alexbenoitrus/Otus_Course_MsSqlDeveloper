/*
���������� � �������� 1, 2:
* ���� � ��������� � ���� ����� ��������, �� ����� ������� ������ SELECT c ����������� � ���� XML. 
* ���� � ��� � ������� ������������ �������/������ � XML, �� ������ ����� ���� XML � ���� �������.
* ���� � ���� XML ��� ����� ������, �� ������ ����� ����� �������� ������ � ������������� �� � ������� (��������, � https://data.gov.ru).
* ������ ��������/������� � ���� https://docs.microsoft.com/en-us/sql/relational-databases/import-export/examples-of-bulk-import-and-export-of-xml-documents-sql-server
*/

/*
2. ��������� ������ �� ������� StockItems � ����� �� xml-����, ��� StockItems.xml
*/

DECLARE @Directory   nvarchar(max) = 'C:\Temp\Otus\';

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

