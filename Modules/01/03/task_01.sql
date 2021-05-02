/*
1. Выберите сотрудников (Application.People), которые являются продажниками (IsSalesPerson), 
и не сделали ни одной продажи 04 июля 2015 года. 
Вывести ИД сотрудника и его полное имя. 
Продажи смотреть в таблице Sales.Invoices.
*/

DECLARE @SalesDay DATE = '20150704'
;

SELECT
	p.[PersonID]     AS [PersonID]
	, p.[FullName]   AS [FullName]
FROM
	Application.People p WITH (NOLOCK)
WHERE 1=1
	AND p.[IsSalesperson] = 1
	AND p.[PersonID] != ALL 
		(
			SELECT DISTINCT
				i.[SalespersonPersonID]
			FROM
				Sales.Invoices i WITH (NOLOCK)
			WHERE 1=1
				AND i.[SalespersonPersonID] IS NOT NULL
				AND i.[InvoiceDate] = @SalesDay
		)
;

WITH SalesPersonByDayCTE AS
(
	SELECT DISTINCT
		i.[SalespersonPersonID] AS [ID]
	FROM
		Sales.Invoices i WITH (NOLOCK)
	WHERE 1=1
		AND i.[SalespersonPersonID] IS NOT NULL
		AND i.[InvoiceDate] = @SalesDay
)
SELECT
	p.[PersonID]     AS [PersonID]
	, p.[FullName]   AS [FullName]
FROM
	Application.People p WITH (NOLOCK)
WHERE 1=1
	AND p.[IsSalesperson] = 1
	AND p.[PersonID] != ALL (SELECT [ID] FROM SalesPersonByDayCTE)
;


SELECT DISTINCT
	i.[SalespersonPersonID] AS ID
FROM
	Sales.Invoices i WITH (NOLOCK)
WHERE 
	i.[InvoiceDate] = '20150704'
;

SELECT
	p.[PersonID] 
FROM
	Application.People p WITH (NOLOCK)
WHERE
	p.[IsSalesperson] = 1
;