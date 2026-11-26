@id("2e6423bb-b59b-5916-8e8d-92211d89fb4e")
@nodeType("SQLDimension")
@engine("ReplacingMergeTree")
@description("Customer dimension")
@mergeStrategy("changeTracking")
SELECT
    generateUUIDv4()                                     AS `customer_key`        @id("b10000") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `c_custkey`                                          AS `c_custkey`           @id("b10001") @isBusinessKey @notNull,
    `c_name`                                             AS `c_name`              @id("b10002"),
    `c_address`                                          AS `c_address`           @id("b10003") @isChangeTracking,
    1                                                    AS `SYSTEM_VERSION`      @id("b10005") @isSystemVersion,
    'Y'                                                  AS `SYSTEM_CURRENT_FLAG` @id("b10006") @isSystemCurrentFlag,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6))  AS `SYSTEM_END_DATE`     @id("b10007") @isSystemEndDate,
    now64(6)                                             AS `SYSTEM_CREATE_DATE`  @id("b10008") @isSystemCreateDate,
    now64(6)                                             AS `SYSTEM_UPDATE_DATE`  @id("b10009") @isSystemUpdateDate @notNull
FROM {{ ref('SRC', 'rx_customer') }} `customer`
