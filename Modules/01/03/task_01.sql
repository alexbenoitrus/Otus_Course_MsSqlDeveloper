/*
1. �������� ����������� (Application.People), ������� �������� ������������ (IsSalesPerson), 
� �� ������� �� ����� ������� 04 ���� 2015 ����. 
������� �� ���������� � ��� ������ ���. 
������� �������� � ������� Sales.Invoices.
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