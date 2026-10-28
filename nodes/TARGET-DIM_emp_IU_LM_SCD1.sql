@id("90f64f84-f23c-4f6a-9c9a-17261acf0d02")
@nodeType("SQLDimension")
@description("Employee dimension - INSERT + DELETE load, last modified SCD Type 1, plain MergeTree")
@orderBy("id")
@mergeStrategy("lastModified")
SELECT
    toUInt64(0)                                    AS "DIM_emp_IU_LM_SCD1_KEY" @id("8e432f") @isSurrogateKey @notNull,
    "id"                                           AS "id"                     @id("da786f") @isBusinessKey @notNull,
    "name"                                         AS "name"                   @id("83e6fe"),
    "department"                                   AS "department"             @id("df1c9b"),
    "salary"                                       AS "salary"                 @id("55c441"),
    "created_at"                                   AS "created_at"             @id("e4212b") @lastModifiedTracking(1),
    toUInt32(1)                                    AS "SYSTEM_VERSION"         @id("18030c") @isSystemVersion,
    'Y'                                            AS "SYSTEM_CURRENT_FLAG"    @id("ace6cb") @isSystemCurrentFlag,
    now64(6)                                       AS "SYSTEM_CREATE_DATE"     @id("913a8f") @isSystemCreateDate,
    now64(6)                                       AS "SYSTEM_UPDATE_DATE"     @id("4923aa") @isSystemUpdateDate,
    toDateTime64('2299-12-31 00:00:00', 6)         AS "SYSTEM_END_DATE"        @id("62bf01") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"
