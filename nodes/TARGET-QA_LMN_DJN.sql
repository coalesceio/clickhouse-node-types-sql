@id("0e1f0a00-0000-4000-8000-0000000003a6")
@nodeType("SQLDimension")
@engine("MergeTree")
@mergeStrategy("lastModified")
SELECT
    `s`.`cust_id` AS `cust_id` @id("b5a001") @isBusinessKey,
    `s`.`city`    AS `city`    @id("b5a002"),
    `r`.`rgt_ver` AS `rgt_ver` @id("b5a003") @lastModifiedTracking(2),
    1                                                   AS `SYSTEM_VERSION`      @id("b5a090") @isSystemVersion,
    'Y'                                                 AS `SYSTEM_CURRENT_FLAG` @id("b5a091") @isSystemCurrentFlag,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE`     @id("b5a092") @isSystemEndDate,
    now64(6)                                            AS `SYSTEM_CREATE_DATE`  @id("b5a093") @isSystemCreateDate,
    now64(6)                                            AS `SYSTEM_UPDATE_DATE`  @id("b5a094") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_LMN_SRC') }} `s`
LEFT JOIN {{ ref('TARGET', 'QA_LMN_RGT') }} `r` ON `r`.`cust_id` = `s`.`cust_id`
