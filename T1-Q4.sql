SELECT 
	IT.ItemCode
	, IT.ItemName
	, SUM(
		CASE 
			WHEN ISNULL(WH.WhsCode,'') = '01' THEN ISNULL(ITXWH.OnHand,0) ELSE 0 END
		) AS [01]
	, SUM(
		CASE 
			WHEN ISNULL(WH.WhsCode,'') = '02' THEN ISNULL(ITXWH.OnHand,0) ELSE 0 END
		) AS [02]
	, SUM(
		CASE 
			WHEN ISNULL(WH.WhsCode,'') = '03' THEN ISNULL(ITXWH.OnHand,0) ELSE 0 END
		) AS [03]
	, SUM(
		CASE 
			WHEN ISNULL(WH.WhsCode,'') = '04' THEN ISNULL(ITXWH.OnHand,0) ELSE 0 END
		) AS [04]
	, SUM(
		CASE 
			WHEN ISNULL(WH.WhsCode,'') = '05' THEN ISNULL(ITXWH.OnHand,0) ELSE 0 END
		) AS [05]
	, SUM(
		CASE 
			WHEN ISNULL(WH.WhsCode,'') = 'INT' THEN ISNULL(ITXWH.OnHand,0) ELSE 0 END
		) AS [INT]
	, SUM(
		CASE 
			WHEN ISNULL(WH.WhsCode,'') = 'MP' THEN ISNULL(ITXWH.OnHand,0) ELSE 0 END
		) AS [MP]
FROM dbo.OITM AS IT
LEFT JOIN dbo.OITW AS ITXWH ON (ITXWH.ItemCode=IT.ItemCode)
LEFT JOIN dbo.OWHS AS WH ON (WH.WhsCode = ITXWH.WhsCode)
GROUP BY IT.ItemCode,IT.ItemName
HAVING SUM(ISNULL(ITXWH.OnHand, 0)) > 0;

SELECT 
    ItemCode,
    ItemName,
    ISNULL([01], 0) AS [01],
    ISNULL([02], 0) AS [02],
    ISNULL([03], 0) AS [03],
    ISNULL([04], 0) AS [04],
    ISNULL([05], 0) AS [05],
    ISNULL([INT], 0) AS [INT],
    ISNULL([MP], 0) AS [MP]
FROM (
    SELECT 
        IT.ItemCode,
        IT.ItemName,
        ISNULL(WH.WhsCode, '') AS WhsCode,
        ISNULL(ITXWH.OnHand, 0) AS OnHand
    FROM dbo.OITM AS IT
    LEFT JOIN dbo.OITW AS ITXWH ON (ITXWH.ItemCode = IT.ItemCode)
    LEFT JOIN dbo.OWHS AS WH ON (WH.WhsCode = ITXWH.WhsCode)
) AS SourceData
PIVOT (
    SUM(OnHand) 
    FOR WhsCode IN ([01], [02], [03], [04], [05], [INT], [MP])
) AS PivotTable
WHERE ISNULL([01], 0) + ISNULL([02], 0) + ISNULL([03], 0) + ISNULL([04], 0) + ISNULL([05], 0) + ISNULL([INT], 0) + ISNULL([MP], 0) > 0;