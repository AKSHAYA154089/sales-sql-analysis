create database sales_data;
use sales_data;
SELECT * FROM sales_april_2019;

-- Product wise revenue

SELECT 
    `Product`,
    SUM(`Quantity Ordered` * `Price Each`) AS TotalRevenue
FROM sales_april_2019
GROUP BY `Product`
ORDER BY TotalRevenue DESC;


DESCRIBE sales_april_2019;

SET SQL_SAFE_UPDATES = 0;
SELECT `Order Date`
FROM sales_april_2019
LIMIT 10;

-- First, remove obvious bad values (text, NA, empty).
-- Delete non-date values

DELETE FROM sales_april_2019
WHERE TRIM(`Order Date`) = ''
   OR `Order Date` IS NULL
   OR `Order Date` = 'NA'
   OR `Order Date` = 'Order Date';

-- Now Delete Invalid Formats

DELETE FROM sales_april_2019
WHERE STR_TO_DATE(TRIM(`Order Date`), '%m/%d/%y %H:%i') IS NULL;

-- Convert Dates

UPDATE sales_april_2019
SET order_datetime = STR_TO_DATE(
    TRIM(`Order Date`),
    '%m/%d/%y %H:%i'
);

-- Check

SELECT `Order Date`, order_datetime
FROM sales_april_2019
LIMIT 10;

-- This for Monthly Revenue

SELECT 
    YEAR(order_datetime) AS year_id,
    MONTH(order_datetime) AS month_id,
    SUM(`Quantity Ordered` * `Price Each`) AS MonthlyRevenue
FROM sales_april_2019
GROUP BY year_id, month_id
ORDER BY year_id, month_id;

-- Customer-wise Total Spending 
SELECT 
    `Purchase Address` AS Customer,
    SUM(`Quantity Ordered` * `Price Each`) AS TotalSpending
FROM sales_april_2019
GROUP BY `Purchase Address`
ORDER BY TotalSpending DESC
LIMIT 10;

-- Best-Selling Products

SELECT 
    Product,
    SUM(`Quantity Ordered`) AS TotalQuantity
FROM sales_april_2019
GROUP BY Product
ORDER BY TotalQuantity DESC;

-- Top Customers (by Address)

SELECT 
    `Purchase Address`,
    SUM(`Quantity Ordered` * `Price Each`) AS Spending
FROM sales_april_2019
GROUP BY `Purchase Address`
ORDER BY Spending DESC
LIMIT 10;

-- City-wise Sales Analysis

SELECT 
    SUBSTRING_INDEX(SUBSTRING_INDEX(`Purchase Address`, ',', 2), ',', -1) AS City, -- Inner function meaning is Give me everything before the 2nd comma and outer function meaning is From this, give me the last part after comma
    SUM(`Quantity Ordered` * `Price Each`) AS Revenue
FROM sales_april_2019
GROUP BY City
ORDER BY Revenue DESC;


-- Peak Sales Hours(Shows best selling time.)

SELECT 
    HOUR(order_datetime) AS Hour,
    SUM(`Quantity Ordered`) AS Orders
FROM sales_april_2019
GROUP BY Hour
ORDER BY Orders DESC;


-- Average Order Value

SELECT 
    AVG(`Quantity Ordered` * `Price Each`) AS AvgOrderValue
FROM sales_april_2019;

