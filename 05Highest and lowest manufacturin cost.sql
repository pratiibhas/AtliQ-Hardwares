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