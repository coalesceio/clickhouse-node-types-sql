@id("0e1f0a00-0000-4000-8000-0000000003a3")
@nodeType("SQLDimension")
@engine("MergeTree")
@mergeStrategy("lastModified")
SELECT
    `s`.`cust_id` AS `cust_id` @id("b2a001") @isBusinessKey,
    `s`.`city`    AS `city`    @id("b2a002"),
    `s`.`lm`      AS `lm`      @id("b2a003") @lastModifiedTracking(2),
    1                                                   AS `SYSTEM_VERSION`      @id("b2a090") @isSystemVersion,
    'Y'                                                 AS `SYSTEM_CURRENT_FLAG` @id("b2a091") @isSystemCurrentFlag,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE`     @id("b2a092") @isSystemEndDate,
    now64(6)                                            AS `SYSTEM_CREATE_DATE`  @id("b2a093") @isSystemCreateDate,
    now64(6)                                            AS `SYSTEM_UPDATE_DATE`  @id("b2a094") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_LMN_SRC') }} `s`
