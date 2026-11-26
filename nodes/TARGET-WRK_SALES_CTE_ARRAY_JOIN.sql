@id("245033b8-d045-4b85-8a5a-adc4498bab89")
@nodeType("SQLWork")
WITH sales_cte AS
(
    SELECT
        'Laptop' AS product,
        [100, 200, 300] AS quarterly_sales
    UNION ALL
    SELECT
        'Mobile' AS product,
        [150, 250, 350] AS quarterly_sales
)
SELECT
    product,
    sales
FROM sales_cte
ARRAY JOIN quarterly_sales AS sales;