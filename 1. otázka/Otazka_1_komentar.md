## Rostou v průběhu let mzdy ve všech odvětvích nebo v některých klesají?

Pro zodpovězení této (a dalších otázek) si vytvořím tabulku **t_peter_tluchor_project_sql_primary_final**. Tato tabulka bude obsahovat spojení datových sad:
> czechia_payroll
> 
> czechia_payroll_industry_branch
> 
> czechia_price
> 
> czechia_price_category

Výsledkem je ucelená tabulka s nejnutnějšími daty pro následné dotazování. Tabulka obsahuje sloupce:

- year (rok)
- job_category (profese)
- wage (mzda)
- food category (číselná kategorie potravin)
- food (typ potravin)
- price (ceny potravin)

Kontrolu provedeme standardním dotazováním na výpis dat. Pro rychlejší budoucí práci s databází jsem hodnoty v této nově vytvořené tabulce zaindexoval.


Nyní mohu přistoupit k dotazování na samotnou pointu zadání, tedy zda v průběhu let rostou mzdy ve všech pracovních odvětvích nebo klesají.

Ke zjištění přistupuji dotazováním se na trend na základě rozdílu mezi průměrnou mzdou v roce 2000 a minimální mzdou mezi lety 2000 - 2021.

**ODPOVĚĎ**: Ve všech pracovních kategoriích je trend průměrné mzdy rostoucí.

**Zdůvodnění**: Mzdy jsou v tabulce uváděny na kvartální bázi. Pro záskání uceleného pohledu na jejich meziroční vývoj jsem musel zprůměrovat mzdy za každý sledovaný rok.
