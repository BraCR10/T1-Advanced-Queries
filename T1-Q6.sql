SELECT 
    IT.ItemCode AS [Code]
    , IT.ItemName AS [Description]
    , M.Name AS [Brand]
    -- JANUARY
    , SUM(CASE WHEN MONTH(F1.DocDate) = 1 THEN ISNULL(F1.LineTotal, 0) ELSE 0 END) AS [Sales 01]
    , SUM(CASE WHEN MONTH(D1.DocDate) = 1 THEN ISNULL(D1.LineTotal, 0) ELSE 0 END) AS [Returns 01]
    -- FEBRUARY
    , SUM(CASE WHEN MONTH(F1.DocDate) = 2 THEN ISNULL(F1.LineTotal, 0) ELSE 0 END) AS [Sales 02]
    , SUM(CASE WHEN MONTH(D1.DocDate) = 2 THEN ISNULL(D1.LineTotal, 0) ELSE 0 END) AS [Returns 02]
    -- MARCH
    , SUM(CASE WHEN MONTH(F1.DocDate) = 3 THEN ISNULL(F1.LineTotal, 0) ELSE 0 END) AS [Sales 03]
    , SUM(CASE WHEN MONTH(D1.DocDate) = 3 THEN ISNULL(D1.LineTotal, 0) ELSE 0 END) AS [Returns 03]
    -- APRIL
    , SUM(CASE WHEN MONTH(F1.DocDate) = 4 THEN ISNULL(F1.LineTotal, 0) ELSE 0 END) AS [Sales 04]
    , SUM(CASE WHEN MONTH(D1.DocDate) = 4 THEN ISNULL(D1.LineTotal, 0) ELSE 0 END) AS [Returns 04]
    -- MAY
    , SUM(CASE WHEN MONTH(F1.DocDate) = 5 THEN ISNULL(F1.LineTotal, 0) ELSE 0 END) AS [Sales 05]
    , SUM(CASE WHEN MONTH(D1.DocDate) = 5 THEN ISNULL(D1.LineTotal, 0) ELSE 0 END) AS [Returns 05]
    -- JUNE
    , SUM(CASE WHEN MONTH(F1.DocDate) = 6 THEN ISNULL(F1.LineTotal, 0) ELSE 0 END) AS [Sales 06]
    , SUM(CASE WHEN MONTH(D1.DocDate) = 6 THEN ISNULL(D1.LineTotal, 0) ELSE 0 END) AS [Returns 06]
    -- JULY
    , SUM(CASE WHEN MONTH(F1.DocDate) = 7 THEN ISNULL(F1.LineTotal, 0) ELSE 0 END) AS [Sales 07]
    , SUM(CASE WHEN MONTH(D1.DocDate) = 7 THEN ISNULL(D1.LineTotal, 0) ELSE 0 END) AS [Returns 07]
    -- AUGUST
    , SUM(CASE WHEN MONTH(F1.DocDate) = 8 THEN ISNULL(F1.LineTotal, 0) ELSE 0 END) AS [Sales 08]
    , SUM(CASE WHEN MONTH(D1.DocDate) = 8 THEN ISNULL(D1.LineTotal, 0) ELSE 0 END) AS [Returns 08]
    -- SEPTEMBER
    , SUM(CASE WHEN MONTH(F1.DocDate) = 9 THEN ISNULL(F1.LineTotal, 0) ELSE 0 END) AS [Sales 09]
    , SUM(CASE WHEN MONTH(D1.DocDate) = 9 THEN ISNULL(D1.LineTotal, 0) ELSE 0 END) AS [Returns 09]
    -- OCTOBER
    , SUM(CASE WHEN MONTH(F1.DocDate) = 10 THEN ISNULL(F1.LineTotal, 0) ELSE 0 END) AS [Sales 10]
    , SUM(CASE WHEN MONTH(D1.DocDate) = 10 THEN ISNULL(D1.LineTotal, 0) ELSE 0 END) AS [Returns 10]
    -- NOVEMBER
    , SUM(CASE WHEN MONTH(F1.DocDate) = 11 THEN ISNULL(F1.LineTotal, 0) ELSE 0 END) AS [Sales 11]
    , SUM(CASE WHEN MONTH(D1.DocDate) = 11 THEN ISNULL(D1.LineTotal, 0) ELSE 0 END) AS [Returns 11]
    -- DECEMBER
    , SUM(CASE WHEN MONTH(F1.DocDate) = 12 THEN ISNULL(F1.LineTotal, 0) ELSE 0 END) AS [Sales 12]
    , SUM(CASE WHEN MONTH(D1.DocDate) = 12 THEN ISNULL(D1.LineTotal, 0) ELSE 0 END) AS [Returns 12]
FROM dbo.OITM AS IT 
INNER JOIN dbo.MARCAS AS M ON (M.Code = IT.U_Marca)
LEFT JOIN (
    SELECT INV1.LineTotal, INV1.ItemCode, INV.DocDate
    FROM dbo.INV1 AS INV1
    INNER JOIN dbo.OINV AS INV ON (INV.DocEntry = INV1.DocEntry)
    WHERE YEAR(INV.DocDate) = YEAR(GETDATE())  -- Current year
) AS F1 ON (F1.ItemCode = IT.ItemCode)
LEFT JOIN (
    SELECT RIN1.LineTotal, RIN1.ItemCode, ORIN.DocDate
    FROM dbo.RIN1 AS RIN1
    INNER JOIN dbo.ORIN ON (ORIN.DocEntry = RIN1.DocEntry)
    WHERE YEAR(ORIN.DocDate) = YEAR(GETDATE())  -- Current year
) AS D1 ON (D1.ItemCode = IT.ItemCode)
GROUP BY IT.ItemCode, IT.ItemName, M.Name
ORDER BY M.Name, IT.ItemName;


