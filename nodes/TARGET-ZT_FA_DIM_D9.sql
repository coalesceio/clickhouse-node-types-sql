@id("c1dd2611-6df3-4c67-9bdd-a1fb3bdb2e84")
@nodeType("SQLDimension")
@engine("MergeTree")
@mergeStrategy("changeTracking")
@orderBy("`c_custkey`", "`SYSTEM_VERSION`")
SELECT
    generateUUIDv4()                                         AS "ZT_FA_DIM_D9_KEY"    @id("155396") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `c_custkey`                                              AS `c_custkey`           @id("ebef3e") @isBusinessKey @notNull,
    `c_name`                                                 AS `c_name`              @id("bc0b56") @isChangeTracking,
    `c_address`                                              AS `c_address`           @id("e933d4") @isChangeTracking,
    1                                                        AS "SYSTEM_VERSION"      @id("6e8103") @isSystemVersion,
    'Y'                                                      AS "SYSTEM_CURRENT_FLAG" @id("a585c2") @isSystemCurrentFlag,
    CAST('2262-04-11 23:47:16.854775807' AS DateTime64(9))   AS "SYSTEM_END_DATE"     @id("686d70") @isSystemEndDate,
    now64(6)                                                 AS "SYSTEM_CREATE_DATE"  @id("74e4d3") @isSystemCreateDate,
    now64(6)                                                 AS "SYSTEM_UPDATE_DATE"  @id("b84f85") @isSystemUpdateDate
FROM {{ ref('SRC', 'rx_customer') }} `rx_customer`
