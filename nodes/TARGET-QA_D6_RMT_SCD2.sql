@id("0e1f0a00-0000-4000-8000-000000000604")
@nodeType("SQLDimension")
@engine("ReplacingMergeTree")
SELECT
    generateUUIDv4()                            AS `D6_KEY`       @id("64a000") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `s`.`cust_id`                               AS `cust_id`      @id("64a001") @isBusinessKey,
    toUInt32(intDiv(toUnixTimestamp(now()), 60)) AS `minute_marker` @id("64a002") @isChangeTracking,
    1                                           AS `SYSTEM_VERSION`      @id("64a090") @isSystemVersion,
    'Y'                                         AS `SYSTEM_CURRENT_FLAG` @id("64a091") @isSystemCurrentFlag,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE` @id("64a092") @isSystemEndDate,
    now64(6)                                    AS `SYSTEM_CREATE_DATE`  @id("64a093") @isSystemCreateDate,
    now64(6)                                    AS `SYSTEM_UPDATE_DATE`  @id("64a094") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
WHERE `s`.`cust_id` IN (1, 2)
