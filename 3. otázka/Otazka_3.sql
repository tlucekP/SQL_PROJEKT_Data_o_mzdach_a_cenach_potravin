/*
 * 3. Otázka: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
 */

-- Pro potřeby této otázky si pomůžu klauzulí WITH a to tak, že vytvořímm dvě pomocné tabulky. První pro výpočet meziroční změny cen a
-- druhou pro průměrnou změnu cen jednotlivých kategorií potravin. Jako první si napíšu dotaz pro meziroční změny cen.

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
FROM category_average_change cac
WHERE cac.average_change_percentage = (
	SELECT MIN(average_change_percentage)
	FROM category_average_change cac);

-- 	Odpověď: Nejpomaleji zdražuje Cukr krystalový.