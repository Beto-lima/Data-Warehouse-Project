INSERT INTO dw.dim_category (id_category, name) VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Home & Kitchen'),
(4, 'Books'),
(5, 'Sports & Outdoors');

INSERT INTO dw.dim_product (id_product, name, id_category) VALUES

-- Electronics
(101, 'Smartphone X Pro', 1),
(102, 'Wireless Earbuds', 1),
(103, '4K Smart TV 55"', 1),
(104, 'Laptop Ultra', 1),
(105, 'Smart Watch Series 5', 1),

-- Clothing
(201, 'Men''s Casual T-Shirt', 2),
(202, 'Women''s Winter Jacket', 2),
(203, 'Running Shoes', 2),
(204, 'Formal Dress Shirt', 2),
(205, 'Yoga Pants', 2),

-- Home & Kitchen
(301, 'Non-Stick Cookware Set', 3),
(302, 'Air Fryer', 3),
(303, 'Memory Foam Pillow', 3),
(304, 'Robot Vacuum Cleaner', 3),
(305, 'Coffee Maker', 3),

-- Books
(401, 'The Silent Observer (Novel)', 4),
(402, 'Data Science for Beginners', 4),
(403, 'World History Encyclopedia', 4),
(404, 'Cookbook: Healthy Recipes', 4),
(405, 'Children''s Adventure Book', 4),

-- Sports & Outdoors
(501, 'Yoga Mat', 5),
(502, 'Camping Tent 4-Person', 5),
(503, 'Dumbbell Set 20kg', 5),
(504, 'Running GPS Watch', 5),
(505, 'Bicycle Helmet', 5);

INSERT INTO dw.dim_channel (id_channel, name, region) VALUES
-- Online channels
(1, 'Company Website', 'Global'),
(2, 'Mobile App', 'Global'),
(3, 'Amazon Marketplace', 'North America'),
(4, 'Amazon Marketplace', 'Europe'),
(5, 'eBay Store', 'Global'),

-- Physical stores
(11, 'Flagship Store NYC', 'North America'),
(12, 'Downtown Chicago', 'North America'),
(13, 'London Oxford Street', 'Europe'),
(14, 'Paris Champs-Élysées', 'Europe'),
(15, 'Tokyo Shibuya', 'Asia'),

-- Wholesale partners
(21, 'Costco Wholesale', 'North America'),
(22, 'Metro AG', 'Europe'),
(23, 'Walmart Distribution', 'North America'),
(24, 'Carrefour Partners', 'Europe'),
(25, 'AEON Group', 'Asia'),

-- Other channels
(31, 'TV Shopping Network', 'North America'),
(32, 'Pop-up Stores', 'Various'),
(33, 'Telephone Sales', 'North America'),
(34, 'Catalog Sales', 'Europe'),
(35, 'Social Media Marketplace', 'Global');

CREATE OR REPLACE PROCEDURE dw.sp_load_dim_data()
LANGUAGE plpgsql
AS $$
DECLARE 
    v_current_date DATE := '2020-01-01';
    v_final_date DATE := '2030-12-31';
BEGIN
    WHILE v_current_date <= v_final_date LOOP
        INSERT INTO dw.dim_date (day, month,year, full_date)
        VALUES (
            EXTRACT(DAY FROM v_current_date),
            EXTRACT(MONTH FROM v_current_date),
            EXTRACT(YEAR FROM v_current_date),
            v_current_date
        );

        v_current_date := v_current_date + INTERVAL '1 day';
    END LOOP;
END;
$$;

CALL dw.sp_load_dim_data();

INSERT INTO dw.dim_customers (id_customer, name, type, city, state, country) VALUES
-- Individual customers
(1001, 'John Smith', 'Individual', 'New York', 'NY', 'United States'),
(1002, 'Maria Garcia', 'Individual', 'Los Angeles', 'CA', 'United States'),
(1003, 'James Wilson', 'Individual', 'London', NULL, 'United Kingdom'),
(1004, 'Sophie Martin', 'Individual', 'Paris', NULL, 'France'),
(1005, 'Luca Rossi', 'Individual', 'Milan', NULL, 'Italy'),

-- Business customers
(2001, 'Tech Solutions Inc.', 'Business', 'San Francisco', 'CA', 'United States'),
(2002, 'Global Consulting Ltd.', 'Business', 'Chicago', 'IL', 'United States'),
(2003, 'European Imports GmbH', 'Business', 'Berlin', NULL, 'Germany'),
(2004, 'Asia Trading Co.', 'Business', 'Singapore', NULL, 'Singapore'),
(2005, 'Ocean Shipping LLC', 'Business', 'Miami', 'FL', 'United States'),

-- Other customers
(3001, 'University of Toronto', 'Educational', 'Toronto', 'ON', 'Canada'),
(3002, 'City Hospital', 'Healthcare', 'Boston', 'MA', 'United States'),
(3003, 'Green Energy Foundation', 'Non-Profit', 'Sydney', 'NSW', 'Australia'),
(3004, 'State Government Dept.', 'Government', 'Washington', 'DC', 'United States'),
(3005, 'Sunrise Senior Living', 'Healthcare', 'Vancouver', 'BC', 'Canada');

CREATE OR REPLACE PROCEDURE dw.sp_load_fact_sales ()
LANGUAGE plpgsql
AS $$
DECLARE
    i INT := 1;
    v_sk_product INT;
    v_sk_channel INT;
    v_sk_date INT;
    v_sk_customer INT;
BEGIN
    WHILE i <= 1000 LOOP
    v_sk_product := (SELECT sk_product FROM dw.dim_product ORDER BY RANDOM() LIMIT 1);
    v_sk_channel := (SELECT sk_channel FROM dw.dim_channel ORDER BY RANDOM() LIMIT 1);
    v_sk_date := (SELECT sk_date FROM dw.dim_date ORDER BY RANDOM() LIMIT 1);
    v_sk_customer := (SELECT sk_customer FROM dw.dim_customers ORDER BY RANDOM() LIMIT 1);

        BEGIN
            INSERT INTO dw.fact_sales (sk_product, sk_channel, sk_date, sk_customer, amount, quantity)
            VALUES (
               v_sk_product,
               v_sk_channel,
               v_sk_date,
               v_sk_customer,
               FLOOR(1+ RANDOM() * 125),
               ROUND(CAST(RANDOM() * 1000 AS numeric), 2)
            );
            i := i + 1;
        EXCEPTION WHEN unique_violation THEN
            CONTINUE;
        END;
    END LOOP;
END;
$$; 

-- Run the fact sales table
CALL dw.sp_load_fact_sales();