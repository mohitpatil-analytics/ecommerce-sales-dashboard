CREATE DATABASE Superstore;

USE Superstore;

CREATE TABLE orders (
    row_id INT,
    order_id VARCHAR(20),
    order_date VARCHAR(15),
    ship_date VARCHAR(15),
    ship_mode VARCHAR(30),
    customer_id VARCHAR(15),
    customer_name VARCHAR(50),
    segment VARCHAR(20),
    country VARCHAR(30),
    city VARCHAR(30),
    state VARCHAR(30),
    postal_code VARCHAR(10),
    region VARCHAR(15),
    product_id VARCHAR(20),
    category VARCHAR(20),
    sub_category VARCHAR(20),
    product_name VARCHAR(200),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(10,4)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Sample- Superstore.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT ROUND(SUM(sales), 2) AS total_sales,
        ROUND(SUM(profit), 2) AS total_profit
FROM orders;

SELECT 
    COUNT(DISTINCT customer_id) AS total_customers 
FROM orders;

SELECT 
    customer_name, 
    ROUND(SUM(sales), 2) AS sales
FROM orders
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;

SELECT
    region,
    ROUND(SUM(sales), 2) AS sales,
    ROUND(SUM(profit), 2) AS profit
FROM orders
GROUP BY region
ORDER BY sales DESC;

SELECT 
    category, 
    ROUND(SUM(sales), 2) AS revenue,
    ROUND(SUM(profit), 2) AS profit
FROM orders
GROUP BY category
ORDER BY revenue DESC;

ALTER TABLE orders 
    ADD COLUMN order_datee DATE,
    ADD COLUMN ship_datee DATE;

UPDATE orders 
SET order_datee = STR_TO_DATE(order_date, '%m/%d/%Y'),
    ship_datee = STR_TO_DATE(ship_date, '%m/%d/%Y');

UPDATE orders 
SET order_datee = CASE 
    WHEN order_date LIKE '%/%' 
    THEN STR_TO_DATE(order_date, '%m/%d/%Y')
    ELSE STR_TO_DATE(order_date, '%d-%m-%Y')
END,
ship_datee = CASE 
    WHEN ship_date LIKE '%/%' 
    THEN STR_TO_DATE(ship_date, '%m/%d/%Y')
    ELSE STR_TO_DATE(ship_date, '%d-%m-%Y')
END;

UPDATE orders 
SET ship_datee = CASE 
    WHEN ship_date LIKE '%/%' 
    THEN STR_TO_DATE(ship_date, '%m/%d/%Y')
    ELSE STR_TO_DATE(ship_date, '%d-%m-%Y')
END;

SELECT order_date, order_datee, ship_date, ship_datee 
FROM orders 
LIMIT 5;

ALTER TABLE orders 
DROP COLUMN order_date,
DROP COLUMN ship_date;

ALTER TABLE orders RENAME COLUMN order_datee TO order_date;
ALTER TABLE orders RENAME COLUMN ship_datee TO ship_date;

DESCRIBE orders;

SELECT 
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    ROUND(SUM(sales), 2) AS sales
FROM orders
GROUP BY year, month
ORDER BY year, month;

