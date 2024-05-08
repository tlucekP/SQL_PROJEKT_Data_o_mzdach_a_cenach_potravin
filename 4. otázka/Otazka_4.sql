/*
 * 4. Otázka: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
 */


WITH yearly_stats AS (
	SELECT
		year,
		AVG(wage) AS avg_wage,
		AVG(price) AS avg_price
	FROM t_peter_tluchor_project_sql_primary_final
	GROUP BY year
),
price_change AS (
	SELECT
		year,
		avg_price,
		LAG(avg_price) OVER (ORDER BY year) AS prev_avg_price
	FROM yearly_stats
),
wage_change AS (
    SELECT
        year,
        avg_wage,
        LAG(avg_wage) OVER (ORDER BY year) AS prev_avg_wage
    FROM yearly_stats
)
SELECT
    ys.year,
    round(ys.avg_wage, 2) AS avg_wage,
    round(ys.avg_price, 2) AS avg_price,
    ROUND(((ys.avg_price - pc.prev_avg_price) / pc.prev_avg_price) * 100, 2) AS price_change_percentage,
    ROUND(((ys.avg_wage - wc.prev_avg_wage) / wc.prev_avg_wage) * 100, 2) AS wage_change_percentage,
    CASE WHEN ((ys.avg_price - pc.prev_avg_price) / pc.prev_avg_price) * 100 > ((ys.avg_wage - wc.prev_avg_wage) / wc.prev_avg_wage) * 100 + 10 THEN 'Ano' ELSE 'Ne'
    	END AS focus_price_growth
FROM yearly_stats ys
JOIN price_change pc
	ON ys.year = pc.year
JOIN wage_change wc 
	ON ys.year = wc.YEAR
WHERE ys.avg_wage IS NOT NULL
    AND ys.avg_price IS NOT NULL
    AND pc.prev_avg_price IS NOT NULL;