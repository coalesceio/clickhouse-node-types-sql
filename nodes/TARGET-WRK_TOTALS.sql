@id("3806609a-8c86-4c01-96a6-f6d9d791da3c")
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
GROUP BY region
WITH TOTALS;