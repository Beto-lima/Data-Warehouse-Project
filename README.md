# Data Warehouse Project - Sales Analytics

## Overview
This project implements a comprehensive data warehouse solution for sales analytics, featuring a star schema design with fact and dimension tables. The solution includes ETL processes, indexing strategies, and analytical reporting capabilities to provide business insights into sales performance across multiple dimensions.

## Key Features

- Star Schema Design**: Fact table with connected dimension tables for products, customers, channels, and dates
- Slowly Changing Dimensions (SCD)**: Implementation of both Type 1 (overwrite) and Type 2 (history tracking) patterns
- Automated ETL Processes**: Stored procedures for loading dimension and fact data
- Performance Optimization**: Strategic indexing for query performance
- Analytical Reporting**: Multiple reporting views and functions for business intelligence

## Schema Design

### Fact Table
- fact_sales: Tracks sales transactions with measures for amount and quantity

### Dimension Tables
- dim_product: Product information with SCD Type 2 implementation
- dim_category: Product categorization
- dim_channel: Sales channels (online, physical stores, wholesale)
- dim_date: Time dimension for temporal analysis
- dim_customers: Customer information with segmentation

## Technical Components

1. Database Schema Setup: fisic-model.sql
   - Creates all tables with proper relationships
   - Implements primary and foreign key constraints

2. Indexing Strategy: index.sql
   - Optimizes query performance with strategic indexes
   - Covers all major join and filter conditions

3. ETL Processes: manual_etl.sql
   - Sample data loading for all dimensions
   - Stored procedures for automated data loading
   - Random data generation for fact table

4. SCD Implementation: SCD.sql
   - Type 1 (overwrite) pattern for customers
   - Type 2 (history tracking) pattern for products

5. Reporting Layer: reports.sql
   - Parameterized reporting function
   - Standard reporting views
   - Materialized view for summary reporting

## Usage Examples

### Generate Sales Report by Client 

SELECT * FROM dw.report_sales_by_client('John Smith', 2023);

### View Sales by Product and Channel

SELECT * FROM dw.VW_sales_by_product_channel ORDER BY Total_Sales DESC;

### Refresh Materialized View

REFRESH MATERIALIZED VIEW dw.MV_sales_report_summary;

## Installation

1. Clone the repository
2. Execute SQL files in this order:
   - fisic-model.sql
   - manual_etl.sql
   - index.sql
   - SCD.sql
   - reports.sql

## Technologies Used

- PostgreSQL
- PL/pgSQL
- Data Warehouse Design Principles
- ETL Processes
- Business Intelligence Reporting

## Project Value

This implementation demonstrates:
- Data warehouse design skills
- Database optimization techniques
- ETL process implementation
- Business intelligence solution development
- Slowly Changing Dimension patterns
- Analytical reporting capabilities

## License
MIT License - Free to use and modify with attribution
