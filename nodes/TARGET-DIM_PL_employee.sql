@id("e9a5d7b4-6f8c-4b0d-8e4a-3c1f5b9d7a04")
@nodeType("SQLDimension")
@description("Pipeline - employee dimension, change tracking SCD Type 2 with zero key")
@materializationType("table")
@orderBy("id", "SYSTEM_VERSION")
@primaryKey("id")
@partitionBy("toYYYYMM(SYSTEM_CREATE_DATE)")
@settings("index_granularity = 8192")
@writeMode("append")
@mergeStrategy("changeTracking")
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'", "1900-01-01 00:00:00", true)
@disableTests(false)
@tests("SELECT id FROM WORKSPACE_PRANJAL.DIM_PL_employee WHERE SYSTEM_CURRENT_FLAG = 'Y' GROUP BY id HAVING count() > 1", true, "After")
@preSQL("SELECT count() FROM WORKSPACE_PRANJAL.WRK_PL_employee")
@postSQL("SELECT count() FROM WORKSPACE_PRANJAL.DIM_PL_employee WHERE SYSTEM_CURRENT_FLAG = 'Y'")
SELECT
    generateUUIDv4()                               AS "DIM_PL_employee_KEY" @id("2d3e4f") @description("Surrogate key") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()") @uniqueness,
    "id"                                           AS "id"                  @id("3e4f5a") @description("Employee id") @isBusinessKey @notNull @not_null,
    "name"                                         AS "name"                @id("4f5a6b") @description("Name - updated in place") @inHash("ATTR_HASH", 1),
    "department"                                   AS "department"          @id("5a6b7c") @description("Department - new version on change") @isChangeTracking @inHash("ATTR_HASH", 2),
    "salary_band"                                  AS "salary_band"         @id("6b7c8d") @description("Salary band - new version on change") @isChangeTracking @inHash("ATTR_HASH", 3) @accepted_values("'LOW', 'MID', 'HIGH'", "'UNKNOWN'"),
    "nation_name"                                  AS "nation_name"         @id("7c8d9e") @description("Nation - updated in place") @zeroKey("'NO NATION'"),
    "created_at"                                   AS "created_at"          @id("8d9e0f") @description("Hire time"),
    {{ get_hash("ATTR_HASH", "SHA256") }}          AS "ATTR_HASH"           @id("9e0f1a") @description("SHA256 of name, department, salary band"),
    toUInt32(1)                                    AS "SYSTEM_VERSION"      @id("0f1a2b") @isSystemVersion @notNull @min_value("1"),
    'Y'                                            AS "SYSTEM_CURRENT_FLAG" @id("1a2b4c") @isSystemCurrentFlag @accepted_values("'Y'", "'N'"),
    now64(6)                                       AS "SYSTEM_CREATE_DATE"  @id("2b3c5d") @isSystemCreateDate @relative_time("<=", "SYSTEM_END_DATE"),
    now64(6)                                       AS "SYSTEM_UPDATE_DATE"  @id("3c4d6e") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE" @id("4d5e7f") @isSystemEndDate
FROM {{ ref('TARGET', 'WRK_PL_employee') }} "WRK_PL_employee"
