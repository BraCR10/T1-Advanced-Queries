SELECT 
	Z.Name AS [Zone]
	, Client.CardName AS [Client]
	, SUM(ISNULL(Invoice.Total,0))  AS [TotalInvoices]
	, SUM(ISNULL(Ret.Total,0)) AS [TotalReturns]
FROM dbo.OCRD AS Client
INNER JOIN dbo.ZONAS AS Z ON (Z.Code=Client.U_Zona)
LEFT JOIN (
	SELECT 
		Invoice.CardCode
		, SUM(ISNULL(Invoice.DocTotal,0)) AS Total
	FROM dbo.OINV AS Invoice
	GROUP BY Invoice.CardCode
) AS Invoice ON (Client.CardCode=Invoice.CardCode)
LEFT JOIN (
	SELECT 
		Ret.CardCode
		, SUM(ISNULL(Ret.DocTotal,0)) AS Total
	FROM dbo.ORIN AS Ret
	GROUP BY Ret.CardCode
) AS Ret ON (Ret.CardCode=Client.CardCode)
GROUP BY Z.Name,Client.CardName;
