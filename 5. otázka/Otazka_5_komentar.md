## Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenáchpotravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

Pro zodpovězení této otázky si vytvořím tabulku **t_peter_tluchor_project_sql_secondary_final**. Tato tabulka bude obsahovat spojení datových sad:

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

Kontrolu provedeme standardním dotazováním na výpis dat.

Pro zodpovězení otázky jsem zpracoval dotaz, který vrací průměrné meziroční procentuální změny HDP, mezd a cen potravin (všech profesí o typu potravin), na základě kterých lze analyzovat, jak se
vyvíjela jejich meziroční hodnota a zda byl trend vůči HDP rychleji rostoucí nebo pomaleji rostoucí.

**<ins>ODPOVĚĎ</ins>**: Ano, výška HDP má vliv na vývoj mezd a cen potravin. Změna výše mezd a potravin má ale oproti HDP jedno roční zpoždění. Nicméně mzdy i ceny potravin rostou nebo klesají nezávisle na sobě. Z dostupných dat tento trend pozorujeme na letech 2008 - 2018, přičemž mezi lety 2008 - 2015 svět procházel obdobím celosvětové finanční krize. I z toho důvodu je toto sledované období zatíženo ekonomickými specifiky, které v jednotlivých letech nemusí podporovat tvrzení o vázaném růstu či poklesu HDP, mezd a komodit. Již po roce 2013 byl na vzestupu zaměstnanecký sektor, kdežto ceny potravin reagovaly na uzdravený trh až po roce 2016.
