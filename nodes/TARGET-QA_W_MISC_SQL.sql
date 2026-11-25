@id("0e1f0a00-0000-4000-8000-000000000128")
@nodeType("SQLWork")
SELECT
    `c`.`cust_id`                               AS `cust_id`,
    `c`.`segment`                               AS `segment`,
    `tag`                                       AS `tag`,
    multiIf(`c`.`balance` < 0, 'NEG', `c`.`balance` = 0, 'ZERO', 'POS') AS `bal_sign`,
    CASE WHEN `c`.`region_id` IS NULL THEN 'none' ELSE 'some' END      AS `region_flag`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
ARRAY JOIN ['a', 'b'] AS `tag`
QUALIFY row_number() OVER (PARTITION BY `c`.`cust_id` ORDER BY `tag`) = 1
