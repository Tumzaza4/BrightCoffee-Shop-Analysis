--To check all the column names in my data
--To check data types in my data
SELECT*
FROM sales.retail.bright_coffee;
--------------------------------------------------------------------------------------------------------------------------
--Check categorical columns
SELECT DISTINCT store_location
FROM sales.retail.bright_coffee;

SELECT DISTINCT product_category
FROM sales.retail.bright_coffee;

SELECT DISTINCT product_type
FROM sales.retail.bright_coffee;
-------------------------------------------------------------------------------------------------------------------------
--Revenue per transaction
SELECT transaction_id,
transaction_qty*unit_price AS revenue
FROM sales.retail.bright_coffee;
-----------------------------------------------------------------------------------------------------------------------
--Remember with the ID's we use the COUNT NOT SUM
--This is the total number of sales/transactions made
SELECT COUNT(transaction_id) AS number_of_transaction
FROM sales.retail.bright_coffee;
-------------------------------------------------------------------------------------------------------------------------
--Count the number of different shops we have in this data
SELECT COUNT(DISTINCT store_id) AS number_of_shops
FROM sales.retail.bright_coffee;

--To show the names of the different store location which is actually 3 different shops 
SELECT DISTINCT store_location, store_id
FROM sales.retail.bright_coffee;
------------------------------------------------------------------------------------------------------------------------
--How to calculate the revenue by store location
SELECT store_location,
SUM(transaction_qty*unit_price) AS revenue
FROM sales.retail.bright_coffee
GROUP BY store_location;
-----------------------------------------------------------------------------------------------------------------------
--How to calculate the revenue by product category
SELECT product_category,
SUM(transaction_qty*unit_price) AS revenue
FROM sales.retail.bright_coffee
WHERE store_location='Astoria'
GROUP BY product_category
ORDER BY revenue DESC;
----------------------------------------------------------------------------------------------------------------------------
--DATE and time Functions
--Checking the first transaction date
SELECT MIN(transaction_date) AS first_operating_date
FROM sales.retail.bright_coffee;

--Checking the latest transaction date
SELECT MAX(transaction_date) AS last_operating_date
FROM sales.retail.bright_coffee;

SELECT transaction_date,
       DAYNAME(transaction_date) AS day_name,
       CASE 
           WHEN day_name IN ('Sun', 'Sat') THEN 'Weekend'
           ELSE 'Weekday'
       END AS day_classification,
       MONTHNAME(transaction_date) AS month_name
FROM sales.retail.bright_coffee;
-------------------------------------------------------------------------------------------------------------------------------
--What time does the shop open
SELECT MIN(transaction_time) opening_time
FROM sales.retail.bright_coffee;
-------------------------------------------------------------------------------------------------------------------------------------------
--What time does the store close
SELECT MAX(transaction_time) closing_time
FROM sales.retail.bright_coffee;
------------------------------------------------------------------------------------------------------------------------------------------
--Creating time buckets and the final table
SELECT transaction_date,
       DAYNAME(transaction_date) AS day_name,
       CASE
           WHEN DAYNAME(transaction_date) IN ('Sat','Sun') THEN 'Weekend'
           ELSE 'weekday'
           END AS day_classification,
           MONTHNAME(transaction_date) AS month_name,
           transaction_time,

       CASE
           WHEN transaction_time BETWEEN '06:00:00' AND '11:59:59' THEN '01. Morning'
           WHEN transaction_time BETWEEN '12:00:00' AND '15:59:59' THEN '02. Afternoon'
           WHEN transaction_time BETWEEN '16:00:00' AND '19:59:59' THEN '03. Evening'
           WHEN transaction_time >= '20:00:00' THEN '04. Night'
       END AS time_bucket,
       HOUR(transaction_time) AS hour_of_day,
       store_location,
       product_category,
       product_detail,
       product_type,
       COUNT (DISTINCT transaction_id) AS numbr_of_sales,
       SUM(transaction_qty*unit_price) AS revenue,
FROM sales.retail.bright_coffee
GROUP BY All;
