-- ---------------------------------------------------------------------------
-- Опциональное задание
-- ---------------------------------------------------------------------------
-- Можно двигаться как в сторону улучшения читабельности запроса, 
-- так и в сторону упрощения плана\ускорения. 
-- Сравнить производительность запросов можно через SET STATISTICS IO, TIME ON. 
-- Если знакомы с планами запросов, то используйте их (тогда к решению также приложите планы). 
-- Напишите ваши рассуждения по поводу оптимизации. 

-- 5. Объясните, что делает и оптимизируйте запрос


Declare @MinimalInvoiceSumm INT = 27000;


WITH InvoicesSumm (ID, Summ) AS
(
	SELECT 
		i.[InvoiceId]
		, SUM(i.[Quantity] * i.[UnitPrice]) AS TotalSumm
	FROM 
		Sales.InvoiceLines i
	GROUP BY 
		i.[InvoiceId]
	HAVING 
		SUM(i.[Quantity] * i.[UnitPrice]) > @MinimalInvoiceSumm 
),
CompletedOrders (ID) AS 
(
	SELECT 
		o.[OrderId]
	FROM 
		Sales.Orders o
	WHERE 1=1 
		AND o.[PickingCompletedWhen] IS NOT NULL
),
CompletedOrdersSumm (ID, Summ) AS
(
	SELECT 
		ol.[OrderID]
		, SUM(ol.[PickedQuantity] * ol.[UnitPrice])	AS [Summ]
	FROM 
		Sales.OrderLines ol
	GROUP BY
		ol.[OrderID]
	HAVING 
		ol.[OrderID] = ANY (SELECT co.[ID] FROM CompletedOrders co)
)
SELECT 
	i.[InvoiceID]      AS [InvoiceID]
	, i.[InvoiceDate]  AS [InvoiceDate]
	, p.[FullName]     AS [SalesPersonName]
	, isum.[Summ]      AS [TotalSummByInvoice]
	, cosum.[Summ]     AS [TotalSummForPickedItems]
FROM 
	InvoicesSumm isum              
    LEFT JOIN Sales.Invoices i            ON isum.[ID] = i.[InvoiceID]
	LEFT JOIN Application.People p        ON p.[PersonID] = i.[SalespersonPersonID]
    LEFT JOIN CompletedOrdersSumm cosum   ON cosum.[ID] = i.[OrderID]
ORDER BY 
	[TotalSummByInvoice] DESC
;

GO

--SELECT 
--	Invoices.InvoiceID, 
--	Invoices.InvoiceDate,
--	SalesTotals.TotalSumm AS TotalSummByInvoice, 
--	(	
--		SELECT People.FullName
--		FROM Application.People
--		WHERE People.PersonID = Invoices.SalespersonPersonID
--	) AS SalesPersonName,
--	(
--		SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
--		FROM Sales.OrderLines
--		WHERE OrderLines.OrderId = (
--			SELECT Orders.OrderId 
--			FROM Sales.Orders
--			WHERE 1=1 
--				AND Orders.PickingCompletedWhen IS NOT NULL	
--				AND Orders.OrderId = Invoices.OrderId)	
--	) AS TotalSummForPickedItems
--FROM Sales.Invoices 
--	JOIN
--	(
--		SELECT 
--			InvoiceId
--			,SUM(Quantity*UnitPrice) AS TotalSumm
--		FROM Sales.InvoiceLines
--		GROUP BY InvoiceId
--		HAVING SUM(Quantity*UnitPrice) > 27000
--	) AS SalesTotals ON Invoices.InvoiceID = SalesTotals.InvoiceID
--ORDER BY TotalSumm DESC;


DECLARE @MinimalInvoiceSumm INT = 27000;

DROP TABLE IF EXISTS #InvoicesSumm;
CREATE TABLE #InvoicesSumm 
(
    [InvoiceId] INT
    , [InvoiceSumm] INT
);

INSERT INTO #InvoicesSumm (InvoiceId, InvoiceSumm)
(
	SELECT 
		i.[InvoiceId]
		, SUM(i.[Quantity] * i.[UnitPrice]) AS TotalSumm
	FROM 
		Sales.InvoiceLines i
	GROUP BY 
		i.[InvoiceId]
	HAVING 
		SUM(i.[Quantity] * i.[UnitPrice]) > @MinimalInvoiceSumm 
);

WITH CompletedOrdersSumm (ID, Summ) AS
(
	SELECT 
		ol.[OrderID]
		, SUM(ol.[PickedQuantity] * ol.[UnitPrice])	AS [Summ]
	FROM 
		Sales.OrderLines ol
    WHERE EXISTS (SELECT 1 FROM Sales.Orders o WHERE o.[OrderId] = ol.[OrderID] AND o.[PickingCompletedWhen] IS NOT NULL)
	GROUP BY
		ol.[OrderID]
)
SELECT 
	i.[InvoiceID]         AS [InvoiceID]
	, i.[InvoiceDate]     AS [InvoiceDate]
	, p.[FullName]        AS [SalesPersonName]
	, isum.[InvoiceSumm]  AS [TotalSummByInvoice]
	, cosum.[Summ]        AS [TotalSummForPickedItems]
FROM 
	#InvoicesSumm isum              
    LEFT JOIN Sales.Invoices i            ON isum.[InvoiceID] = i.[InvoiceID]
	LEFT JOIN Application.People p        ON p.[PersonID] = i.[SalespersonPersonID]
    LEFT JOIN CompletedOrdersSumm cosum   ON cosum.[ID] = i.[OrderID]
ORDER BY 
	[TotalSummByInvoice] DESC


DROP TABLE IF EXISTS #InvoicesSumm;

GO


--select i.OrderID from Sales.Invoices i where i.InvoiceID = 45749

--update Sales.Orders
--set
--    PickingCompletedWhen = null
--where OrderID = 47596


DECLARE @MinimalInvoiceSumm INT = 27000;

WITH CompletedOrdersSumm (ID, Summ) AS
(
	SELECT 
		ol.[OrderID]
		, SUM(ol.[PickedQuantity] * ol.[UnitPrice])	AS [Summ]
	FROM 
		Sales.OrderLines ol
    WHERE EXISTS (SELECT 1 FROM Sales.Orders o WHERE o.[OrderId] = ol.[OrderID] AND o.[PickingCompletedWhen] IS NOT NULL)
	GROUP BY
		ol.[OrderID]
)
SELECT 
	i.[InvoiceID]         AS [InvoiceID]
	, i.[InvoiceDate]     AS [InvoiceDate]
	, p.[FullName]        AS [SalesPersonName]
	, isum.[InvoiceSumm]  AS [TotalSummByInvoice]
	, cosum.[Summ]        AS [TotalSummForPickedItems]
FROM 
	(SELECT 
		i.[InvoiceId]
		, SUM(i.[Quantity] * i.[UnitPrice]) AS [InvoiceSumm]
	FROM 
		Sales.InvoiceLines i
	GROUP BY 
		i.[InvoiceId]
	HAVING 
		SUM(i.[Quantity] * i.[UnitPrice]) > @MinimalInvoiceSumm) isum              
    JOIN Sales.Invoices i            ON isum.[InvoiceID] = i.[InvoiceID]
	LEFT JOIN Application.People p        ON p.[PersonID] = i.[SalespersonPersonID]
    LEFT JOIN CompletedOrdersSumm cosum   ON cosum.[ID] = i.[OrderID]
ORDER BY 
	[TotalSummByInvoice] DESC
OPTION (FORCE ORDER)

DROP TABLE IF EXISTS #InvoicesSumm;

GO