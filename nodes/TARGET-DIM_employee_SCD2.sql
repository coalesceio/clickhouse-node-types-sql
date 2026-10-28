@id("5f042a8b-8d54-41e8-b9a9-8c47baf30e75")
@nodeType("SQLDimension")
@description("Employee dimension - change tracking SCD Type 2")
@engine("ReplacingMergeTree(SYSTEM_UPDATE_DATE)")
@orderBy("id", "SYSTEM_VERSION")
@mergeStrategy("changeTracking")
SELECT
    toUInt64(0)                                    AS "DIM_employee_SCD2_KEY" @id("99b030") @isSurrogateKey @notNull,
    "id"                                           AS "id"                    @id("6e8c42") @isBusinessKey @notNull,
    "name"                                         AS "name"                  @id("aa5c2e") @isChangeTracking,
    "department"                                   AS "department"            @id("224464"),
    "salary"                                       AS "salary"                @id("903049"),
    "created_at"                                   AS "created_at"            @id("020d95"),
    toUInt32(1)                                    AS "SYSTEM_VERSION"        @id("6c8877") @isSystemVersion @notNull,
    'Y'                                            AS "SYSTEM_CURRENT_FLAG"   @id("24b487") @isSystemCurrentFlag,
    now64(6)                                       AS "SYSTEM_CREATE_DATE"    @id("f7d52e") @isSystemCreateDate,
    now64(6)                                       AS "SYSTEM_UPDATE_DATE"    @id("9ae999") @isSystemUpdateDate @notNull,
    toDateTime64('2299-12-31 00:00:00', 6)         AS "SYSTEM_END_DATE"       @id("be3c16") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"
