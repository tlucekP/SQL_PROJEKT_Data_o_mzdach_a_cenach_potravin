-- Discord: Tlucek#0754

/*
 * Vytvoření tabulky t_peter_tluchor_project_sql_primary_final
 */ 

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

SELECT 
    job_category,
    CASE 
        WHEN AVG(wage) - MIN(wage) > 0 THEN 'Rostoucí'
        WHEN AVG(wage) - MIN(wage) < 0 THEN 'Klesající'
        ELSE 'Bez změny'
    END AS trend
FROM t_peter_tluchor_project_sql_primary_final tptpspf_
WHERE 
    year BETWEEN 2000 AND 2021
GROUP BY 
    job_category;
