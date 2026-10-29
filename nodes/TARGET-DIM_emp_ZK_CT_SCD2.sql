@id("7c1f4e2a-5b8d-4c3e-9a61-2f0d8e4b7a19")
@nodeType("SQLDimension")
@description("Employee dimension - zero key test, change tracking SCD Type 2, plain MergeTree")
@orderBy("id", "SYSTEM_VERSION")
@mergeStrategy("changeTracking")
@zeroKey("00000000-0000-0000-0000-000000000000","'UNKNOWN'", "1900-01-01 00:00:00", true)
SELECT
    generateUUIDv4()                               AS "DIM_emp_ZK_CT_SCD2_KEY" @id("a1c3e5") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "id"                                           AS "id"                     @id("b2d4f6") @isBusinessKey @notNull,
    "name"                                         AS "name"                   @id("c3e5a7") @isChangeTracking,
    "department"                                   AS "department"             @id("d4f6b8") @zeroKey("'N/A'"),
    "salary"                                       AS "salary"                 @id("e5a7c9"),
    "created_at"                                   AS "created_at"             @id("f6b8d0"),
    toUInt32(1)                                    AS "SYSTEM_VERSION"         @id("a7c9e1") @isSystemVersion @notNull,
    'Y'                                            AS "SYSTEM_CURRENT_FLAG"    @id("b8d0f2") @isSystemCurrentFlag,
    now64(6)                                       AS "SYSTEM_CREATE_DATE"     @id("c9e1a3") @isSystemCreateDate,
    now64(6)                                       AS "SYSTEM_UPDATE_DATE"     @id("d0f2b4") @isSystemUpdateDate,
    toDateTime64('2299-12-31 00:00:00', 6)         AS "SYSTEM_END_DATE"        @id("e1a3c5") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"
