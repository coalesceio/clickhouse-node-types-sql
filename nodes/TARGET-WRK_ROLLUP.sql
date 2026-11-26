@id("7b940ec2-09ab-434c-ae68-b35a2c44d8d4")
@nodeType("SQLWork")
WITH sales_cte AS
(
    SELECT 'INDIA' AS region, 'Laptop' AS product, 1000 AS sales
    UNION ALL
    SELECT 'INDIA', 'Mobile', 2000
    UNION ALL
    SELECT 'USA', 'Laptop', 3000
    UNION ALL
    SELECT 'USA', 'Mobile', 4000
)
SELECT
    region,
    SUM(sales) AS total_sales
FROM sales_cte
GROUP BY ROLLUP(region)