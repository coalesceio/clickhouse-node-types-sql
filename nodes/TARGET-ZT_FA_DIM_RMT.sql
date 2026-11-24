@id("9d17268a-a95d-4693-adc8-b13172fd61ad")
@nodeType("SQLDimension")
@engine("ReplacingMergeTree")
@mergeStrategy("changeTracking")
SELECT
    generateUUIDv4()                                     AS "ZT_FA_DIM_RMT_KEY"   @id("e609f3") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `c_custkey`                                          AS `c_custkey`           @id("a47ff2") @isBusinessKey @notNull,
    `c_name`                                             AS `c_name`              @id("e84844") @isChangeTracking,
    `c_address`                                          AS `c_address`           @id("dff7c9") @isChangeTracking,
    1                                                    AS "SYSTEM_VERSION"      @id("d5fce3") @isSystemVersion,
    'Y'                                                  AS "SYSTEM_CURRENT_FLAG" @id("82a856") @isSystemCurrentFlag,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6))  AS "SYSTEM_END_DATE"     @id("5db9b5") @isSystemEndDate,
    now64(6)                                             AS "SYSTEM_CREATE_DATE"  @id("737400") @isSystemCreateDate,
    now64(6)                                             AS "SYSTEM_UPDATE_DATE"  @id("adeda5") @isSystemUpdateDate
FROM {{ ref('SRC', 'rx_customer') }} `rx_customer`
