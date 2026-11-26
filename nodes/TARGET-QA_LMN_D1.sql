@id("0e1f0a00-0000-4000-8000-0000000003a2")
@nodeType("SQLDimension")
@engine("MergeTree")
@mergeStrategy("lastModified")
SELECT
    `s`.`cust_id` AS `cust_id` @id("b1a001") @isBusinessKey,
    `s`.`city`    AS `city`    @id("b1a002"),
    `s`.`lm`      AS `lm`      @id("b1a003") @lastModifiedTracking(1),
    now64(6)      AS `SYSTEM_CREATE_DATE` @id("b1a090") @isSystemCreateDate,
    now64(6)      AS `SYSTEM_UPDATE_DATE` @id("b1a091") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_LMN_SRC') }} `s`
