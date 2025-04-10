-- Create the data warehouse schema owned by dwadmin user
CREATE SCHEMA dw AUTHORIZATION dwadmin;

CREATE TABLE dw.dim_category (
    sk_category SERIAL PRIMARY KEY,
    id_category INT,
    name VARCHAR(255) 
);

CREATE TABLE dw.dim_product (
    sk_product SERIAL PRIMARY KEY,
    id_product INT,
    name VARCHAR(255),
    id_category INT,
    CONSTRAINT fk_category FOREIGN KEY (id_category) REFERENCES dw.dim_category (sk_category)
);

CREATE TABLE dw.dim_channel (
    sk_channel SERIAL PRIMARY KEY,
    id_channel INT,
    name VARCHAR(255),
    region VARCHAR(255)
);

CREATE TABLE dw.dim_date (
    sk_date SERIAL PRIMARY KEY,
    day INT,
    month INT,
    year INT,
    full_date DATE
);

CREATE TABLE dw.dim_customers (
    sk_customer SERIAL PRIMARY KEY,
    id_customer INT,
    name VARCHAR(255),
    type VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(50),
    country VARCHAR(255)
);

CREATE TABLE dw.fact_sales(
    sk_product INT NOT NULL,
    sk_channel INT NOT NULL,
    sk_date INT NOT NULL,
    sk_customer INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (sk_product, sk_channel, sk_date, sk_customer),
    FOREIGN KEY (sk_product) REFERENCES dw.dim_product (sk_product),
    FOREIGN KEY (sk_channel) REFERENCES dw.dim_channel (sk_channel),
    FOREIGN KEY (sk_date) REFERENCES dw.dim_date (sk_date),
    FOREIGN KEY (sk_customer) REFERENCES dw.dim_customers (sk_customer)
);

