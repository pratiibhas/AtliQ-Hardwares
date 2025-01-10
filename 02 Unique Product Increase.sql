/*2.What is the percentage of unique product increase in 2021 vs. 2020? The
final output contains these fields,
unique_products_2020
unique_products_2021
percentage_chg*/

WITH total_unique_2020 AS (
    SELECT COUNT(DISTINCT dp.product_code) AS unique_products_2020
    FROM dim_product AS dp
    JOIN fact_sales_monthly AS fs
        ON dp.product_code = fs.product_code
    WHERE fs.fiscal_year = 2020
),
total_unique_2021 AS (
    SELECT COUNT(DISTINCT dp.product_code) AS unique_products_2021
    FROM dim_product AS dp
    JOIN fact_sales_monthly AS fs
        ON dp.product_code = fs.product_code
    WHERE fs.fiscal_year = 2021
)
SELECT 
    unique_products_2021, 
    unique_products_2020,
    ROUND(((unique_products_2021 - unique_products_2020) / unique_products_2020) * 100, 2) AS percentage_chng
FROM 
    total_unique_2020,
    total_unique_2021;

 							
