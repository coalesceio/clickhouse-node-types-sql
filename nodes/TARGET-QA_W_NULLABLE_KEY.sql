@id("0e1f0a00-0000-4000-8000-000000000132")
@nodeType("SQLWork")
@orderBy("`region_id`", "`cust_id`")
@primaryKey("`region_id`")
SELECT
    `c`.`cust_id`       AS `cust_id`,
    `c`.`region_id`     AS `region_id`,
    `c`.`cust_name`     AS `cust_name`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
