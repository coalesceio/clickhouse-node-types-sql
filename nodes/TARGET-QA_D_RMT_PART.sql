@id("0e1f0a00-0000-4000-8000-000000000390")
@nodeType("SQLDimension")
@engine("ReplacingMergeTree")
@partitionBy("`bucket`")
@optimize
@description("RMT with partitionBy; bucket changes every minute so rows move partition")
SELECT
    `s`.`cust_id`                                       AS `cust_id`  @id("90a001") @isBusinessKey,
    `s`.`city`                                          AS `city`     @id("90a002"),
    toUInt8(intDiv(toUnixTimestamp(now()), 60) % 3)     AS `bucket`   @id("90a003"),
    now64(6)                                            AS `SYSTEM_CREATE_DATE` @id("90a090") @isSystemCreateDate,
    now64(6)                                            AS `SYSTEM_UPDATE_DATE` @id("90a091") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
