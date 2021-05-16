/*
5. ѕо каждому сотруднику выведите последнего клиента, которому сотрудник что-то продал.
   ¬ результатах должны быть ид и фамили€ сотрудника, ид и название клиента, дата продажи, сумму сделки.
*/

DECLARE @IsEmployee bit = 1;

SELECT 
    p.[PersonID]          AS [Seller ID]
    , p.[FullName]        AS [Seller Name]
    , s.[CustomerId]      AS [Customer ID]
    , s.[Name]            AS [Customer Name]
    , s.[InvoiceID]       AS [Invoice ID]
    , s.[Date]            AS [Invoice Date]
    , a.[InvoiceAmount]   AS [Invoice Amount]
FROM
    Application.People p WITH (NOLOCK)
    CROSS APPLY 
    (
        SELECT TOP(1)
            c.[CustomerId]       AS [CustomerId]
            , c.[CustomerName]   AS [Name]
            , i.[InvoiceID]      AS [InvoiceID]
            , i.[InvoiceDate]    AS [Date]
        FROM 
            Sales.Invoices i WITH (NOLOCK)
            JOIN Sales.Customers c WITH (NOLOCK) ON i.[CustomerID] = c.[CustomerID]
        WHERE 
            i.[SalespersonPersonID] = p.[PersonID]
        ORDER BY
            [Date] DESC
    ) as s
    CROSS APPLY
    (        
        SELECT TOP(1)
            i.[InvoiceID]                                   AS [InvoiceID]
            , SUM(il.[Quantity] * il.[UnitPrice]) OVER()    AS [InvoiceAmount]
        FROM 
            Sales.Invoices i WITH (NOLOCK)
            LEFT JOIN Sales.InvoiceLines il WITH (NOLOCK) ON i.[InvoiceID] = il.[InvoiceID]
        WHERE 
            i.[InvoiceID] = s.[InvoiceID]
    ) as a
WHERE
    p.[IsEmployee] = @IsEmployee