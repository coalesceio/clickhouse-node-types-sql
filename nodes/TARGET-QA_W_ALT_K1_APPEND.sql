@id("0e1f0a00-0000-4000-8000-000000000208")
@nodeType("SQLWork")
@orderBy("`cust_id`", "`segment`", "`updated_at`")
@primaryKey("`cust_id`")
SELECT
    `c`.`cust_id`       AS `cust_id`,
    `c`.`segment`       AS `segment`,
    `c`.`balance`       AS `balance`,
    `c`.`updated_at`    AS `updated_at`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
