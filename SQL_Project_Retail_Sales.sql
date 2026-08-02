-- DATABASE
CREATE DATABASE SQL_Project;

-- TABLES
DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);


-- DATA CLEANING
-- check first 20 records
SELECT * FROM retail_sales
LIMIT 20

-- total data records 
SELECT COUNT(*) FROM retail_sales

-- null values
SELECT * FROM retail_sales
	WHERE 
	  transactions_id IS NULL
	  OR
	  sale_date IS NULL
	  OR
	  sale_time IS NULL
	  OR
	  customer_id IS NULL
	  OR
	  gender IS NULL 
	  OR
	  age IS NULL
	  OR
	  category IS NULL
	  OR
	  quantity IS NULL
	  OR
	  price_per_unit IS NULL
	  OR
	  cogs IS NULL
	  OR
	  total_sale IS NULL

-- delete all null records
DELETE FROM retail_sales
	WHERE 
	  transactions_id IS NULL
	  OR
	  sale_date IS NULL
	  OR
	  sale_time IS NULL
	  OR
	  customer_id IS NULL
	  OR
	  gender IS NULL 
	  OR
	  age IS NULL
	  OR
	  category IS NULL
	  OR
	  quantity IS NULL
	  OR
	  price_per_unit IS NULL
	  OR
	  cogs IS NULL
	  OR
	  total_sale IS NULL

-- check total records now
SELECT COUNT(*) FROM retail_sales

-- DATA EXPLORATION
-- Number of sales?
SELECT COUNT(*) AS total_sales FROM retail_sales

-- Number of customers
SELECT COUNT(customer_id) AS total_customers FROM retail_sales

-- Number of unique customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM retail_sales

-- DATA Analysis
-- Retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales
 WHERE sale_date = '2022-11-05'

-- Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-22
SELECT * FROM retail_sales
 	WHERE category = 'Clothing'
	 AND
	 TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	 AND 
	 quantity > 3

 -- calculate total_sales for each category
 SELECT 
    category,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
 
-- find average age of customers who purchase items from the 'Beauty' category 
SELECT 
  AVG(age) 
FROM retail_sales
WHERE category = 'Beauty'
   
-- find all transactions where the total_sale is greater than 1000
SELECT * FROM retail_sales
  WHERE total_sale > 1000

-- find the total number of transactions(id) made by each gender in each gender in each category 
SELECT 
  (gender),
  COUNT(transactions_id) AS transactions
FROM retail_sales
GROUP BY 1

-- calculate average sale for every moment, find out best selling month of each year
SELECT * FROM (
	  SELECT 
	  EXTRACT(YEAR FROM sale_date) AS Year,
	  EXTRACT(MONTH FROM sale_date) AS Month,
	  AVG(total_sale) AS Avg_sale,
	  RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS Rank
	FROM retail_sales
	GROUP BY 1,2
) AS T1
WHERE Rank = 1

-- find top 5 customers based on the highest total sales
SELECT
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Number of unique customers who changed the purchased items from each category 
SELECT 
  COUNT(DISTINCT customer_id),
  category
FROM retail_sales
GROUP BY category

-- create each shift and number of orders
WITH Hourly_sales AS (
SELECT *,
  CASE
    WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 16 THEN 'Afternoon'
	ELSE 'Evening'
  END AS Shift
FROM retail_sales
) 
SELECT 
   Shift,
   COUNT(*) AS Total_orders
FROM Hourly_sales
GROUP BY Shift

	
