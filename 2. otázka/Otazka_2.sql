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


-- zjištění podílu 1 litru mléka a chleba (1kg) za průměrnou mzdu každého z pracovních odvětví v roce 2006

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


-- zjištění podílu 1 litru mléka a chleba (1kg) za průměrnou mzdu každého z pracovních odvětví v roce 2018

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

-- 	Odpověď: Konkrétní počty 1 litru mléka a 1 kilogramu chleba v prvním a posledním sledovaném období (čili v letech 2006 a 2018)
--	jsou výstupem syntaxe. Po bližším zkoumání je zřejmé, že jednotlivé sledované komodity vůči některým konkrétním
--	pracovním odvětvím zdražovali více, než rostli průměrné mzdy a v roce 2018 si jich za konkrétní průměrnou mzdu lze koupit méně.