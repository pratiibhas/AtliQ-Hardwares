# AtliQ-Hardwares
Domain:  Consumer Goods | Function: Executive Management

Atliq Hardwares (imaginary company) is one of the leading computer hardware producers in India and well expanded in other countries too.

However, the management noticed that they do not get enough insights to make quick and smart data-informed decisions. They want to expand their data analytics team by adding several junior data analysts. Tony Sharma, their data analytics director wanted to hire someone who is good at both tech and soft skills. Hence, he decided to conduct a SQL challenge which will help him understand both the skills.

The Questions needed to be answerd are given as pdf above.

## Various SQL function used for the purpose:
Key Functionalities Demonstrated

### 1. Data Filtering and Grouping

Query: Listing markets where "Atliq Exclusive" operates in the APAC region.

Key Functions:

GROUP BY: To aggregate results by the market column.

WHERE: To filter data based on specific conditions like region = 'APAC'.

### 2. Year-on-Year Analysis

Query: Calculating the percentage change in unique products between 2020 and 2021.

Key Functions:

COUNT(DISTINCT ...): To count unique products.

WITH: For creating common table expressions (CTEs) for intermediate calculations.

ROUND: To format percentage change.

### 3. Segment Analysis

Query: Counting and sorting unique products per segment in descending order.

Key Functions:

COUNT: To count the products.

ORDER BY: To sort results.

GROUP BY: To categorize counts by segment.

### 4. Comparison Between Years

Query: Identifying the segment with the most increase in unique products from 2020 to 2021.

Key Functions:

Use of CTEs to compute data for each year.

JOIN: To merge data based on segment.

Arithmetic operations to calculate differences.

### 5. Extremes in Data

Query: Finding products with the highest and lowest manufacturing costs.

Key Functions:

MAX and MIN: To identify extremes in data.

UNION ALL: To combine results from queries for highest and lowest costs.

JOIN: To link product details with costs.

### 6. Top N Analysis

Query: Identifying the top 5 customers with the highest average pre-invoice discount percentage in the Indian market for 2021.

Key Functions:

AVG: To compute average discounts.

LIMIT: To restrict results to the top 5.

ORDER BY: To sort by average discount percentage.

### 7. Monthly Sales Analysis

Query: Reporting monthly gross sales for "Atliq Exclusive."

Key Functions:

CONCAT and MONTHNAME: To format month and year.

ROUND: To ensure precise gross sales values.

SUM: To calculate gross sales.

### 8. Quarterly Analysis

Query: Determining the quarter with the maximum total sold quantity in 2020.

Key Functions:

QUARTER: To extract quarter information.

SUM: To aggregate sold quantities.

### 9. Channel Contribution Analysis

Query: Identifying the channel with the highest gross sales and its percentage contribution in 2021.

Key Functions:

WITH: To calculate channel-wise and total sales.

Arithmetic operations for percentage calculations.

CONCAT: To format the percentage output.

### 10. Top Products per Division

Query: Finding the top 3 products by sold quantity for each division in 2021.

Key Functions:

RANK() OVER: To rank products within each division.

PARTITION BY: To group rankings by division.

WITH: To prepare intermediate ranked data.

 Resume challenge posted by Codebasics.io: https://codebasics.io/challenge/codebasics-resume-project-challenge
