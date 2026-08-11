-- =====================================================================
-- 04_referential_integrity.sql
-- Compares product/customer references between source and target
-- =====================================================================
USE retail_etl_validation;

-- 1. Orphan check: product_id in TARGET that doesn't exist in SOURCE
--    (should find 1 row: product_id PR-9999)
SELECT t.row_id, t.order_id, t.product_id
FROM target_superstore_sales t
LEFT JOIN source_superstore_orders s
    ON t.product_id = s.product_id
WHERE s.product_id IS NULL;


-- 2. Orphan check: customer_id in TARGET that doesn't exist in SOURCE
--    (the 2 NULL customer_id rows will also show here — NULLs never match)
SELECT t.row_id, t.order_id, t.customer_id
FROM target_superstore_sales t
LEFT JOIN source_superstore_orders s
    ON t.customer_id = s.customer_id
WHERE s.customer_id IS NULL;


-- 3. Consistency check: does category in target match category in source
--    for the same product_id? (catches mismatched joins/stale lookups)
SELECT 
    t.order_id,
    t.product_id,
    t.category AS target_category,
    s.category AS source_category
FROM target_superstore_sales t
JOIN source_superstore_orders s 
    ON t.product_id = s.product_id
WHERE t.category <> s.category;


-- 4. Constraint check: quantity and sales should never be negative
SELECT *
FROM target_superstore_sales
WHERE quantity < 0
   OR sales < 0;


-- 5. Duplicate check: same customer_id mapped to more than one customer_name
--    within target (would indicate a broken customer dimension)
SELECT customer_id, COUNT(DISTINCT customer_name) AS name_variations
FROM target_superstore_sales
WHERE customer_id IS NOT NULL
GROUP BY customer_id
HAVING COUNT(DISTINCT customer_name) > 1;
