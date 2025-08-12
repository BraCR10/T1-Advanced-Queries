DECLARE @ZoneWeekdaySales TABLE(
    Zone nvarchar(100),
    WeekdayNumber int,
    WeekdayName nvarchar(20),
    TotalAmount numeric(18, 6)
)

INSERT INTO @ZoneWeekdaySales
SELECT 
    CO.U_Zona AS Zone,
    DATEPART(WEEKDAY, F.DocDate) AS WeekdayNumber,
    CASE DATEPART(WEEKDAY, F.DocDate)
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday' 
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
    END AS WeekdayName,
    SUM(F.DocTotal) AS TotalAmount
FROM dbo.OINV AS F
INNER JOIN dbo.OCRD AS CO ON (CO.CardCode = F.CardCode AND CO.CardType='C')
GROUP BY CO.U_Zona, DATEPART(WEEKDAY, F.DocDate);

DECLARE @ZoneWeekdayRanked TABLE(
    Zone nvarchar(100),
    WeekdayName nvarchar(20),
    TotalAmount numeric(18, 6),
    BestRank int,
    WorstRank int
)

INSERT INTO @ZoneWeekdayRanked
SELECT 
    ZS.Zone,
    ZS.WeekdayName,
    ZS.TotalAmount,
    ROW_NUMBER() OVER (PARTITION BY ZS.Zone ORDER BY ZS.TotalAmount DESC) AS BestRank,
    ROW_NUMBER() OVER (PARTITION BY ZS.Zone ORDER BY ZS.TotalAmount ASC) AS WorstRank
FROM @ZoneWeekdaySales AS ZS;

SELECT 
    ZO.Code
	, ZO.Name
    , ISNULL(Best.WeekdayName,0) AS [BestDay]
    , ISNULL(Best.TotalAmount,0) AS [BestAmount]
    , ISNULL(Worst.WeekdayName,0) AS [WorstDay] 
    , ISNULL(Worst.TotalAmount,0) AS [WorstAmount]
FROM dbo.ZONAS AS ZO
LEFT JOIN (SELECT DISTINCT Zone FROM @ZoneWeekdayRanked) AS Z ON (Z.Zone=ZO.Code)
LEFT JOIN @ZoneWeekdayRanked AS Best ON (Best.Zone = Z.Zone AND Best.BestRank = 1)
LEFT JOIN @ZoneWeekdayRanked AS Worst ON (Worst.Zone = Z.Zone AND Worst.WorstRank = 1)
ORDER BY Best.TotalAmount DESC;