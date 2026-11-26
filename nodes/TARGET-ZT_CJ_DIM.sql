@id("7f3c2a10-0004-4c1e-9a11-0000000000c6")
@nodeType("SQLDimension")
@mergeStrategy("changeTracking")
SELECT
    generateUUIDv4()                                     AS "ZT_CJ_DIM_KEY"       @id("cj0f01") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `a`.`a_id`                                         AS `a_id`               @id("cj0f02") @isBusinessKey @notNull,
    `a`.`a_name`                                       AS `a_name`             @id("cj0f03") @isChangeTracking,
    `c`.`cfg_env`                                      AS `cfg_env`            @id("cj0f04") @isChangeTracking,
    1                                                    AS "SYSTEM_VERSION"      @id("cj0f05") @isSystemVersion,
    'Y'                                                  AS "SYSTEM_CURRENT_FLAG" @id("cj0f06") @isSystemCurrentFlag,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6))  AS "SYSTEM_END_DATE"     @id("cj0f07") @isSystemEndDate,
    now64(6)                                             AS "SYSTEM_CREATE_DATE"  @id("cj0f08") @isSystemCreateDate,
    now64(6)                                             AS "SYSTEM_UPDATE_DATE"  @id("cj0f09") @isSystemUpdateDate
FROM {{ ref('TARGET', 'ZT_CJ_A') }} `a`
CROSS JOIN {{ ref('TARGET', 'ZT_CJ_CFG') }} `c`
