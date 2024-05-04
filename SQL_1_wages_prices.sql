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


/*
 * 3. Otázka: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
 */

-- Pro potřeby této otázky si pomůžu klauzulí WITH a to tak, že vytvořímm dvě pomocné tabulky. 1. pro výpočet meziroční změny cen a
-- 2. pro průměrnou změnu cen jednotlivých kategorií potravin. Jako první si napíšu dotaz pro meziroční změny cen.

SELECT
	a.`year`,
    a.food,
    a.price AS current_year_price,
    b.price AS previous_year_price,
    ((a.price - b.price) / b.price) * 100 AS price_change_percentage
FROM t_peter_tluchor_project_sql_primary_final a
JOIN t_peter_tluchor_project_sql_primary_final b
ON a.food_category = b.food_category
	AND a.`year` = b.`year` + 1;

-- pomocí WITH si z ní vytvořím pomocnou tabulku a navážu druhou pomocnou tabulkou pro zjištění průměrné změny. Tento dotaz pak
-- doplním o zbytek SELECT, který mi ukáže výsledek.

WITH yearly_price_change AS (
	SELECT
		a.`year`,
		a.food,
		a.price AS current_year_price,
		b.price AS previous_year_price,
		((a.price - b.price) / b.price) * 100 AS price_change_percentage
	FROM t_peter_tluchor_project_sql_primary_final a
	JOIN t_peter_tluchor_project_sql_primary_final b
	ON a.food_category = b.food_category
		AND a.year = b.year + 1),
category_average_change AS (
    SELECT
		food,
		AVG(price_change_percentage) AS average_change_percentage
	FROM yearly_price_change ypc
	GROUP BY food)
SELECT
    'Kategorie s nejpomalejším zdražením' AS `result`,
    cac.food
FROM
    category_average_change cac
WHERE cac.average_change_percentage = (
	SELECT MIN(average_change_percentage)
	FROM category_average_change cac);

-- 	Odpověď: Nejpomaleji zdražuje Cukr krystalový.


/*
 * 4. Otázka: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
 */

-- Pro zjištění si opět pomůžu klauzulí WITH. Vytvořím dvě tabulky, jednu pro zjištění ročních statistik vývoje průměrných mezd a cen (za celky)
-- a tabulky následně spojím. V hlavním dotazu spočítám meziroční změnu cen potravin a mezd a porovnám, zda pro daný rok došlo k nárůstu cen 
-- potravin o více než 10% vůči růstu mezd.

WITH yearly_stats AS (
    SELECT
        year,
        AVG(wage) AS avg_wage,
        AVG(price) AS avg_price
    FROM
        t_peter_tluchor_project_sql_primary_final
    GROUP BY
        year
),
price_change AS (
    SELECT
        year,
        avg_price,
        LAG(avg_price) OVER (ORDER BY year) AS prev_avg_price
    FROM
        yearly_stats
),
wage_change AS (
    SELECT
        year,
        avg_wage,
        LAG(avg_wage) OVER (ORDER BY year) AS prev_avg_wage
    FROM
        yearly_stats
)
SELECT
    ys.year,
    round(ys.avg_wage, 2) AS avg_wage,
    round(ys.avg_price, 2) AS avg_price,
    ROUND(((ys.avg_price - pc.prev_avg_price) / pc.prev_avg_price) * 100, 2) AS price_change_percentage,
    ROUND(((ys.avg_wage - wc.prev_avg_wage) / wc.prev_avg_wage) * 100, 2) AS wage_change_percentage,
    CASE WHEN ((ys.avg_price - pc.prev_avg_price) / pc.prev_avg_price) * 100 > ((ys.avg_wage - wc.prev_avg_wage) / wc.prev_avg_wage) * 100 + 10 THEN 'Ano' ELSE 'Ne'
    	END AS focus_price_growth
FROM
    yearly_stats ys
JOIN
    price_change pc ON ys.year = pc.year
JOIN
    wage_change wc ON ys.year = wc.YEAR
WHERE
    ys.avg_wage IS NOT NULL
    AND ys.avg_price IS NOT NULL
    AND pc.prev_avg_price IS NOT NULL;
   
-- Odpověď: Ani v jednom roce nebyl průměrný růst cen potravin výrazně více, než byl průměrný nárůst mezd (>10%). V případě porovnávání jednotlivých
-- kategorií pracovních odvětví a kategorií potravin by se výsledky mohly lišit.


/*
 * 5. Otázka: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách
 * potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
 */















































