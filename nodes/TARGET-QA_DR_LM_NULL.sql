@id("0e1f0a00-0000-4000-8000-000000000360")
@nodeType("SQLDimension")
@mergeStrategy("lastModified")
SELECT
    `s`.`cust_id` AS `cust_id` @id("f60001") @isBusinessKey,
    if(`s`.`cust_id` = 3, NULL, `s`.`updated_at`) AS `updated_at` @id("f60002") @lastModifiedTracking,
    now64(6) AS `SYSTEM_CREATE_DATE` @id("f60004") @isSystemCreateDate,
    now64(6) AS `SYSTEM_UPDATE_DATE` @id("f60005") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
