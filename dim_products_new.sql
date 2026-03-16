use retail;

select * from dim_products_new;

select count(product_id) from dim_products_new;

ALTER TABLE dim_products_new ADD price DECIMAL(10,2);

UPDATE dim_products_new
SET price = CASE product_name
    WHEN 'Bread' THEN 2.50
    WHEN 'Butter' THEN 3.20
    WHEN 'Milk' THEN 1.80
    WHEN 'Eggs' THEN 2.90
    WHEN 'Cheese' THEN 4.50
    WHEN 'Shampoo' THEN 6.00
    WHEN 'Conditioner' THEN 6.20
    WHEN 'Soap' THEN 1.50
    WHEN 'Toothpaste' THEN 2.80
    WHEN 'Rice' THEN 10.00
    WHEN 'Cooking Oil' THEN 8.50
    WHEN 'Biscuits' THEN 2.00
    WHEN 'Chocolate Bar' THEN 1.70
    WHEN 'Tea' THEN 5.50
    WHEN 'Coffee' THEN 7.00
END;


describe dim_products_new;