-- add time_of_day column 
SELECT
    "Time",
    CASE
        WHEN "Time" BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN "Time" BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM walmart_sales ws;


-- add new column
ALTER TABLE walmart_sales  ADD COLUMN time_of_day VARCHAR(20);

UPDATE walmart_sales 
SET time_of_day =
	CASE
        WHEN "Time" BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN "Time" BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END;


-- Add day_name column
SELECT
    "Date",
    EXTRACT(DOW FROM TO_DATE("Date", 'YYYY-MM-DD')) AS day_of_week,
    CASE
        WHEN EXTRACT(DOW FROM TO_DATE("Date", 'YYYY-MM-DD')) = 1 THEN 'Sunday'
        WHEN EXTRACT(DOW FROM TO_DATE("Date", 'YYYY-MM-DD')) = 2 THEN 'Monday'
        WHEN EXTRACT(DOW FROM TO_DATE("Date", 'YYYY-MM-DD')) = 3 THEN 'Tuesday'
        WHEN EXTRACT(DOW FROM TO_DATE("Date", 'YYYY-MM-DD')) = 4 THEN 'Wednesday'
        WHEN EXTRACT(DOW FROM TO_DATE("Date", 'YYYY-MM-DD')) = 5 THEN 'Thursday'
        WHEN EXTRACT(DOW FROM TO_DATE("Date", 'YYYY-MM-DD')) = 6 THEN 'Friday'
        WHEN EXTRACT(DOW FROM TO_DATE("Date", 'YYYY-MM-DD')) = 7 THEN 'Saturday'
        ELSE 'Unknown'
    END AS day_name
FROM walmart_sales ws;

   
ALTER TABLE walmart_sales  ADD COLUMN day_name VARCHAR(10);

UPDATE walmart_sales 
SET day_name = 
    CASE
        WHEN EXTRACT(DOW FROM TO_DATE("Date", 'YYYY-MM-DD')) = 1 THEN 'Sunday'
        WHEN EXTRACT(DOW FROM TO_DATE("Date", 'YYYY-MM-DD')) = 2 THEN 'Monday'
        WHEN EXTRACT(DOW FROM TO_DATE("Date", 'YYYY-MM-DD')) = 3 THEN 'Tuesday'
        WHEN EXTRACT(DOW FROM TO_DATE("Date", 'YYYY-MM-DD')) = 4 THEN 'Wednesday'
        WHEN EXTRACT(DOW FROM TO_DATE("Date", 'YYYY-MM-DD')) = 5 THEN 'Thursday'
        WHEN EXTRACT(DOW FROM TO_DATE("Date", 'YYYY-MM-DD')) = 6 THEN 'Friday'
        WHEN EXTRACT(DOW FROM TO_DATE("Date", 'YYYY-MM-DD')) = 7 THEN 'Saturday'
        ELSE 'Unknown'
    END;


-- Add month_name column
SELECT
    "Date",
    TO_CHAR("Date"::date, 'Month') AS month_name
FROM walmart_sales ws;

ALTER TABLE walmart_sales ADD COLUMN month_name VARCHAR(10);

UPDATE walmart_sales
SET month_name = TO_CHAR("Date"::date, 'Month');


---------------------------------  General Questions --------------------------------------
--1. how many unique cities does the data have 
SELECT 
	DISTINCT city
FROM walmart_sales ws;

--2. In which city is each branch?
SELECT 
	DISTINCT city,
    branch
FROM walmart_sales ws;

------------------------------------   Product	---------------------------------------------
-- 1.How many unique product lines does the data have?
SELECT
	DISTINCT "Product line" 
FROM walmart_sales;


-- 2.What is the most selling product line
SELECT
	SUM(quantity) as qty,
    "Product line" 
FROM walmart_sales ws 
GROUP BY "Product line" 
ORDER BY qty DESC;

-- 2. whaat is the most common payment methods?
SELECT payment,
	COUNT(payment)as payment_count
from walmart_sales ws 
group by payment 
order by payment_count desc;
	

-- 3.What is the total revenue by month
SELECT
    TO_CHAR("Date"::date, 'Month') AS month_name,
    SUM(total) AS total_revenue
FROM walmart_sales
GROUP BY TO_CHAR("Date"::date, 'Month')
ORDER BY total_revenue;

-- 4.What month had the largest COGS?
SELECT
	month_name AS month,
	SUM(cogs) AS cogs
FROM walmart_sales ws 
GROUP BY month_name 
ORDER BY cogs desc;

-- 5.What is the city with the largest revenue?
SELECT
	branch,
	city,
	SUM(total) AS total_revenue
FROM walmart_sales ws 
GROUP BY city, branch 
ORDER BY total_revenue;


-- 6. What product line had the largest VAT?
SELECT
	"Product line",
	AVG("Tax 5%") as avg_tax
FROM walmart_sales ws 
GROUP BY "Product line" 
ORDER BY avg_tax DESC;


-- Which branch sold more products than average product sold?
SELECT 
	branch, 
    SUM(quantity) AS quantity_
FROM walmart_sales ws 
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) from walmart_sales);


-- What is the most common product line by gender
SELECT
	gender,
    "Product line",
    COUNT(gender) AS gender_count
FROM walmart_sales
GROUP BY gender, "Product line" 
ORDER BY gender_count DESC;


-- What is the average rating of each product line
SELECT
    "Product line",
    ROUND(AVG(rating)::numeric, 2) AS avg_rating
from walmart_sales
GROUP by "Product line"
ORDER by avg_rating DESC;

-------------------------------------------   Customer    --------------------------------------------

-- How many unique customer types does the data have?
SELECT
	DISTINCT "Customer type" 
FROM walmart_sales ws ;

-- How many unique payment methods does the data have?
SELECT
	distinct payment 
FROM walmart_sales ws ;


-- What is the most common customer type?
SELECT
	"Customer type" ,
	count(*) as count
FROM walmart_sales ws 
GROUP BY "Customer type" 
ORDER BY count DESC;


-- What is the gender of most of the customers?
SELECT
	gender, 
	COUNT(*) as gender_cnt
FROM walmart_sales ws 
GROUP BY gender 
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?

SELECT
    branch,
    gender,
    COUNT(*) AS gender_count
from walmart_sales
GROUP by branch, gender
ORDER by branch, gender;


-- Which time of the day do customers give most ratings?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating 
FROM walmart_sales ws 
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Looks like time of the day does not really affect the rating, its
-- more or less the same rating each time of the day


-- Which time of the day do customers give most ratings per branch?
SELECT
    branch,
    time_of_day,
    AVG(rating) AS avg_rating
from walmart_sales ws 
GROUP by branch, time_of_day
ORDER by AVG(rating) DESC;

-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.


-- Which day fo the week has the best avg ratings?
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM walmart_sales ws 
GROUP BY day_name 
ORDER BY avg_rating DESC;

-- sunday,Thursday and monday are the top best days for good ratings
-- why is that the case, how many sales are made on these days?

SELECT
    day_name,
    COUNT(*) AS sales_count,
    AVG(rating) AS avg_rating
from walmart_sales ws
GROUP BY
    day_name 
ORDER BY
    avg_rating DESC;
   
-- Which day of the week has the best average ratings per branch?
SELECT
    branch,
    day_name,
    COUNT(*) AS total_sales,
    AVG(rating) AS avg_rating
FROM
    walmart_sales ws 
GROUP BY
    branch, day_name
ORDER BY
    branch, avg_rating DESC;
   
SELECT 
	day_name ,
	COUNT(day_name) total_sales
FROM 
	walmart_sales ws 
where
 	branch = 'A'
GROUP BY day_name 
ORDER BY total_sales DESC;

-------------------------------------------------------------------    Sales     -----------------------------------------------------------------   

-- Number of sales made in each time of the day per weekday 
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM walmart_sales ws 
WHERE day_name  = 'Sunday'
GROUP BY time_of_day  
ORDER BY total_sales DESC;
-- Evenings experience most sales, the stores are 
-- filled during the evening hours

-- Which of the customer types brings the most revenue?
SELECT
	"Customer type" ,
	SUM(total) AS total_revenue
FROM walmart_sales ws 
GROUP BY "Customer type" 
ORDER BY total_revenue desc ;

-- Which city has the largest tax/VAT percent?
SELECT
    city,
    ROUND(AVG("Tax 5%"::numeric), 2) AS avg_tax
FROM walmart_sales
GROUP BY city
ORDER BY avg_tax DESC;


-- Which customer type pays the most in VAT?
SELECT
	"Customer type",
	AVG("Tax 5%") AS total_tax
FROM walmart_sales ws 
GROUP BY "Customer type" 
ORDER BY total_tax;


-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------






--check
select * from walmart_sales ws
limit 50;