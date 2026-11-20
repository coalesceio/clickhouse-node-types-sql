@id("3b970c78-cc5a-5594-aefa-1d5bed353f22")
@nodeType("SQLWork")
WITH `ordered_orders` AS (
    -- CTE 1: Rank every order for each customer by date
    SELECT
        `o_custkey`, `o_orderkey`, `o_orderdate`, `o_totalprice`, `o_orderstatus`,
        row_number() OVER (PARTITION BY `o_custkey` ORDER BY `o_orderdate` ASC, `o_orderkey` ASC) AS `order_rank`
    FROM {{ ref('SRC', 'rx_orders') }}
),
`first_orders` AS (
    -- CTE 2: Keep only the first order for each customer
    SELECT
        `o_custkey`,
        `o_orderkey`   AS `first_order_id`,
        `o_orderdate`  AS `first_purchase_date`,
        `o_totalprice` AS `first_order_value`,
        `o_orderstatus`
    FROM `ordered_orders`
    WHERE `order_rank` = 1
)
-- Final Select: add metadata and return the results
SELECT
    `o_custkey`                      AS `o_custkey`,
    `first_order_id`                 AS `first_order_id`,
    `first_purchase_date`            AS `first_purchase_date`,
    `first_order_value`              AS `first_order_value`,
    `o_orderstatus`                  AS `o_orderstatus`       @notNull,
    now()                            AS `refreshed_at`,
    'Initial Customer Purchase'      AS `record_type`
FROM `first_orders`
