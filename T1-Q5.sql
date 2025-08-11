DECLARE @Months TABLE (
	Num INT
	,NameM VARCHAR(32)
);


INSERT INTO @Months VALUES 
(1,'Enero'),(2,'Febrero'),(3,'Marzo'),(4,'Abril'),
(5,'Mayo'),(6,'Junio'),(7,'Julio'),(8,'Agosto'),
(9,'Septiembre'),(10,'Octubre'),(11,'Noviembre'),(12,'Diciembre');

DECLARE @MonthsCountries TABLE (
	Num INT
	,NameM VARCHAR(32)
	, Contry NVARCHAR(2)
	, NameCountry NVARCHAR(100)
);


INSERT INTO @MonthsCountries
SELECT M.Num,M.NameM,CO.Country,CO.Name
FROM @Months AS M
CROSS JOIN (
	SELECT C.Country ,C.Name 
	FROM dbo.OCRY as C
) AS CO;

DECLARE @year INT=2025;

SELECT 
	MC.NameCountry AS [Country]
	, MC.NameM AS [Month]
	, SUM(ISNULL(INV.DocTotal,0)) - SUM(ISNULL(Ret.DocTotal,0)) AS [TotalProfits]
	, COUNT(DISTINCT INV.DocEntry) AS [InvoicesCant]
	, COUNT(DISTINCT Ret.DocEntry) AS [ReturnsCant]
	, SUM(ISNULL(INV.DocTotal,0)) AS [TotalSold]
	, SUM(ISNULL(Ret.DocTotal,0)) AS [TotalReturned]
FROM @MonthsCountries AS MC
LEFT JOIN dbo.OCRD AS Client ON (Client.Country=MC.Contry)
LEFT JOIN (
	SELECT	
		INV.DocEntry
		,INV.DocTotal
		, INV.CardCode
	FROM dbo.OINV AS INV
	WHERE(YEAR(INV.DocDate)=@year)
) AS INV ON (INV.CardCode=Client.CardCode)
LEFT JOIN (
	SELECT
		Ret.DocEntry
		, Ret.DocTotal
		, Ret.CardCode
	FROM dbo.ORIN AS Ret
	WHERE(YEAR(Ret.DocDate)=@year)
) AS Ret ON (Ret.CardCode=Client.CardCode)
GROUP BY MC.NameCountry,MC.NameM
ORDER BY [TotalProfits] DESC ;