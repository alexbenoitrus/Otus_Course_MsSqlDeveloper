/*
5. ������ ��������� ������ (�� ���� �������) � ������ ������� � ������ ����������,
������� ������� ����� (SalespersonPerson).
������� ��� �����������.
*/

SELECT TOP(10)
	c.[CustomerName]	AS [CustomerName]
	, p.[FullName]		AS [SalespersonPersonName]
	, i.*
FROM
	Sales.Invoices i WITH (NOLOCK)
	LEFT JOIN Sales.Customers c WITH (NOLOCK)		ON c.[CustomerID] = i.[CustomerID]
	LEFT JOIN Application.People p WITH (NOLOCK)	ON p.[PersonID] = i.[SalespersonPersonID]
ORDER BY
	i.[InvoiceDate] DESC