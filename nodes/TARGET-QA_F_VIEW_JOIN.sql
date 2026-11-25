@id("0e1f0a00-0000-4000-8000-000000000177")
@nodeType("SQLFact")
@materializationType("view")
SELECT
    `c`.`cust_id`           AS `cust_id`            @id("f77001") @isBusinessKey,
    `r`.`region_name`       AS `region_name`        @id("f77002"),
    now64(6)                AS `SYSTEM_CREATE_DATE` @id("f77003") @isSystemCreateDate
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
LEFT JOIN {{ ref('TARGET', 'QA_W_SRC_REGION') }} `r` ON `r`.`region_id` = `c`.`region_id`
