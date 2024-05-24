-- Database Selection
USE mitron_bnk;

-- Create table dim_customer
CREATE TABLE dim_cus (
    customer_id VARCHAR(10) PRIMARY KEY,
    age_group VARCHAR(5),
    city VARCHAR(50),
    occupation VARCHAR(50),
    gender VARCHAR(10),
    marital_status VARCHAR(10),
    avg_income DECIMAL(10 , 2 )
);

CREATE TABLE fact_spends (
    customer_id VARCHAR(10),
    month VARCHAR(10),
    category VARCHAR(50),
    payment_type VARCHAR(20),
    spend DECIMAL(10 , 2 ),
    FOREIGN KEY (customer_id)
        REFERENCES dim_cus (customer_id)
);

-- Data Inspection Commands.
SELECT 
    COUNT(*)
FROM
    fact_spends;

SELECT 
    COUNT(*)
FROM
    dim_cus;
    
SELECT *
FROM dim_cus;

SELECT *
FROM fact_spends;

-- Total Number of Unique Customers.
SELECT DISTINCT
    (COUNT(*)) AS 'Total Customers'
FROM
    dim_cus;

-- Unique age group.
SELECT DISTINCT
    (age_group) AS 'Unique Age Group'
FROM
    dim_cus;

-- Unique city.
SELECT DISTINCT
    (city) AS 'Unique City'
FROM
    dim_cus;
    
-- Unique Occupation.
SELECT DISTINCT
    (occupation) AS 'Unique Occupation'
FROM
    dim_cus;
    
-- Gender Wise Male and Female 
SELECT COUNT(gender) AS 'Total', 
			gender AS "Gender"
FROM dim_cus
GROUP BY gender;


-- Occupation wise total avg income.
SELECT occupation, 
		ROUND(SUM(avg_income)/ 1000000,2) AS "Total Average Income (Millions)"
FROM dim_cus
GROUP BY occupation;

-- Customer distribution by occupation
SELECT COUNT(customer_id) AS 'Total Customers', occupation AS "Occupation"
From mitron_bnk.dim_cus
GROUP BY occupation;

-- Customer distribution by age
SELECT COUNT(customer_id) AS 'Total Customers', age_group AS "Age Group"
From mitron_bnk.dim_cus
GROUP BY age_group;

-- Customer distribution by city, gender
SELECT COUNT(customer_id) AS 'Total Customers', city AS "City", gender AS "Gender"
From mitron_bnk.dim_cus
GROUP BY city,gender;

-- Customer distribution by marital status
SELECT COUNT(customer_id) AS 'Total Customers',marital_status AS 'Marital Status'
From mitron_bnk.dim_cus
GROUP BY marital_status;

-- Total avg income by gender in millions
SELECT gender, 
       ROUND(SUM(avg_income) / 1000000, 2) AS "Total Avg. Income (Millions)"
FROM dim_cus
GROUP BY gender;

-- Toatl avg income by martial status
SELECT marital_status AS "Marital Status", 
		ROUND(SUM(avg_income)/1000000,2) AS "Total Avg. Income (Millions)"
FROM dim_cus
GROUP BY marital_status;

-- Total spends by category
SELECT category AS "Category", 
       ROUND((SUM(S.spend) / SUM(C.avg_income)) * 100, 2) AS "Income Utilisation (%)",
       ROUND(SUM(S.spend) / 1000000, 2) AS "Total Spends (Millions)"
FROM fact_spends S
INNER JOIN dim_cus C 
ON C.customer_id = S.customer_id
GROUP BY category;


-- Total spend and income by age group
SELECT ROUND(SUM(C.avg_income) / 1000000, 2) AS "Total Income (Millions)",
       ROUND(SUM(S.spend) / 1000000, 2) AS "Total Spend (Millions)",
       C.age_group AS "Age Group"
FROM dim_cus C
INNER JOIN fact_spends S 
ON C.customer_id = S.customer_id
GROUP BY C.age_group;

-- Total spends by payment type
SELECT payment_type,ROUND(SUM(spend)/1000000,2) AS "Total Spends"
FROM fact_spends
GROUP BY payment_type;

-- Total spend and income by city
SELECT ROUND(SUM(C.avg_income) / 1000000, 2) AS "Total Income (Millions)",
       ROUND(SUM(S.spend) / 1000000, 2) AS "Total Spend (Millions)",
       C.city AS "City"
FROM dim_cus C
INNER JOIN fact_spends S
ON C.customer_id = S.customer_id
GROUP BY C.city;

-- Total spend by month
SELECT `month` as "Months", 
		ROUND(SUM(spend)/1000000,2) AS "Total Spends"
FROM fact_spends
GROUP BY month;
 