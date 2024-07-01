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
    
/*6. Generate a report which contains the top 5 customers who received an
average high pre_invoice_discount_pct for the fiscal year 2021 and in the
Indian market. The final output contains these fields,
customer_code
customer
average_discount_percentage*/    
 
 SELECT  
        dc.customer_code, 
        AVG(invd.pre_invoice_discount_pct) as Average_discount_percentage
 FROM 
	  dim_customer dc
JOIN 
	  fact_pre_invoice_deductions invd
ON
      dc.customer_code= invd.customer_code      
 WHERE
     dc.market='India' and invd.fiscal_year= 2021
 GROUP BY 
        invd.customer_code
 ORDER BY 
       Average_discount_percentage DESC
LIMIT 5 ;

/*7.Get the complete report of the Gross sales amount for the customer “Atliq
Exclusive” for each month. This analysis helps to get an idea of low and
high-performing months and take strategic decisions.
The final report contains these columns:
Month
Year
Gross sales Amount = Sum of all sales (Total units sold x Sales price per unit)
*/
                              
SELECT                                       
    CONCAT(MONTHNAME(fas.date), ' (', YEAR(fas.date), ')') AS 'Mon',
    fas.date,
    fas.fiscal_year,
    ROUND(SUM(gp.gross_price* fas.sold_quantity ),2) AS Gross_sales_amount
FROM
    fact_sales_monthly fas

JOIN 
    dim_customer dc
ON
    dc.customer_code = fas.customer_code
JOIN
    fact_gross_price gp 
ON 
    fas.product_code = gp.product_code
WHERE 
    dc.customer = "Atliq Exclusive"  
GROUP BY
    fas.date, fas.fiscal_year  ;
       


/*8. In which quarter of 2020, got the maximum total_sold_quantity? The final
output contains these fields sorted by the total_sold_quantity,
Quarter
total_sold_quantity*/      

SELECT 
      Quarter(date), 
      SUM(MAX(sold_quantity)) AS total_sold_quantity
from   
      fact_sales_monthly
WHERE 
      fiscal_year = 2020
GROUP BY  
	  Quarter(date)
ORDER BY 
       total_sold_quantity;

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

/*Get the Top 3 products in each division that have a high
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

    
        
