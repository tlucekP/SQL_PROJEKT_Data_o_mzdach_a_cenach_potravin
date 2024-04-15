# <ins>**SQL PROJEKT - ENGETO, Datová akademie**</ins>
>kurz od 22.2.2024

Vítejte v mém repozitáři SQL projektu v rámci kurzu **Datová Akademie** (SQL), ENGETO.

<ins>Poděkování:</ins>
ENGETO lektorům SQL části (Jan Kammermayer a Matěj Karolyi), rodině za podporu při studiu a všem, kteří mi ve volném čase s problematikou SQL pomáhali.

## <ins>**ÚVOD**</ins>
Tento projekt bude sestávat z:
- tabulek, které bude výstupem ze sady tabulek dle zadání, která budou sloužit jako podklad k zodpovězení definovaných otázek výzkumu.
- SQL dotazů

K získání datových podkladů pro vytvoření tabulek použiji datové sady Engeto.

### <ins>**ZADÁNÍ**</ins>
Pro splnění projektu vytvořím dvě tabulky:

1. ***t_peter_tluchor_project_SQL_primary_final***
>   (pro data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období – společné roky)
2. ***t_peter_tluchor_project_SQL_secondary_final***
> (pro dodatečná data o dalších evropských státech)

Tyto tabulky následně použiji jako datový podklad pro získávání odpovědí na projektové otázky pomocí vypracovaných SQL dotazů.

#### <ins>**Projektové otázky:**</ins>

1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

Pro zodpovězení projektových otázek první části, tzn. oblasti týkající se mezd a cen potravin (otázky 1-4) jsem si vytvořil tabulku **t_peter_tluchor_project_SQL_primary_final**. Pro jednotné účely nově vzniklé tabulky jsem musel identifikovat potřebné parametry pro budoucí SQL dotazy. Datové sady, které jsem použil pro vznik jednotné tabulky jsou:
- czechia_payroll
- czechia_payroll_calculation
- czechia_payroll_industry_branch
- czechia_payroll_unit
- czechia_payroll_value_type
- czechia_price
- czechia_price_category

Parametry sjednocené do nově vzniklé tabulky:
- rok (year)
- pracovní kategorie (job_category)
- mzda (wage)
- kategorie potravin (food_category)
- potraviny (food)
- cena (price)

## 1. Mzdy a ceny

První tabulku s názvem t_peter_tluchor_sql_primary_final jsem vytvořil SQL dotazem uvedeným v SQL_1_wages_prices.sql v repozitáři tohoto projektu.
