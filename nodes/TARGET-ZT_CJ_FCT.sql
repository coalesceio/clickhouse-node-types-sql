@id("7f3c2a10-0004-4c1e-9a11-0000000000c7")
@nodeType("SQLFact")
@mergeStrategy("changeTracking")
SELECT
    `a`.`a_id`                             AS `a_id`               @id("cj1001") @isBusinessKey @notNull,
    `b`.`b_code`                           AS `b_code`             @id("cj1002") @isBusinessKey @notNull,
    `a`.`a_name`                           AS `a_name`             @id("cj1003"),
    now64(6)                                 AS "SYSTEM_CREATE_DATE"  @id("cj1004") @isSystemCreateDate,
    now64(6)                                 AS "SYSTEM_UPDATE_DATE"  @id("cj1005") @isSystemUpdateDate
FROM {{ ref('TARGET', 'ZT_CJ_A') }} `a`, {{ ref('TARGET', 'ZT_CJ_B') }} `b`
