
/*10. Get the Top 3 products in each division that have a high
total_sold_quantity in the fiscal_year 2021? The final output contains these
fields,
division
product_code*/

WITH product_table AS (
    SELECT 
        dp.division, 
        fm.product_code, 
        dp.product, 
        SUM(fm.sold_quantity) AS total_sold_quantity 
    FROM 
        fact_sales_monthly fm
    JOIN 
        dim_product dp ON fm.product_code = dp.product_code
    WHERE 
        fm.fiscal_year = 2021
    GROUP BY 
        fm.product_code, 
        dp.division, 
        dp.product
),
rank_table AS (
    SELECT 
        *, 
        RANK() OVER (PARTITION BY division ORDER BY total_sold_quantity DESC) AS rank_order 
    FROM 
        product_table
)
SELECT 
    * 
FROM 
    rank_table
WHERE 
    rank_order < 4;

    
        
