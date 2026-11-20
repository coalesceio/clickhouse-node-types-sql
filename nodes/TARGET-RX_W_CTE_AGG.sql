@id("98197182-dfc9-5340-afd9-4f328b3284e7")
@nodeType("SQLWork")
WITH `order_counts` AS (
    SELECT
        `o_custkey`                  AS `o_custkey`,
        count()                      AS `order_count`,
        sum(`o_totalprice`)          AS `total_price`
    FROM {{ ref('SRC', 'rx_orders') }}
    GROUP BY `o_custkey`
)
SELECT
    `o_custkey`                      AS `o_custkey`,
    `order_count`                    AS `order_count`,
    `total_price`                    AS `total_price`
FROM `order_counts`
