@id("0e1f0a00-0000-4000-8000-0000000003a5")
@nodeType("SQLDimension")
@engine("MergeTree")
@mergeStrategy("lastModified")
SELECT
    `s`.`cust_id` AS `cust_id` @id("b4a001") @isBusinessKey,
    `s`.`city`    AS `city`    @id("b4a002"),
    `r`.`rgt_lm`  AS `rgt_lm`  @id("b4a003") @lastModifiedTracking(1),
    now64(6)      AS `SYSTEM_CREATE_DATE` @id("b4a090") @isSystemCreateDate,
    now64(6)      AS `SYSTEM_UPDATE_DATE` @id("b4a091") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_LMN_SRC') }} `s`
LEFT JOIN {{ ref('TARGET', 'QA_LMN_RGT') }} `r` ON `r`.`cust_id` = `s`.`cust_id`
