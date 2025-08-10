SELECT  
    ROW_NUMBER() OVER (ORDER BY SUM(F.DocTotal) DESC) AS [Ranking]
    , V.SlpName AS [Sales Person Name]
    , SUM(F.DocTotal) AS [Total Sales]
FROM dbo.OINV AS F
INNER JOIN dbo.OSLP AS V ON (V.SlpCode = F.SlpCode)
WHERE (F.DocDate >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE())-1, 1)) 
  AND (F.DocDate < DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1))
GROUP BY V.SlpName
ORDER BY [Ranking];
