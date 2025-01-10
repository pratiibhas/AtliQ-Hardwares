
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


