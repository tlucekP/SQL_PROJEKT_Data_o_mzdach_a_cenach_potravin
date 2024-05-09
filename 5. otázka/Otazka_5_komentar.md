## Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenáchpotravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

Pro zodpovězení této otázky se vytvořím tabulku t_peter_tluchor_project_sql_secondary_final. Tato tabulka bude obsahovat spojení datových sad:

> t_peter_tluchor_project_sql_primary_final
>
> economies

Výsledkem je tabulka s nejnutnějšími daty pro následné dotazování. Tabulka obsahuje sloupce:
- year (rok)
- GDP (HDP)
- job_category (profese)
- wage (mzda)
- food_category (číselná kategorie potravin)
- food (typ potravin)
- price (ceny potravin)

Kontrolu provedem standardním dotazováním na výpis dat.

Pro zodpovězení otázky jsem zpracoval dotaz, který vrací průměrné meziroční procentuální změny HDP, mezd a cen potravin (všech profesí o typu potravin), na základě kterých lze analyzovat, jak se
vyvíjela jejich meziroční hodnota a zda byl trend vůči HDP rychleji rostoucí nebo pomaleji rostoucí.

**<ins>ODPOVĚĎ</ins>**: viz výsledek dotazu.
