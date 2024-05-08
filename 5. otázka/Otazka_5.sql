/*
 * Vytvoření tabulky t_peter_tluchor_project_SQL_secondary_final
 */
   
CREATE OR REPLACE TABLE t_peter_tluchor_project_sql_secondary_final AS
	SELECT
		e.year AS year,
		e.gdp AS GDP,
		a.job_category AS job_category,
		a.wage AS wage,
		a.food_category AS food_category,
		a.food AS food,
		a.price AS price
FROM economies e
LEFT JOIN t_peter_tluchor_project_sql_primary_final a
	ON e.year = a.year
WHERE e.year BETWEEN 2000 AND 2020
	AND e.country = 'Czech republic';



/*
 * 5. Otázka: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách
 * potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
 */

SELECT 
    year,
    AVG(gdp_change_percentage) AS avg_gdp_change_percentage,
    AVG(wage_change_percentage) AS avg_wage_change_percentage,
    AVG(price_change_percentage) AS avg_price_change_percentage,
    CASE
        WHEN AVG(wage_change_percentage) > AVG(gdp_change_percentage) THEN 'Mzdy rostly rychleji než HDP'
        WHEN AVG(wage_change_percentage) < AVG(gdp_change_percentage) THEN 'HDP rostlo rychleji než mzdy'
        ELSE 'HDP a mzdy rostly stejně'
    END AS wage_vs_gdp_trend,
    CASE
        WHEN AVG(price_change_percentage) > AVG(gdp_change_percentage) THEN 'Ceny rostly rychleji než HDP'
        WHEN AVG(price_change_percentage) < AVG(gdp_change_percentage) THEN 'HDP rostlo rychleji než ceny'
        ELSE 'HDP a ceny rostly stejně'
    END AS price_vs_gdp_trend
FROM (
    SELECT 
        year,
        ROUND(((gdp_cz - LAG(gdp_cz) OVER (ORDER BY year)) / LAG(gdp_cz) OVER (ORDER BY year)) * 100,0) AS gdp_change_percentage,
        ROUND(((wage - LAG(wage) OVER (PARTITION BY job_category ORDER BY year)) / LAG(wage) OVER (PARTITION BY job_category ORDER BY year)) * 100,0) AS wage_change_percentage,
        ROUND(((price - LAG(price) OVER (PARTITION BY food_category ORDER BY year)) / LAG(price) OVER (PARTITION BY food_category ORDER BY year)) * 100,0) AS price_change_percentage
    FROM t_peter_tluchor_project_sql_secondary_final
) AS changes
WHERE gdp_change_percentage IS NOT NULL
	AND wage_change_percentage IS NOT NULL
	AND price_change_percentage IS NOT NULL
GROUP BY year;