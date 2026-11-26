@id("0e1f0a00-0000-4000-8000-000000000704")
@nodeType("SQLWork")
@description("P7 staging: order lines, exact duplicates removed")
WITH `o` AS (
    SELECT `order_id`, `line_no`, `cust_id`, `qty`, `amount`, `order_ts`,
           row_number() OVER (PARTITION BY `order_id`, `line_no` ORDER BY `order_ts` DESC) AS `rn`
    FROM {{ ref('TARGET', 'QA_P7_SRC_ORDERS') }}
)
SELECT
    `order_id`    AS `order_id`,
    `line_no`     AS `line_no`,
    `cust_id`     AS `cust_id`,
    `qty`         AS `qty`        @min_value("1"),
    `amount`      AS `amount`     @min_value("0"),
    `order_ts`    AS `order_ts`
FROM `o`
WHERE `rn` = 1
