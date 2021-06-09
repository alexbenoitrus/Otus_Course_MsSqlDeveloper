/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "12 - Хранимые процедуры, функции, триггеры, курсоры".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
Нужен WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

USE WideWorldImporters

/*
Во всех заданиях написать хранимую процедуру / функцию и продемонстрировать ее использование.
*/

/*
1) Написать функцию возвращающую Клиента с наибольшей суммой покупки.
*/

DROP FUNCTION IF EXISTS Sales.fn_Customers_GetTopByInoviceAmount;
CREATE FUNCTION Sales.fn_Customers_GetTopByInoviceAmount
(
	@TopSize int
)
RETURNS TABLE AS
RETURN 
	SELECT TOP(@TopSize)
		  i.[InvoiceID]
		, i.[CustomerID]
		, a.[Amount]
	FROM Sales.Invoices i
	CROSS APPLY (
		SELECT TOP(1)
			CONVERT(decimal, SUM(il.[Quantity] * il.[UnitPrice]) OVER()) as [Amount]
		FROM 
			Sales.InvoiceLines il 
		WHERE 1=1 
			AND il.[InvoiceID] = i.[InvoiceID]
	 ) AS a
	 ORDER BY a.Amount DESC
;

SELECT * FROM Sales.fn_Customers_GetTopByInoviceAmount(1);

DROP FUNCTION IF EXISTS Sales.fn_Customers_GetTopByInoviceAmount;

/*
2) Написать хранимую процедуру с входящим параметром СustomerID, выводящую сумму покупки по этому клиенту.
Использовать таблицы :
Sales.Customers
Sales.Invoices
Sales.InvoiceLines
*/

DROP PROCEDURE IF EXISTS Sales.p_Customer_GetTotalAmount
CREATE PROCEDURE Sales.p_Customer_GetTotalAmount
	@CustomerId int
AS
BEGIN

	WITH InvoicesByCustomerCTO(InvoiceID) AS
	(
		SELECT 
			i.[InvoiceID] 
		FROM 
			Sales.Invoices i WITH (NOLOCK) 
		WHERE 1=1
			AND i.[CustomerID] = @CustomerId
	)
	SELECT TOP(1)
		  CONVERT(decimal, SUM(a.[Amount]) OVER()) as [Amount]
	FROM InvoicesByCustomerCTO i
	CROSS APPLY (
		SELECT TOP(1)
			CONVERT(decimal, SUM(il.[Quantity] * il.[UnitPrice]) OVER()) as [Amount]
		FROM 
			Sales.InvoiceLines il 
		WHERE 1=1 
			AND il.[InvoiceID] = i.[InvoiceID]
	 ) AS a
;

EXEC Sales.p_Customer_GetTotalAmount @CustomerId = 12

DROP PROCEDURE IF EXISTS Sales.p_Customer_GetTotalAmount

/*
3) Создать одинаковую функцию и хранимую процедуру, посмотреть в чем разница в производительности и почему.
*/

DROP FUNCTION IF EXISTS Sales.fn_Customers_GetCount
DROP PROCEDURE IF EXISTS Sales.p_Customers_GetCount

CREATE FUNCTION Sales.fn_Customers_GetCount()
RETURNS int AS
BEGIN
	RETURN(SELECT COUNT(1) FROM Sales.Customers)
END

CREATE PROCEDURE Sales.p_Customers_GetCount
AS
BEGIN
	SELECT COUNT(1) AS [Count] FROM Sales.Customers
END

SELECT Sales.fn_Customers_GetCount() AS [Count]
EXEC Sales.p_Customers_GetCount

DROP FUNCTION IF EXISTS Sales.fn_Customers_GetCount
DROP PROCEDURE IF EXISTS Sales.p_Customers_GetCount

/*
4) Создайте табличную функцию покажите как ее можно вызвать для каждой строки result set'а без использования цикла. 
*/

DROP FUNCTION IF EXISTS Sales.fn_Customer_CalculateHash

CREATE FUNCTION Sales.fn_Customer_CalculateHash(@CustomerId int)
RETURNS nvarchar(32)
BEGIN

	DECLARE @IdentityString nvarchar(max);

	SELECT 
		@IdentityString = 
			c.CustomerName
			+ c.DeliveryAddressLine1
			+ c.DeliveryAddressLine2
			+ CONVERT(nvarchar(max), c.DeliveryCityID)
			+ c.FaxNumber
			+ CONVERT(nvarchar(max), c.BuyingGroupID)
	FROM
		Sales.Customers c WITH (NOLOCK)
	WHERE 1=1
		AND c.CustomerID = @CustomerId

	RETURN SUBSTRING(
		master.dbo.fn_varbintohexstr(HASHBYTES('MD5', @IdentityString))
		, 3
		, 32);
END

SELECT 
	c.CustomerID                                      AS [ID]
	, c.CustomerName                                  AS [Name]
	, Sales.fn_Customer_CalculateHash(c.CustomerID)   AS [HashCode]
FROM 
	Sales.Customers c WITH (NOLOCK)

DROP FUNCTION IF EXISTS Sales.fn_Customer_CalculateHash

/*
5) Опционально. Во всех процедурах укажите какой уровень изоляции транзакций вы бы использовали и почему. 
*/
