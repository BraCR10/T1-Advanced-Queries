DECLARE @Month INT = 6
		, @Year INT = 2025;
SELECT
RANK() OVER (ORDER BY SUM(INV.DocTotal)) AS [Ranking]
	, SP.SlpName AS [SalesPerson]
	, SUM(INV.DocTotal) AS [TotalSold]
FROM dbo.OSLP AS SP
INNER JOIN dbo.OINV AS INV ON (INV.SlpCode=SP.SlpCode)
WHERE (MONTH(INV.DocDate)=@Month AND YEAR(INV.DocDate)=@Year)
GROUP BY SP.SlpName;
