/*9. Which channel helped to bring more gross sales in the fiscal year 2021
and the percentage of contribution? The final output contains these fields,
channel
gross_sales_mln
percentage*/ -- dim customer and fact_gross_price


WITH Channel_sales AS (
    SELECT 
        dc.channel AS channel,
        SUM(gp.gross_price * fsm.sold_quantity) AS gross_sales_mln
    FROM 
        dim_customer dc
    JOIN 
        fact_sales_monthly fsm ON dc.customer_code = fsm.customer_code        
    JOIN
        fact_gross_price gp ON gp.product_code = fsm.product_code
    WHERE  
        gp.fiscal_year = 2021
    GROUP BY 
        dc.channel
    ORDER BY 
        gross_sales_mln DESC
),
Total_Sales AS (
    SELECT SUM(gross_price * sold_quantity) AS total_sum 
    FROM fact_sales_monthly fsm
    JOIN fact_gross_price gp ON fsm.product_code = gp.product_code
    WHERE gp.fiscal_year = 2021
)
SELECT 
    cs.*, 
    CONCAT(ROUND(cs.gross_sales_mln * 100 / ts.total_sum, 2), ' %') AS percentage
FROM 
    Channel_sales cs, Total_Sales ts;