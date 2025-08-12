SELECT 
    CO.CardName AS [Client]
     , SUM(CASE WHEN F.DocDueDate > GETDATE() THEN ISNULL(F.DocTotal, 0) ELSE 0 END) AS [NotExpired]
     , SUM(CASE WHEN F.DocDueDate <= GETDATE() AND DATEDIFF(DAY, F.DocDueDate, GETDATE()) BETWEEN 1 AND 30 
             THEN ISNULL(F.DocTotal, 0) ELSE 0 END) AS [Expired_0_30]
    , SUM(CASE WHEN F.DocDueDate <= GETDATE() AND DATEDIFF(DAY, F.DocDueDate, GETDATE()) BETWEEN 31 AND 60 
             THEN ISNULL(F.DocTotal, 0) ELSE 0 END) AS [Expired_31_60]
    , SUM(CASE WHEN F.DocDueDate <= GETDATE() AND DATEDIFF(DAY, F.DocDueDate, GETDATE()) BETWEEN 61 AND 90 
             THEN ISNULL(F.DocTotal, 0) ELSE 0 END) AS [Expired_61_90]
    , SUM(CASE WHEN F.DocDueDate <= GETDATE() AND DATEDIFF(DAY, F.DocDueDate, GETDATE()) > 90 
             THEN ISNULL(F.DocTotal, 0) ELSE 0 END) AS [Expired_Over_90]
FROM dbo.OCRD AS CO 
LEFT JOIN dbo.OINV AS F ON (F.CardCode = CO.CardCode)
LEFT JOIN dbo.ORIN AS D ON (D.CardCode = CO.CardCode)
WHERE CO.CardType = 'C'
GROUP BY CO.CardName;