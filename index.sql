-- Index in Sales Table

CREATE INDEX idx_fact_sales_product ON dw.fact_sales (sk_product); 
CREATE INDEX idx_fact_sales_channel ON dw.fact_sales (sk_channel); 
CREATE INDEX idx_fact_sales_date ON dw.fact_sales (sk_date); 
CREATE INDEX idx_fact_sales_customer ON dw.fact_sales (sk_customer); 

-- Index in Product and Channel dimensions
CREATE INDEX idx_dim_product ON dw.dim_product(sk_product);
CREATE INDEX idx_dim_channel ON dw.dim_channel(sk_channel);

-- INDEX in Customers and Data dimensions 
CREATE INDEX idx_dim_customers ON dw.dim_customers(sk_customer);
CREATE INDEX idx_dim_data ON dw.dim_date(sk_date);

-- INDEX in dimesion product (category)
CREATE INDEX idx_dim_product_category ON dw.dim_product(category);