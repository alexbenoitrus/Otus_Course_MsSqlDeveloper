use WideWorldImporters

--------------------
-- SETTINGS 
--------------------
exec sp_configure 'show advanced options', 1;
reconfigure;

exec sp_configure 'clr enabled', 1;
exec sp_configure 'clr strict security', 0 
reconfigure;

ALTER DATABASE WideWorldImporters SET TRUSTWORTHY ON; 

--------------------
-- CREATE
--------------------

DROP PROCEDURE IF EXISTS dbo.p_ShortLink
DROP ASSEMBLY IF EXISTS SimpleDemoAssembly

CREATE ASSEMBLY LinkShorterAssembly
FROM 'C:\temp\Otus\MsSql\Otus_Clr_LinkShorter.dll'
WITH PERMISSION_SET = EXTERNAL_ACCESS;  

CREATE PROCEDURE dbo.p_ShortLink
(
	  @link      nvarchar(max)
	, @shortLink nvarchar(max) OUTPUT
	, @errorCode int           OUTPUT
	, @errorText nvarchar(max) OUTPUT
)
AS EXTERNAL NAME [LinkShorterAssembly].[Otus_Clr_LinkShorter.LinkShorter].Short;
GO 

--------------------
-- USE
--------------------

DECLARE 
	  @CustomerId  int = 1
	, @Uri nvarchar(max) 
	, @ShortLink   nvarchar(max) 
	, @ErrorCode   int          
	, @ErrorText   nvarchar(max)

SELECT 
	@Uri = c.[WebsiteURL] 
FROM 
	Sales.Customers c WITH (NOLOCK) 
WHERE 
	CustomerID = @CustomerId	

EXEC dbo.p_ShortLink 
	  @link = @Uri
	, @shortLink = @ShortLink  OUTPUT
	, @errorCode = @ErrorCode  OUTPUT
	, @errorText = @ErrorText  OUTPUT

SELECT  
	  @CustomerId   AS [ID]
	, @Uri          AS [Link]
	, @ShortLink    AS [New shortlink]
	, @ErrorCode    AS [Error code]
	, @ErrorText    AS [Error text]

SET @Uri = 'https://otus.ru/lessons/ms-sql-server-razrabotchik/'
EXEC dbo.p_ShortLink 
	  @link = @Uri
	, @shortLink = @ShortLink  OUTPUT
	, @errorCode = @ErrorCode  OUTPUT
	, @errorText = @ErrorText  OUTPUT

SELECT  
	  @Uri  AS [Old link]
	, @ShortLink    AS [New shortlink]
	, @ErrorCode    AS [Error code]
	, @ErrorText    AS [Error text]

SET @Uri = 'Incorrect URI'
EXEC dbo.p_ShortLink 
	  @link = @Uri
	, @shortLink = @ShortLink  OUTPUT
	, @errorCode = @ErrorCode  OUTPUT
	, @errorText = @ErrorText  OUTPUT

SELECT  
	  @Uri  AS [Old link]
	, @ShortLink    AS [New shortlink]
	, @ErrorCode    AS [Error code]
	, @ErrorText    AS [Error text]

--------------------
-- CLEARE
--------------------

DROP ASSEMBLY IF EXISTS SimpleDemoAssembly
DROP PROCEDURE IF EXISTS dbo.p_ShortLink

ALTER DATABASE WideWorldImporters SET TRUSTWORTHY OFF; 
exec sp_configure 'clr strict security', 1 
exec sp_configure 'clr enabled', 0;
reconfigure;

exec sp_configure 'show advanced options', 0;
reconfigure;














-- --------------------------

-- Как посмотреть зарегистрированные сборки 

-- SSMS
-- <DB> -> Programmability -> Assemblies 

-- Посмотреть подключенные сборки (SSMS: <DB> -> Programmability -> Assemblies)
SELECT * FROM sys.assemblies

-- Проверяем, что создали ХП и функцию
SELECT * FROM sys.assembly_modules

-- Посмотреть "код" сборки
-- SSMS: <DB> -> Programmability -> Assemblies -> Script Assembly as -> CREATE To

-- FIX: Идентификатор безопасности владельца базы данных, записанный в базе данных master, отличается от идентификатора безопасности владельца базы данных, записанного в базе данных "WideWorldImporters". Устраните это различие, сбросив владельца базы данных "WideWorldImporters" с помощью инструкции ALTER AUTHORIZATION.
ALTER AUTHORIZATION ON DATABASE::[WideWorldImporters] TO [sa]