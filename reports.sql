-- Function to return sales report with customer and year as input 

CREATE OR REPLACE FUNCTION dw.report_sales_by_client(client_Name VARCHAR DEFAULT NULL, year_report INT DEFAULT NULL)
RETURNS TABLE (
    category INT,
    product_Name VARCHAR,
    year INT,
    month INT,
    total_amount DECIMAL(10, 2),
    total_quantity INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        dp.id_category AS category,
        dp.name AS product_Name,
        dd.year,
        dd.month,
        SUM(fs.amount) AS total_amount,
        CAST(SUM(fs.quantity) AS INTEGER) AS total_quantity
    FROM
        dw.fact_sales fs
    JOIN
        dw.dim_product dp ON fs.sk_product = dp.sk_product
    JOIN 
        dw.dim_date dd ON fs.sk_date = dd.sk_date
    JOIN
        dw.dim_customers dc ON fs.sk_customer = dc.sk_customer
    WHERE
        (client_Name IS NULL OR dc.name = client_Name ) AND
        (year_report IS NULL OR dd.year = year_report)
    GROUP BY
        dp.id_category, dp.name, dd.year, dd.month
    ORDER BY   
        dp.id_category, dp.name, dd.year, dd.month;
END;
$$;

-- Run the function
SELECT * FROM dw.report_sales_by_client ();
SELECT * FROM dw.report_sales_by_client ('Laptop Ultra');
SELECT * FROM dw.report_sales_by_client ('Laptop Ultra', 2021);
SELECT * FROM dw.report_sales_by_client (NULL, 2024);

-------------------------------------------------------------------------

-- Views for reports

-- Sales report by product and channel

CREATE VIEW dw.VW_sales_by_product_channel AS
SELECT  
    dp.name AS Product_Name,
    dc.name AS Channel_Name,
    SUM(fs.amount) AS Total_Sales,
    SUM(fs.quantity) AS Total_quantity
FROM
    dw.fact_sales fs
JOIN 
    dw.dim_product dp ON fs.sk_product = dp.sk_product
JOIN 
    dw.dim_channel dc ON fs.sk_channel = dc.sk_channel
GROUP BY
    dp.name, dc.name;

-- Run the report
SELECT * FROM dw.VW_sales_by_product_channel ORDER BY Product_Name

-------------------------------------------------------------------------

-- Report by sales to every client at month and year
CREATE VIEW dw.VW_sales_byclient_month_year AS
SELECT
    dc.name AS Client_Name,
    dd.year,
    dd.month,
    SUM(fs.amount) AS Total_Sales,
    SUM(fs.quantity) AS Total_quantity
FROM   
    dw.fact_sales fs
JOIN
    dw.dim_customers dc ON fs.sk_customer = dc.sk_customer
JOIN 
    dw.dim_date dd ON fs.sk_date = dd.sk_date
GROUP BY
    dc.name, dd.year, dd.month;

-- Run the report
SELECT * FROM dw.VW_sales_byclient_month_year ORDER BY Client_Name;

---------------------------------------------------------------------------

-- MATERIALIZED VIEW for sales report
CREATE MATERIALIZED VIEW dw.MV_sales_report_summary AS
SELECT
    dp.id_category AS Category,
    SUM(fs.amount) AS Total_Sales,
    SUM(fs.quantity) AS Total_quantity,
    dd.year
FROM
    dw.fact_sales fs
JOIN
    dw.dim_product dp ON fs.sk_product = dp.sk_product
JOIN
    dw.dim_date dd ON fs.sk_date = dd.sk_date
GROUP BY 
    dp.id_category, dd.year
ORDER BY
    dd.year

-- Run the report 
SELECT * FROM dw.MV_sales_report_summary ORDER BY year;

-------------------------------------------
