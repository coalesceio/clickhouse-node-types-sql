@id("15c50591-443a-4088-bf3b-67cb8d967ea8")
@nodeType("SQLDimension")
@description("Employee dimension - last modified SCD Type 1")
@engine("ReplacingMergeTree(SYSTEM_UPDATE_DATE)")
@orderBy("id")
@mergeStrategy("lastModified")
SELECT
    toUInt64(0)                                    AS "DIM_employee_LM_SCD1_KEY" @id("c06367") @isSurrogateKey @notNull,
    "id"                                           AS "id"                       @id("0e3293") @isBusinessKey @notNull,
    "name"                                         AS "name"                     @id("f6e9a0"),
    "department"                                   AS "department"               @id("967497"),
    "salary"                                       AS "salary"                   @id("0a48ae"),
    "created_at"                                   AS "created_at"               @id("3421ad") @lastModifiedTracking(1),
    toUInt32(1)                                    AS "SYSTEM_VERSION"           @id("e8b529") @isSystemVersion @notNull,
    'Y'                                            AS "SYSTEM_CURRENT_FLAG"      @id("58727a") @isSystemCurrentFlag,
    now64(6)                                       AS "SYSTEM_CREATE_DATE"       @id("e033cf") @isSystemCreateDate,
    now64(6)                                       AS "SYSTEM_UPDATE_DATE"       @id("0f67e5") @isSystemUpdateDate @notNull,
    toDateTime64('2299-12-31 00:00:00', 6)         AS "SYSTEM_END_DATE"          @id("8a8b02") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"
