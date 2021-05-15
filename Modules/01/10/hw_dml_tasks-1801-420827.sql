/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "10 - Операторы изменения данных".

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

DECLARE
      @Mark nvarchar(8) = '_' + SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 9)
;

DECLARE
      @CustomerForUpdate01Sign nvarchar(25) = N'CustomerFU01' + @Mark
    , @CustomerForUpdate02Sign nvarchar(25) = N'CustomerFU02' + @Mark
    , @CustomerForDelete01Sign nvarchar(25) = N'CustomerFD01' + @Mark
    , @CustomerForCreate01Sign nvarchar(25) = N'CustomerFC01' + @Mark
    , @CustomerForCreate02Sign nvarchar(25) = N'CustomerFC02' + @Mark
    , @CustomerForMerge01Sign  nvarchar(25) = N'CustomerFM01' + @Mark

    , @BillToCustomerID        int = 1
    , @AgentCustomerCategoryID int = 3
    , @PrimaryContactId        int = 1
    , @PostDeliveryMethodId    int = 1
    , @StandartDiscount        int = 5
    , @PaymentDays             int = 1
    , @ManagerId               int = 8
    
    , @AccountOpenedDate       date = GETDATE()
                               
    , @TelephoneNumber         nvarchar(20) = N'+1 (555) 555-1234'
    , @FaxNumber               nvarchar(20) = N'+1 (555) 555-4321'
    , @Url                     nvarchar(20) = N'http://ya.ru'
    , @DeliveryAddress         nvarchar(20) = N'st. Arba, 12-403'
    , @DeliveryPostalCode      nvarchar(20) = N'AL'
    , @PostalAddress           nvarchar(20) = N'st. Watson, 5'
    , @PostalPostalCode        nvarchar(20) = N'AL'
                               
    , @AlabamaCityId           int = 259
    , @AberdeenCityId          int = 50

    , @IsStatmentSent          bit = 1
    , @IsOnCreditHold          bit = 1
;

-- ------------(CLEAN DATA)---------------
DELETE FROM Sales.Customers 
WHERE CustomerName in 
(
      @CustomerForUpdate01Sign
    , @CustomerForUpdate02Sign
    , @CustomerForDelete01Sign
    , @CustomerForCreate01Sign
    , @CustomerForCreate02Sign
)
-- ------------(CLEAN DATA)---------------

-- ------------------------------------------------------------------------------------------------------------------------------------------------------

/*
1. Довставлять в базу пять записей используя insert в таблицу Customers или Suppliers 
*/

--SELECT * FROM Sales.Customers

INSERT INTO Sales.Customers 
(
      [CustomerName]
    , [BillToCustomerID]
    , [CustomerCategoryID]
    , [PrimaryContactPersonID]
    , [DeliveryMethodID]
    , [DeliveryCityID]
    , [PostalCityID]
    , [AccountOpenedDate]
    , [StandardDiscountPercentage]
    , [IsStatementSent]
    , [IsOnCreditHold]
    , [PaymentDays]
    , [PhoneNumber]
    , [FaxNumber]
    , [WebsiteURL]
    , [DeliveryAddressLine1]
    , [DeliveryPostalCode]
    , [PostalAddressLine1]
    , [PostalPostalCode]
    , [LastEditedBy]
)
OUTPUT
      inserted.[CustomerID] AS [NewRecord_ID]
VALUES 
      (@CustomerForUpdate01Sign, @BillToCustomerID, @AgentCustomerCategoryID, @PrimaryContactId, @PostDeliveryMethodId, @AlabamaCityId, @AlabamaCityId, @AccountOpenedDate, @StandartDiscount, @IsStatmentSent, @IsOnCreditHold, @PaymentDays, @TelephoneNumber, @FaxNumber, @Url, @DeliveryAddress, @DeliveryPostalCode, @PostalAddress, @PostalPostalCode, @ManagerId)
    , (@CustomerForUpdate02Sign, @BillToCustomerID, @AgentCustomerCategoryID, @PrimaryContactId, @PostDeliveryMethodId, @AlabamaCityId, @AlabamaCityId, @AccountOpenedDate, @StandartDiscount, @IsStatmentSent, @IsOnCreditHold, @PaymentDays, @TelephoneNumber, @FaxNumber, @Url, @DeliveryAddress, @DeliveryPostalCode, @PostalAddress, @PostalPostalCode, @ManagerId)
    , (@CustomerForDelete01Sign, @BillToCustomerID, @AgentCustomerCategoryID, @PrimaryContactId, @PostDeliveryMethodId, @AlabamaCityId, @AlabamaCityId, @AccountOpenedDate, @StandartDiscount, @IsStatmentSent, @IsOnCreditHold, @PaymentDays, @TelephoneNumber, @FaxNumber, @Url, @DeliveryAddress, @DeliveryPostalCode, @PostalAddress, @PostalPostalCode, @ManagerId)
    , (@CustomerForCreate01Sign, @BillToCustomerID, @AgentCustomerCategoryID, @PrimaryContactId, @PostDeliveryMethodId, @AlabamaCityId, @AlabamaCityId, @AccountOpenedDate, @StandartDiscount, @IsStatmentSent, @IsOnCreditHold, @PaymentDays, @TelephoneNumber, @FaxNumber, @Url, @DeliveryAddress, @DeliveryPostalCode, @PostalAddress, @PostalPostalCode, @ManagerId)
    , (@CustomerForCreate02Sign, @BillToCustomerID, @AgentCustomerCategoryID, @PrimaryContactId, @PostDeliveryMethodId, @AlabamaCityId, @AlabamaCityId, @AccountOpenedDate, @StandartDiscount, @IsStatmentSent, @IsOnCreditHold, @PaymentDays, @TelephoneNumber, @FaxNumber, @Url, @DeliveryAddress, @DeliveryPostalCode, @PostalAddress, @PostalPostalCode, @ManagerId)

    
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

/*
2. Удалите одну запись из Customers, которая была вами добавлена
*/

DELETE FROM 
    Sales.Customers
OUTPUT
    deleted.[CustomerID] AS [Deleted_ID]
WHERE 
    [CustomerName] = @CustomerForDelete01Sign

-- ------------------------------------------------------------------------------------------------------------------------------------------------------

/*
3. Изменить одну запись, из добавленных через UPDATE
*/

SELECT 
      c.[DeliveryCityID]
    , c.[IsOnCreditHold]
FROM 
    Sales.Customers c WITH (NOLOCK)
WHERE
    c.[CustomerName] = @CustomerForUpdate01Sign

UPDATE 
    Sales.Customers
SET
      [DeliveryCityID] = @AberdeenCityId
    , [IsOnCreditHold] = 0
OUTPUT
      inserted.[CustomerID]       AS [Updated_ID]
    , inserted.[DeliveryCityID]   AS [NEW_DeliveryCityID]
    , inserted.[IsOnCreditHold]   AS [NEW_IsOnCreditHold]
    , deleted.[DeliveryCityID]    AS [OLD_DeliveryCityID]
    , deleted.[IsOnCreditHold]    AS [OLD_IsOnCreditHold]
WHERE
    CustomerName = @CustomerForUpdate01Sign

-- ------------------------------------------------------------------------------------------------------------------------------------------------------

/*
4. Написать MERGE, который вставит вставит запись в клиенты, если ее там нет, и изменит если она уже есть
*/

--SELECT CONVERT (varchar(256), SERVERPROPERTY('collation')); 

SELECT 
      c.[DeliveryCityID]
    , c.[IsOnCreditHold]
FROM 
    Sales.Customers c WITH (NOLOCK)
WHERE 1=1
    AND c.[CustomerName] IN (@CustomerForUpdate02Sign, @CustomerForMerge01Sign)
;

WITH InputDataCte ([Name], [IsOnCreditHold]) AS
(
    SELECT @CustomerForUpdate02Sign, 0
        UNION
    SELECT @CustomerForMerge01Sign, 0
)    
MERGE Sales.Customers AS [target]
    USING
    (
        SELECT * FROM InputDataCte
    ) AS [source] ([Name], [IsOnCreditHold])
    ON
    (
        target.[CustomerName] = [source].[Name]
    )
    WHEN MATCHED THEN
        UPDATE
            SET [target].[IsOnCreditHold] = [source].[IsOnCreditHold]
    WHEN NOT MATCHED THEN
        INSERT
            ([CustomerName],  [BillToCustomerID], [CustomerCategoryID],     [PrimaryContactPersonID], [DeliveryMethodID],     [DeliveryCityID], [PostalCityID], [AccountOpenedDate], [StandardDiscountPercentage], [IsStatementSent], [IsOnCreditHold],          [PaymentDays], [PhoneNumber],    [FaxNumber], [WebsiteURL], [DeliveryAddressLine1], [DeliveryPostalCode], [PostalAddressLine1], [PostalPostalCode], [LastEditedBy])
            VALUES
            ([source].[Name], @BillToCustomerID,  @AgentCustomerCategoryID, @PrimaryContactId,         @PostDeliveryMethodId, @AlabamaCityId,   @AlabamaCityId, @AccountOpenedDate,  @StandartDiscount,            @IsStatmentSent,   [source].[IsOnCreditHold], @PaymentDays,  @TelephoneNumber, @FaxNumber,  @Url,         @DeliveryAddress,       @DeliveryPostalCode,  @PostalAddress,       @PostalPostalCode,  @ManagerId)

    OUTPUT
          $action                      AS [Action]
        , inserted.[CustomerID]        AS [ID]
        , inserted.[CustomerName]      AS [NEW_CustomerName]
        , inserted.[IsOnCreditHold]    AS [NEW_IsOnCreditHold]
        , deleted.[CustomerName]       AS [OLD_CustomerName]
        , deleted.[IsOnCreditHold]     AS [OLD_IsOnCreditHold]
;

-- ------------(CLEAN DATA)---------------
DELETE FROM Sales.Customers 
WHERE [CustomerName] in 
(
      @CustomerForUpdate01Sign
    , @CustomerForUpdate02Sign
    , @CustomerForDelete01Sign
    , @CustomerForCreate01Sign
    , @CustomerForCreate02Sign
);
-- ---------------------------------------
GO

-- ------------------------------------------------------------------------------------------------------------------------------------------------------

/*
5. Напишите запрос, который выгрузит данные через bcp out и загрузить через bulk insert
*/

-- -----------(ALLOW CMDSHELL)------------
EXEC sp_configure 'show advanced options', 1
RECONFIGURE
EXEC sp_configure 'xp_cmdshell', 1
RECONFIGURE
GO
-- ---------------------------------------

DROP TABLE IF EXISTS dbo.ImportEmployees
CREATE TABLE dbo.ImportEmployees
(
      [FullName]   nvarchar(100)
    , [Login]      nvarchar(100)
)

DECLARE
      @FilePath    nvarchar(200)  = N'C:\Temp\Employees.csv'
    , @ServerName   nvarchar(50)  = N'localhost'
    , @Query        nvarchar(MAX) = N'SELECT p.[FullName] AS [Name],p.[LogonName] AS [Login] FROM [WideWorldImporters].Application.People p WITH(NOLOCK) WHERE p.[IsEmployee]=1'
    , @Terminator   nvarchar(10)  = N','
;

DECLARE 
      @OutCommandFormat     varchar(4000) = N'bcp "%s" queryout "%s" -T -c -t%s -S %s'
    , @OutCommand           varchar(4000)
    , @BulkInsertSqlFormat  nvarchar(300) = N'BULK INSERT dbo.ImportEmployees FROM ''%s'' WITH(FIELDTERMINATOR=''%s'')'
    , @BulkInsertSql        nvarchar(300)
;

SET @BulkInsertSql = FORMATMESSAGE(
    @BulkInsertSqlFormat
    , @FilePath
    , @Terminator)

SET @OutCommand = FORMATMESSAGE(
    @OutCommandFormat
    , @Query
    , @FilePath
    , @Terminator
    , @ServerName)

EXECUTE master..xp_cmdshell @OutCommand
EXECUTE sp_executesql @BulkInsertSql

SELECT * FROM dbo.ImportEmployees
DROP TABLE IF EXISTS dbo.ImportEmployees

GO

-- ------------(DENY CMDSHELL)------------
EXEC sp_configure 'xp_cmdshell', 0
RECONFIGURE
EXEC sp_configure 'show advanced options', 0
RECONFIGURE
GO
-- ---------------------------------------