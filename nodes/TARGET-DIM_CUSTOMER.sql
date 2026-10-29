@id("2e01170d-c837-4ad4-a809-60910761d8e8")
@nodeType("SQLDimension")
@orderBy("c_custkey", "SYSTEM_VERSION")
@mergeStrategy("changeTracking")
@zeroKey(0)
SELECT
    generateUUIDv4()                     AS "DIM_CUSTOMER_KEY"   @id("b20001") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()") @not_null @uniqueness,
    "c_custkey"                          AS "c_custkey"          @id("b20002") @isBusinessKey @notNull @not_null,
    "c_name"                             AS "c_name"             @id("b20003") @isChangeTracking @notNull @not_null,
    "c_address"                          AS "c_address"          @id("b20004") @isChangeTracking,
    "c_nationkey"                        AS "c_nationkey"        @id("b20005") @isChangeTracking @notNull,
    "c_phone"                            AS "c_phone"            @id("b20006") @isChangeTracking,
    "c_acctbal"                          AS "c_acctbal"          @id("b20007") @isChangeTracking @notNull @min_max(-999.99, 9999.99),
    "c_mktsegment"                       AS "c_mktsegment"       @id("b20008") @isChangeTracking @notNull @accepted_values("'AUTOMOBILE'", "'BUILDING'", "'FURNITURE'", "'HOUSEHOLD'", "'MACHINERY'"),
    "c_comment"                          AS "c_comment"          @id("b20009"),
    1                                    AS "SYSTEM_VERSION"      @id("b2000a") @isSystemVersion,
    'Y'                                  AS "SYSTEM_CURRENT_FLAG" @id("b2000b") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS "SYSTEM_CREATE_DATE"  @id("b2000c") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS "SYSTEM_UPDATE_DATE"  @id("b2000d") @isSystemUpdateDate,
    CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS "SYSTEM_END_DATE" @id("b2000e") @isSystemEndDate
FROM {{ ref('TARGET', 'WRK_CUSTOMER') }} "WRK_CUSTOMER"
