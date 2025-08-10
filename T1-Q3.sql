SELECT 
	M.Name AS [Nombre de marca]
	, SUM(ISNULL(L.LineTotal,0)) AS [Monto Total]
FROM dbo.MARCAS AS M
LEFT JOIN dbo.OITM AS I ON (I.U_Marca=M.Code)
LEFT JOIN dbo.INV1 AS L ON (L.ItemCode = I.ItemCode)
GROUP BY M.Name
ORDER BY [Monto Total] DESC;
