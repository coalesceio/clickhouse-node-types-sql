@id("0e1f0a00-0000-4000-8000-000000000209")
@nodeType("SQLWork")
@orderBy("`cust_id`")
@partitionBy("toYYYYMMDD(`updated_at`)")
SELECT
    `c`.`cust_id`       AS `cust_id`,
    `c`.`updated_at`    AS `updated_at`,
    `c`.`segment`       AS `segment`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
