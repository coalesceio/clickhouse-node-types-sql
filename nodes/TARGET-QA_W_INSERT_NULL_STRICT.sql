@id("0e1f0a00-0000-4000-8000-000000000146")
@nodeType("SQLWork")
@querySettings("insert_null_as_default = 0")
SELECT
    `c`.`cust_id`       AS `cust_id`,
    `c`.`cust_name`     AS `cust_name`  @notNull
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
