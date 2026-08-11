-- =====================================================================
-- 00_schema_setup.sql
-- Purpose: Create the SOURCE and TARGET tables. You will import 
--          source_superstore_orders.csv into source_superstore_orders,
--          and target_superstore_sales.csv into target_superstore_sales.
-- =====================================================================

CREATE DATABASE IF NOT EXISTS retail_etl_validation;
USE retail_etl_validation;

-- ---------------------------------------------------------------
-- SOURCE table (raw data, before transformation)
-- ---------------------------------------------------------------
DROP TABLE IF EXISTS source_superstore_orders;

CREATE TABLE source_superstore_orders (
    row_id          INT,
    order_id        VARCHAR(20),
    order_date      DATE,
    ship_date       DATE,
    ship_mode       VARCHAR(30),
    customer_id     VARCHAR(20),
    customer_name   VARCHAR(100),
    segment         VARCHAR(30),
    country         VARCHAR(50),
    city            VARCHAR(50),
    state           VARCHAR(50),
    postal_code     VARCHAR(10),
    region          VARCHAR(20),
    product_id      VARCHAR(20),
    category        VARCHAR(30),
    sub_category    VARCHAR(30),
    product_name    VARCHAR(150),
    sales           DECIMAL(10,4),
    quantity        INT,
    discount        DECIMAL(4,2),
    profit          DECIMAL(10,4)
);

-- ---------------------------------------------------------------
-- TARGET table (after transformation — has extra derived columns:
-- profit_margin, discount_tier, order_year, order_month)
-- ---------------------------------------------------------------
DROP TABLE IF EXISTS target_superstore_sales;

CREATE TABLE target_superstore_sales (
    row_id          INT,
    order_id        VARCHAR(20),
    order_date      DATE,
    ship_date       DATE,
    ship_mode       VARCHAR(30),
    customer_id     VARCHAR(20),
    customer_name   VARCHAR(100),
    segment         VARCHAR(30),
    country         VARCHAR(50),
    city            VARCHAR(50),
    state           VARCHAR(50),
    postal_code     VARCHAR(10),
    region          VARCHAR(20),
    product_id      VARCHAR(20),
    category        VARCHAR(30),
    sub_category    VARCHAR(30),
    product_name    VARCHAR(150),
    sales           DECIMAL(10,4),
    quantity        INT,
    discount        DECIMAL(4,2),
    profit          DECIMAL(10,4),
    profit_margin   DECIMAL(10,4),
    discount_tier   VARCHAR(10),
    order_year      INT,
    order_month     INT
);

-- After creating these two tables, import the two CSV files using
-- MySQL Workbench's Table Data Import Wizard:
--   source_superstore_orders.csv  -> source_superstore_orders table
--   target_superstore_sales.csv   -> target_superstore_sales table
