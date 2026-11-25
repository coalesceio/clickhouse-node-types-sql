@id("0e1f0a00-0000-4000-8000-000000000122")
@nodeType("SQLWork")
@materializationType("view")
@final
@joinUseNulls
@querySettings("max_threads = 3")
@description("QA Work view with final and joinUseNulls")
@orderBy("`cust_id`")
@writeMode("append")
@preSQL("SELECT 1")
@tests("SELECT 1 FROM {{ this }} WHERE `cust_id` = 0")
SELECT
    `c`.`cust_id`       AS `cust_id`        @description("cust id col") @not_null,
    `r`.`region_name`   AS `region_name`    @description("region name col"),
    CAST(`r`.`region_name` AS Nullable(String)) AS `region_name_null`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
LEFT JOIN {{ ref('TARGET', 'QA_W_SRC_REGION') }} `r` ON `r`.`region_id` = `c`.`region_id`
