-- =====================================================================
-- 03_transformation_validation.sql
-- Validates derived columns in target_superstore_sales
-- =====================================================================
USE retail_etl_validation;

-- 1. Validate profit_margin = profit / sales (should find 4 mismatches)
SELECT 
    order_id,
    sales,
    profit,
    profit_margin AS stored_profit_margin,
    ROUND(profit / NULLIF(sales, 0), 4) AS recalculated_profit_margin
FROM target_superstore_sales
WHERE ROUND(profit / NULLIF(sales, 0), 4) <> profit_margin;


-- 2. Validate aggregation: total sales by region, source vs target
SELECT 'SOURCE' AS side, region, SUM(sales) AS total_sales
FROM source_superstore_orders
GROUP BY region

UNION ALL

SELECT 'TARGET' AS side, region, SUM(sales) AS total_sales
FROM target_superstore_sales
GROUP BY region
ORDER BY region, side;


-- 3. Validate discount_tier business rule (should find 3 mismatches)
-- Rule: Discount > 0.3 = High, 0.1-0.3 = Medium, < 0.1 = Low
SELECT 
    order_id,
    discount,
    discount_tier AS stored_tier,
    CASE 
        WHEN discount > 0.3 THEN 'High'
        WHEN discount BETWEEN 0.1 AND 0.3 THEN 'Medium'
        ELSE 'Low'
    END AS expected_tier
FROM target_superstore_sales
WHERE discount_tier <> 
    CASE 
        WHEN discount > 0.3 THEN 'High'
        WHEN discount BETWEEN 0.1 AND 0.3 THEN 'Medium'
        ELSE 'Low'
    END;


-- 4. Validate order_year / order_month derived correctly from order_date
SELECT 
    order_id,
    order_date,
    order_year,
    order_month,
    YEAR(order_date) AS expected_year,
    MONTH(order_date) AS expected_month
FROM target_superstore_sales
WHERE order_year <> YEAR(order_date)
   OR order_month <> MONTH(order_date);


-- 5. Top 5 products by sales per region (ranking transformation, MySQL-safe)
SELECT * FROM (
    SELECT 
        region,
        product_id,
        sales,
        RANK() OVER (PARTITION BY region ORDER BY sales DESC) AS sales_rank
    FROM target_superstore_sales
) ranked
WHERE sales_rank <= 5;
