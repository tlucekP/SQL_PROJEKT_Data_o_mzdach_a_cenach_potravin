/*
 * 2. Otázka: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v
 * dostupných datech cen a mezd?
 */

-- zjištění počátku společného sledovaného období (rok)

SELECT *
FROM t_peter_tluchor_project_sql_primary_final tptpspf
WHERE price IS NOT NULL
ORDER BY `year` ASC;

-- zjištění posledního společného sledovaného období (rok)

SELECT *
FROM t_peter_tluchor_project_sql_primary_final tptpspf
WHERE price IS NOT NULL
ORDER BY `year` DESC;


WITH MilkData AS (
	SELECT
		`year`,
		ROUND(avg(wage/price), 0) AS milk_per_wage
	FROM t_peter_tluchor_project_sql_primary_final
	WHERE food LIKE '%mleko%'
		AND price IS NOT NULL
	GROUP BY `year`
),
BreadData AS (
	SELECT
		`year`,
		ROUND(AVG(wage/price), 0) AS bread_per_wage
	FROM t_peter_tluchor_project_sql_primary_final
	WHERE food LIKE '%chleb%'
		AND price IS NOT NULL
	GROUP BY `year`
),
CombinedData AS (
	SELECT
		m.`year`,
		m.milk_per_wage,
		b.bread_per_wage
	FROM MilkData m
	JOIN BreadData b ON m.`year` = b.`year`
)
SELECT
	`year`,
	milk_per_wage,
	bread_per_wage
FROM CombinedData
WHERE `year` = (SELECT MIN(`year`) FROM CombinedData)
	OR `year` = (SELECT MAX(`year`) FROM CombinedData);
	
	
	
	
	