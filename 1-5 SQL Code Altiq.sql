use gdb023;
/* 1.Provide the list of markets in which customer "Atliq Exclusive" operates its
business in the APAC region*/
select * from dim_customer;
SELECT 
	market 
FROM
      dim_customer 
WHERE  
      region ='APAC'
GROUP BY  
        market;


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

 							
/*3. Provide a report with all the unique product counts for each segment and
sort them in descending order of product counts. The final output contains
2 fields,
segment
product_count*/
SELECT 
    segment,
    COUNT(product) AS product_count
FROM 
    dim_product
GROUP BY 
    segment
ORDER BY 
    product_count DESC;

/*Follow-up:4. Which segment had the most increase in unique products in
2021 vs 2020? The final output contains these fields,
segment
product_count_2020
product_count_2021
difference*/
WITH total_unique_2020 AS (
    SELECT 
        dp.segment, 
        COUNT(DISTINCT dp.product_code) AS product_count_2020
    FROM 
        dim_product AS dp
    JOIN 
        fact_sales_monthly AS fs ON dp.product_code = fs.product_code
    WHERE 
        fs.fiscal_year = 2020
    GROUP BY 
        dp.segment
),
total_unique_2021 AS (
    SELECT 
        dp.segment, 
        COUNT(DISTINCT dp.product_code) AS product_count_2021
    FROM 
        dim_product AS dp
    JOIN 
        fact_sales_monthly AS fs ON dp.product_code = fs.product_code
    WHERE 
        fs.fiscal_year = 2021
    GROUP BY 
        dp.segment
)
SELECT  
    t0.segment, 
    t1.product_count_2021, 
    t0.product_count_2020, 
    (t1.product_count_2021 - t0.product_count_2020) AS difference
FROM 
    total_unique_2021 AS t1
JOIN 
    total_unique_2020 AS t0 ON t0.segment = t1.segment
GROUP BY 
    t0.segment;
                                

/*5. Get the products that have the highest and lowest manufacturing costs.
The final output should contain these fields,
product_code
product
manufacturing_cost*/                                        
                  
WITH max_cost AS (
    SELECT MAX(fc.manufacturing_cost) AS highest_cost
    FROM fact_manufacturing_cost fc
), 
min_cost  AS (SELECT MIN(fc.manufacturing_cost) AS lowest_cost
    FROM fact_manufacturing_cost fc)
SELECT 
    fc.product_code, 
    dpr.product, 
    fc.manufacturing_cost,
	'Highest' AS cost_type
FROM 
    fact_manufacturing_cost fc
JOIN 
    dim_product dpr ON dpr.product_code = fc.product_code
JOIN 
    max_cost mc ON fc.manufacturing_cost = mc.highest_cost
    
UNION ALL
SELECT 
    fc.product_code, 
    dpr.product, 
    fc.manufacturing_cost,
    'Lowest' AS cost_type
FROM 
    fact_manufacturing_cost fc
JOIN 
    dim_product dpr ON dpr.product_code = fc.product_code
JOIN 
    min_cost mic ON fc.manufacturing_cost = mic.lowest_cost;     
    
    
