-- =====================================================================
-- 01_row_count_validation.sql
-- Compares source_superstore_orders vs target_superstore_sales
-- =====================================================================
USE retail_etl_validation;

-- 1. Simple row count comparison
SELECT 
    (SELECT COUNT(*) FROM source_superstore_orders) AS source_row_count,
    (SELECT COUNT(*) FROM target_superstore_sales) AS target_row_count,
    (SELECT COUNT(*) FROM source_superstore_orders) 
        - (SELECT COUNT(*) FROM target_superstore_sales) AS row_count_difference;
-- Expect a non-zero difference here — that's expected and correct, not a bug in your setup.


-- 2. Row count by Region: source vs target
SELECT region, COUNT(*) AS source_count
FROM source_superstore_orders
GROUP BY region

UNION ALL

SELECT region, COUNT(*) AS target_count
FROM target_superstore_sales
GROUP BY region;


-- 3. Records in SOURCE but missing from TARGET (should show the 5 dropped rows)
SELECT s.row_id, s.order_id
FROM source_superstore_orders s
LEFT JOIN target_superstore_sales t
    ON s.order_id = t.order_id
WHERE t.order_id IS NULL;


-- 4. Records in TARGET but NOT in SOURCE (should show the 1 orphan row, order_id ORD-2099999)
SELECT t.row_id, t.order_id
FROM target_superstore_sales t
LEFT JOIN source_superstore_orders s
    ON t.order_id = s.order_id
WHERE s.order_id IS NULL;
