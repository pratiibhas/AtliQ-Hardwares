    
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