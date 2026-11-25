@id("0e1f0a00-0000-4000-8000-000000000176")
@nodeType("SQLDimension")
@materializationType("view")
@joinUseNulls
SELECT
    generateUUIDv4()        AS `QA_D_VIEW_JUN_KEY`  @id("d76001") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `c`.`cust_id`           AS `cust_id`            @id("d76002") @isBusinessKey,
    `r`.`region_name`       AS `region_name`        @id("d76003"),
    now64(6)                AS `SYSTEM_CREATE_DATE` @id("d76004") @isSystemCreateDate,
    now64(6)                AS `SYSTEM_UPDATE_DATE` @id("d76005") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
LEFT JOIN {{ ref('TARGET', 'QA_W_SRC_REGION') }} `r` ON `r`.`region_id` = `c`.`region_id`
