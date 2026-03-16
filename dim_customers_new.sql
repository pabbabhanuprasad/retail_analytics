use retail;
select * from dim_customers_new;

select count(customer_id) from dim_customers_new;

describe dim_customers_new;

ALTER TABLE dim_customers_new MODIFY signup_date DATE;