# Retail Sales ETL Validation

## Overview
This project simulates a real-world ETL testing workflow for retail sales data. 
It validates that data was loaded and transformed correctly between a source 
system and a target system, using SQL-based testing techniques commonly used 
in data warehouse QA roles.

## Objective
To verify data accuracy, completeness, and consistency after an ETL load — 
covering the same validation categories used in production ETL testing: 
row count reconciliation, null/duplicate detection, transformation logic 
validation, and referential integrity checks between source and target.

## Tools Used
- MySQL / MySQL Workbench
- SQL (joins, subqueries, window functions, aggregate functions, CASE logic)
- Superstore-style retail sales dataset

## Project Structure
- `source_superstore_orders` — raw order data as it comes from the source system (21 columns)
- `target_superstore_sales` — the same data after ETL transformation, with 4 additional derived columns: `profit_margin`, `discount_tier`, `order_year`, `order_month`

## Validation Types Covered
1. **Row count validation** — comparing total and region-wise row counts between source and target, and identifying missing or orphan records
2. **Null and duplicate checks** — detecting unexpected NULLs in critical columns and duplicate order records
3. **Transformation validation** — recalculating derived fields (profit margin, discount tier, order year/month) and comparing them against stored target values to catch transformation logic errors
4. **Referential integrity checks** — verifying that every product and customer referenced in the target actually exists in the source, and that category/customer data stays consistent across both

## How It's Organized
```
retail-sales-etl-validation/
│
├── README.md
├── data/
│   ├── source_superstore_orders.csv
│   └── target_superstore_sales.csv
├── sql/
│   ├── 00_schema_setup.sql
│   ├── 01_row_count_validation.sql
│   ├── 02_null_duplicate_checks.sql
│   ├── 03_transformation_validation.sql
│   └── 04_referential_integrity.sql
├── test_cases/
│   └── test_case_log.csv

```
**Note on `sql/ETL_12_Core_Validations_SQL.sql`:** this is a broader reference 
script covering 12 general ETL validation techniques (a study/reference resource), 
separate from the 4 numbered scripts above which are the actual test scripts run 
against this project's source and target tables.
## Key Learnings
- Practical application of SQL for end-to-end data quality testing
- Structuring test cases the way QA teams document them (expected vs actual, pass/fail)
- Systematically identifying real data issues: missing rows, duplicates, incorrect transformation logic, and broken referential integrity

## Author
Anusha — Aspiring ETL Tester / Data QA Analyst
