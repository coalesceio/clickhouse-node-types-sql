@id("0e1f0a00-0000-4000-8000-0000000003a4")
@nodeType("SQLFact")
@engine("MergeTree")
@mergeStrategy("lastModified")
SELECT
    `s`.`cust_id` AS `cust_id` @id("b3a001") @isBusinessKey,
    `s`.`city`    AS `city`    @id("b3a002"),
    `s`.`lm`      AS `lm`      @id("b3a003") @lastModifiedTracking,
    now64(6)      AS `SYSTEM_CREATE_DATE` @id("b3a090") @isSystemCreateDate,
    now64(6)      AS `SYSTEM_UPDATE_DATE` @id("b3a091") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_LMN_SRC') }} `s`
