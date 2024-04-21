/*
 * MZDA A CENY
 */

-- Vytvoření tabulky t_peter_tluchor_project_sql_primary_final

CREATE OR REPLACE TABLE t_peter_tluchor_project_sql_primary_final AS
SELECT
    cp.payroll_year AS 'year',
    cpib.name AS job_category,
    cp.value AS wage,
    cp2.category_code AS food_category,
    cpc.name AS food,
    round(avg(cp2.value),2) AS price_in_year
FROM czechia_payroll cp 
LEFT JOIN czechia_payroll_industry_branch cpib
    ON cp.industry_branch_code = cpib.code
LEFT JOIN czechia_price cp2 
    ON year(cp2.date_from) = cp.payroll_year
LEFT JOIN czechia_price_category cpc 
    ON cp2.category_code = cpc.code
WHERE 
    cp.value_type_code = 5958 
    AND calculation_code = 200
    AND cp.payroll_year BETWEEN 2000 AND 2021
    AND cp.industry_branch_code IS NOT NULL
    AND cp.value IS NOT NULL
    AND cp2.region_code IS NULL
GROUP BY 
    cp.payroll_year,
    cpib.name,
    cp.value,
    cp2.category_code,
    cpc.name;

SELECT *
FROM t_peter_tluchor_project_sql_primary_final tptpspf;

/*
 *  1. Otázka: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
 */

-- zjištění trendu na základě rozdílu mezi průměrnou mzdou v roce 2000 a minimální mzdou mezi roky 2000 a 2021.

SELECT 
    job_category,
    CASE 
        WHEN AVG(wage) - MIN(wage) > 0 THEN 'Rostoucí'
        WHEN AVG(wage) - MIN(wage) < 0 THEN 'Klesající'
        ELSE 'Bez změny'
    END AS trend
FROM 
    t_peter_tluchor_project_sql_primary_final tptpspf_
WHERE 
    year BETWEEN 2000 AND 2021
GROUP BY 
    job_category;
   
-- 	ODPOVĚĎ: ve všech pracovních odvětvích je trend průměrné mzdy rostoucí.


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























