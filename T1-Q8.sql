DECLARE @Rank TABLE(
	ClientName nchar(100)
    , ClientCode nchar(20)
    , Amount numeric(18, 6)
    , Country nvarchar(2)
)

INSERT INTO @Rank
SELECT 
    CO.CardName
	, CO.CardCode
    , SUM(F.DocTotal)
    , CO.Country
FROM dbo.OINV AS F 
INNER JOIN dbo.OCRD AS CO ON (CO.CardCode = F.CardCode AND CO.CardType='C')
GROUP BY  CO.CardName,CO.CardCode, CO.Country;

SELECT 
    C.Name AS [Country]
    , ISNULL((SELECT TOP 1 R.ClientName 
		FROM @Rank AS R 
		INNER JOIN dbo.OCRD AS CO ON (CO.CardCode = R.ClientCode)
		WHERE CO.Country = C.Country 
		ORDER BY R.Amount DESC
	), 'No clients' ) AS [BestClient]
	, ISNULL((SELECT TOP 1 R.ClientName 
		FROM @Rank AS R 
		INNER JOIN dbo.OCRD AS CO ON (CO.CardCode = R.ClientCode)
		WHERE CO.Country = C.Country 
		ORDER BY R.Amount ASC
	), 'No clients' ) AS [WorstClient]
FROM dbo.OCRY AS C
LEFT JOIN dbo.OCRD AS CO ON (CO.Country = C.Country)
GROUP BY C.Name, C.Country 
ORDER BY [BestClient],[WorstClient] ASC;