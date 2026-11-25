@id("0e1f0a00-0000-4000-8000-000000000124")
@nodeType("SQLWork")
SELECT
    `v`.`cust_id`           AS `cust_id`,
    `v`.`region_name`       AS `region_name`,
    `v`.`region_name_null`  AS `region_name_null`
FROM {{ ref('TARGET', 'QA_W_VIEW_FULL') }} `v`
