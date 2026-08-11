/*source vs target row count
funtion used count()*/

/*Column mapping validation
confirms every source column has a corresponding target column
funtion used Information_schema query*/
select column_name,data_type from information_schema.columns
 where table_name='stg_superstore_orders' and column_name  not in 
 (select column_name from information_schema.columns where table_name='target_superstore_sales');
 
 /* Data type validation */
 select 
	s.column_name,
    s.data_type as source_DT,
    t.data_type as target_DT
    from information_schema.columns s join information_schema.columns t
    on s.column_name = t.column_name
    where s.table_name ='stg_superstore_orders'
    and t.table_name='target_superstore_sales'
    and s.data_type <> t.data_type;
    
    /* NULL Value validation*/
SELECT
  COUNT(*) AS total_rows,
  COUNT(*) - COUNT(Customer_ID) AS null_customer_id,
  COUNT(*) - COUNT(Product_ID) AS null_product_id,
  COUNT(*) - COUNT(Sales) AS null_sales,
  COUNT(*) - COUNT(Order_Date) AS null_order_date
FROM target_superstore_sales;
    
 SELECT
  COUNT(*) AS total_rows,
  COUNT(*) - COUNT(Customer_ID) AS null_customer_id,
  COUNT(*) - COUNT(Product_ID) AS null_product_id,
  COUNT(*) - COUNT(Sales) AS null_sales,
  COUNT(*) - COUNT(Order_Date) AS null_order_date
FROM target_superstore_sales;

select * from target_superstore_sales 
where customer_id is null or order_id is null;

/*Duplicate validation 
with group by,having,count()*/
select order_id,product_id,count(*) as dup_count
from target_superstore_sales
group by order_id,product_id
having count(*)>1;

select row_id ,count(*) as duplicate_count
from target_superstore_sales
group by row_id
having count(*)>1;

/* Data accuracy validtaion*/
SELECT
  s.Order_ID,
  s.Sales AS source_sales,
  t.Sales AS target_sales,
  s.Quantity AS source_qty,
  t.Quantity AS target_qty
FROM stg_superstore_orders s
JOIN target_superstore_sales t ON s.Order_ID = t.Order_ID
WHERE s.Sales <> t.Sales
   OR s.Quantity <> t.Quantity;
   
/* 12) INCREMENTAL LOAD VALIDATION
   Confirms only new/changed records (based on watermark date) were loaded
   Function used: EXCEPT / MINUS, MAX() */

-- Get latest watermark already loaded into target
select max(order_date) as last_loaded_date from target_superstore_sales;
-- Records in source with Order_Date newer than last load, check they exist in target
SELECT Order_ID, Order_Date
FROM stg_superstore_orders
WHERE Order_Date > (SELECT MAX(Order_Date) FROM target_superstore_sales)
EXCEPT
SELECT Order_ID, Order_Date
FROM target_superstore_sales;

#alternative using left join
SELECT s.Order_ID, s.Order_Date
FROM stg_superstore_orders s
LEFT JOIN target_superstore_sales t ON s.Order_ID = t.Order_ID
WHERE s.Order_Date > (SELECT MAX(Order_Date) FROM target_superstore_sales)
  AND t.Order_ID IS NULL;
#COUNT(DISTINCT)
SELECT COUNT(DISTINCT Customer_ID) AS unique_customers FROM target_superstore_sales;
 select sum(sales) as source_total_sales from stg_superstore_orders; 
 select min(order_date) as earliest_order ,max(order_date) as latest_order from target_superstore_sales;
  
  
  





