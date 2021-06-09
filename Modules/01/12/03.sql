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
SELECT COUNT(1) AS [Count] FROM Sales.Customers

DROP FUNCTION IF EXISTS Sales.fn_Customers_GetCount
DROP PROCEDURE IF EXISTS Sales.p_Customers_GetCount

--CREATE FUNCTION Sales.fn_Customers_GetCount()
--RETURNS int AS
--BEGIN
--	RETURN(SELECT COUNT(1) FROM Sales.Customers)
--END

--select Sales.fn_Customers_GetCount()

--DROP FUNCTION IF EXISTS Sales.fn_Customers_GetCount