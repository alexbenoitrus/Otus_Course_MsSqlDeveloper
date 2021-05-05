/*
3. В таблице стран (Application.Countries) есть поля с цифровым кодом страны и с буквенным.
Сделайте выборку ИД страны, названия и ее кода так, 
чтобы в поле с кодом был либо цифровой либо буквенный код.

Пример результата:
--------------------------------
CountryId | CountryName | Code
----------+-------------+-------
1         | Afghanistan | AFG
1         | Afghanistan | 4
3         | Albania     | ALB
3         | Albania     | 8
----------+-------------+-------
*/

WITH DataForUnpivot ([CountryID], [CountryName], [Code1], [Code2]) AS
(
    SELECT
        c.[CountryID]                              AS [CountryID]
        , c.[CountryName]                          AS [CountryName]
        , CONVERT(nvarchar, c.[IsoAlpha3Code])     AS [Code1]
        , CONVERT(nvarchar, c.[IsoNumericCode])    AS [Code2]
    FROM
        Application.Countries c WITH (NOLOCK)
)
SELECT
    [CountryID]
    , [CountryName]
    , [Code]
FROM DataForUnpivot
UNPIVOT 
(
    [Code] FOR [HiddenField]
        IN ([Code1], [Code2])
) AS UnpivotData;