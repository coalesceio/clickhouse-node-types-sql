@id("0e1f0a00-0000-4000-8000-000000000160")
@nodeType("SQLWork")
@materializationType("view")
@joinUseNulls
@description("B1 demo: @joinUseNulls view, every column CAST to Nullable")
SELECT
    CAST(`c`.`cust_id` AS Nullable(UInt32))         AS `cust_id`,
    CAST(`r`.`region_name` AS Nullable(String))     AS `region_name`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
LEFT JOIN {{ ref('TARGET', 'QA_W_SRC_REGION') }} `r` ON `r`.`region_id` = `c`.`region_id`
