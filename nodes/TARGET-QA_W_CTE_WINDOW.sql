@id("0e1f0a00-0000-4000-8000-000000000116")
@nodeType("SQLWork")
WITH `ranked` AS (
    SELECT
        `cust_id`, `segment`, `balance`, `updated_at`,
        row_number() OVER (PARTITION BY `segment` ORDER BY `balance` DESC)  AS `rn`,
        sum(`balance`) OVER (PARTITION BY `segment`)                        AS `seg_total`,
        lagInFrame(`balance`) OVER (ORDER BY `updated_at` ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS `prev_balance`
    FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }}
),
`agg` AS (
    SELECT `segment`, count() AS `seg_cnt` FROM `ranked` GROUP BY `segment`
)
SELECT
    `cust_id`       AS `cust_id`,
    `segment`       AS `segment`,
    `balance`       AS `balance`,
    `rn`            AS `rn`,
    `seg_total`     AS `seg_total`,
    `prev_balance`  AS `prev_balance`,
    `seg_cnt`       AS `seg_cnt`
FROM `ranked`
INNER JOIN `agg` USING (`segment`)
