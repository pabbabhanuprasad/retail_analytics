use retail;

select * from fact_sales_new;

select count(*) from fact_sales_new;


ALTER TABLE fact_sales_new ADD total_sales int;
UPDATE fact_sales_new f
JOIN dim_products_new p 
ON f.product_id = p.product_id
SET f.total_sales = f.quantity * p.price;

describe fact_sales_new;

#total revenue
SELECT SUM(total_sales) AS total_revenue FROM fact_sales_new;

#monthly sales trend
SELECT 
DATE_FORMAT(transaction_date,'%Y-%m') AS month,
SUM(total_sales) AS revenue
FROM fact_sales_new
GROUP BY month
ORDER BY month;

#Revenue by region
SELECT 
c.region,
SUM(f.total_sales) AS revenue
FROM fact_sales_new f
JOIN dim_customers_new c
ON f.customer_id = c.customer_id
GROUP BY c.region;



CREATE TABLE rfm_base_new AS
SELECT 
customer_id,
DATEDIFF(CURDATE(), MAX(transaction_date)) AS recency,
COUNT(transaction_id) AS frequency,
SUM(total_sales) AS monetary
FROM fact_sales_new
GROUP BY customer_id;

select * from rfm_base_new;



#first purchase month
SELECT customer_id, MIN(transaction_date) AS first_purchase FROM fact_sales_new GROUP BY customer_id;


#Cohort table
SELECT f.customer_id, DATE_FORMAT(MIN(f.transaction_date),'%Y-%m') AS cohort_month
FROM fact_sales_new f GROUP BY f.customer_id;


#Cohort Retention
SELECT c.customer_id,
DATE_FORMAT(c.first_purchase,'%Y-%m') AS cohort_month,
DATE_FORMAT(f.transaction_date,'%Y-%m') AS order_month
FROM fact_sales_new f
JOIN (
SELECT customer_id,
MIN(transaction_date) AS first_purchase
FROM fact_sales_new
GROUP BY customer_id
) c
ON f.customer_id = c.customer_id;



#creating Cohort_analysis table
CREATE TABLE cohort_analysis_new AS
SELECT 
    f.customer_id,
    DATE_FORMAT(c.first_purchase,'%Y-%m') AS cohort_month,
    DATE_FORMAT(f.transaction_date,'%Y-%m') AS order_month,
    PERIOD_DIFF(
        DATE_FORMAT(f.transaction_date,'%Y%m'),
        DATE_FORMAT(c.first_purchase,'%Y%m')
    ) AS cohort_index
FROM fact_sales_new f
JOIN (
    SELECT 
        customer_id,
        MIN(transaction_date) AS first_purchase
    FROM fact_sales_new
    GROUP BY customer_id
) c
ON f.customer_id = c.customer_id;

select * from cohort_analysis_new;

describe cohort_analysis;

CREATE TABLE transaction_products AS
SELECT
f.transaction_id,
p.product_name
FROM fact_sales_new f
JOIN dim_products_new p
ON f.product_id = p.product_id
ORDER BY transaction_id;

select * from transaction_products;

