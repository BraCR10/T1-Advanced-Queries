SELECT 
	M.Name AS [Name]
	, SUM(ISNULL(Line.LineTotal,0)) AS [Total]
FROM dbo.MARCAS AS M
LEFT JOIN dbo.OITM AS Item ON (Item.U_Marca=M.Code)
LEFT JOIN dbo.INV1 AS Line ON (Line.ItemCode=Item.ItemCode)
GROUP BY M.Name
ORDER BY [Total] DESC;