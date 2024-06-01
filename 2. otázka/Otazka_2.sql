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
	FROM t_peter_tluchor_project_sql_primary_final tptpspf
	WHERE food LIKE '%mleko%'
		AND price IS NOT NULL
	GROUP BY `year`