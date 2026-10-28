@id("92e1ff74-b214-4d41-a053-4baada06c3c8")
@nodeType("SQLDimension")
@description("Employee dimension - INSERT + DELETE load, last modified SCD Type 2, plain MergeTree")
@orderBy("id", "SYSTEM_VERSION")
@mergeStrategy("lastModified")
SELECT
    toUInt64(0)                                    AS "DIM_emp_IU_LM_SCD2_KEY" @id("c09cce") @isSurrogateKey @notNull,
    "id"                                           AS "id"                     @id("a1e833") @isBusinessKey @notNull,
    "name"                                         AS "name"                   @id("fc4d46"),
    "department"                                   AS "department"             @id("e016fb"),
    "salary"                                       AS "salary"                 @id("ad747f"),
    "created_at"                                   AS "created_at"             @id("7b74cb") @lastModifiedTracking(2),
    toUInt32(1)                                    AS "SYSTEM_VERSION"         @id("2377c2") @isSystemVersion,
    'Y'                                            AS "SYSTEM_CURRENT_FLAG"    @id("959f97") @isSystemCurrentFlag,
    now64(6)                                       AS "SYSTEM_CREATE_DATE"     @id("5d4e92") @isSystemCreateDate,
    now64(6)                                       AS "SYSTEM_UPDATE_DATE"     @id("5568ce") @isSystemUpdateDate,
    toDateTime64('2299-12-31 00:00:00', 6)         AS "SYSTEM_END_DATE"        @id("e18c80") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"
