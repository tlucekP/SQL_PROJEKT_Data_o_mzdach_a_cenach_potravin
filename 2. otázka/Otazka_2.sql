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


SELECT
	a.`year`,
	a.job_category,
	a.milk_per_wage,
	b.bread_per_wage
FROM
	(SELECT
	`year`,
	job_category,
	round(avg(wage/price), 0) AS milk_per_wage
	FROM t_peter_tluchor_project_sql_primary_final tptpspf
	WHERE food LIKE '%mleko%'
		AND price IS NOT NULL
		AND `year` = 2006
	GROUP BY job_category) a
LEFT JOIN
	(SELECT
	job_category,
	round(avg(wage/price), 0) AS bread_per_wage
	FROM t_peter_tluchor_project_sql_primary_final tptpspf
	WHERE food LIKE '%chleb%'
		AND price IS NOT NULL
		AND `year` = 2006
	GROUP BY job_category) b
ON a.job_category = b.job_category;


SELECT
	a.`year`,
	a.job_category,
	a.milk_per_wage,
	b.bread_per_wage
FROM
	(SELECT
	`year`,
	job_category,
	round(avg(wage/price), 0) AS milk_per_wage
	FROM t_peter_tluchor_project_sql_primary_final tptpspf
	WHERE food LIKE '%mleko%'
		AND price IS NOT NULL
		AND `year` = 2018
	GROUP BY job_category) a
LEFT JOIN
	(SELECT
	job_category,
	round(avg(wage/price), 0) AS bread_per_wage
	FROM t_peter_tluchor_project_sql_primary_final tptpspf
	WHERE food LIKE '%chleb%'
		AND price IS NOT NULL
		AND `year` = 2018
	GROUP BY job_category) b
ON a.job_category = b.job_category;