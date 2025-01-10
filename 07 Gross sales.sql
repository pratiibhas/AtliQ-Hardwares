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
       