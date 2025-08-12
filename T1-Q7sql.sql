SELECT 
    IT.ItemCode AS [ProductCode]
    , IT.ItemName AS [ProductName]
    , SUM(F1.Quantity) AS [TotalQuantitySold]
    , SUM(F1.LineTotal) AS [TotalAmountSold]
FROM dbo.OITM AS IT
INNER JOIN dbo.INV1 AS F1 ON (F1.ItemCode = IT.ItemCode)
INNER JOIN dbo.OINV AS INV ON (INV.DocEntry = F1.DocEntry)
WHERE (
    MONTH(INV.DocDate) = (CASE WHEN (MONTH(GETDATE()) - 1)>0  THEN (MONTH(GETDATE()) - 1) ELSE 12 END)
	AND 
    YEAR(INV.DocDate) = (CASE WHEN (MONTH(GETDATE()) - 1) > 0 THEN YEAR(GETDATE()) ELSE YEAR(GETDATE()) - 1 END)
    AND 
	IT.ItemCode NOT IN (
        SELECT DISTINCT RIN1.ItemCode 
        FROM dbo.RIN1 AS RIN1
        INNER JOIN dbo.ORIN AS RET ON (RET.DocEntry = RIN1.DocEntry)
    )
)
GROUP BY IT.ItemCode, IT.ItemName
ORDER BY [TotalAmountSold] DESC;