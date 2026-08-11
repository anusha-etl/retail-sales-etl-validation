-- =====================================================================
-- 02_null_duplicate_checks.sql
-- Run against target_superstore_sales (the loaded/transformed table)
-- =====================================================================
USE retail_etl_validation;

-- 1. Check for NULLs in critical columns (should find 2 NULL customer_id rows)
SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END)      AS null_order_id,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END)   AS null_customer_id,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END)    AS null_product_id,
    SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END)    AS null_order_date,
    SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END)         AS null_sales
FROM target_superstore_sales;


-- 2. Show the actual rows with NULL customer_id
SELECT *
FROM target_superstore_sales
WHERE customer_id IS NULL;


-- 3. Duplicate check on order_id (should find 3 duplicated rows)
SELECT order_id, COUNT(*) AS duplicate_count
FROM target_superstore_sales
GROUP BY order_id
HAVING COUNT(*) > 1;


-- 4. Same duplicate check using ROW_NUMBER(), to see the actual duplicate rows
SELECT *
FROM (
    SELECT 
        t.*,
        ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY row_id) AS row_num
    FROM target_superstore_sales t
) ranked
WHERE row_num > 1;


-- 5. Check for blank strings in text fields
SELECT *
FROM target_superstore_sales
WHERE TRIM(customer_name) = ''
   OR TRIM(product_name) = '';
