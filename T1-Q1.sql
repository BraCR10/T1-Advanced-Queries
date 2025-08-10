-- Use LEFT instead of INNER to diplay all ZONES 
SELECT 
	Z.Name AS Zone
	, ISNULL(C.CardName , '' ) AS Client
	, ISNULL(SUM(F.DocTotal), 0) AS TotalInvoiceAmount
	, ISNULL(SUM(D.DocTotal), 0) AS TotalRefundsAmount
FROM  dbo.ZONAS AS Z
INNER JOIN dbo.OCRD AS C ON (Z.Code = C.U_Zona AND C.CardType = 'C')
LEFT JOIN dbo.OINV AS F ON (F.CardCode = C.CardCode)
LEFT JOIN dbo.ORIN AS D ON (D.CardCode = C.CardCode)
GROUP BY Z.Name, C.CardName
ORDER BY Z.Name, C.CardName;
