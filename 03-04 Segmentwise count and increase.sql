
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