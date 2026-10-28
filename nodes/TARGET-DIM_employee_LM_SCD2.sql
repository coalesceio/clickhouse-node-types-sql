@id("eccfdd57-e2d2-413d-b9fd-92b95151a52f")
@nodeType("SQLDimension")
@description("Employee dimension - last modified SCD Type 2")
@engine("ReplacingMergeTree(SYSTEM_UPDATE_DATE)")
@orderBy("id", "SYSTEM_VERSION")
@mergeStrategy("lastModified")
SELECT
    toUInt64(0)                                    AS "DIM_employee_LM_SCD2_KEY" @id("f014f0") @isSurrogateKey @notNull,
    "id"                                           AS "id"                       @id("11d21f") @isBusinessKey @notNull,
    "name"                                         AS "name"                     @id("e128a7"),
    "department"                                   AS "department"               @id("e3501b"),
    "salary"                                       AS "salary"                   @id("6e970e"),
    "created_at"                                   AS "created_at"               @id("08a762") @lastModifiedTracking(2),
    toUInt32(1)                                    AS "SYSTEM_VERSION"           @id("43f558") @isSystemVersion @notNull,
    'Y'                                            AS "SYSTEM_CURRENT_FLAG"      @id("77eaff") @isSystemCurrentFlag,
    now64(6)                                       AS "SYSTEM_CREATE_DATE"       @id("61cb77") @isSystemCreateDate,
    now64(6)                                       AS "SYSTEM_UPDATE_DATE"       @id("336b5b") @isSystemUpdateDate @notNull,
    toDateTime64('2299-12-31 00:00:00', 6)         AS "SYSTEM_END_DATE"          @id("9d6518") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"
