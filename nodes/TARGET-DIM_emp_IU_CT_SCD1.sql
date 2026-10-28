@id("667efb02-874d-4c86-bdbd-c2c4bb2a138d")
@nodeType("SQLDimension")
@description("Employee dimension - INSERT + DELETE load, change tracking SCD Type 1, plain MergeTree")
@engine("MergeTree")
@orderBy("id")
@mergeStrategy("changeTracking")
SELECT
    toUInt64(0)                                    AS "DIM_emp_IU_CT_SCD1_KEY" @id("872046") @isSurrogateKey @notNull,
    "id"                                           AS "id"                     @id("e139ca") @isBusinessKey @notNull,
    "name"                                         AS "name"                   @id("eb5e55"),
    "department"                                   AS "department"             @id("8c3f9a"),
    "salary"                                       AS "salary"                 @id("e4b73b"),
    "created_at"                                   AS "created_at"             @id("a03c91"),
    toUInt32(1)                                    AS "SYSTEM_VERSION"         @id("f15cf9") @isSystemVersion,
    'Y'                                            AS "SYSTEM_CURRENT_FLAG"    @id("879605") @isSystemCurrentFlag,
    now64(6)                                       AS "SYSTEM_CREATE_DATE"     @id("2fa8d1") @isSystemCreateDate,
    now64(6)                                       AS "SYSTEM_UPDATE_DATE"     @id("de8dee") @isSystemUpdateDate,
    toDateTime64('2299-12-31 00:00:00', 6)         AS "SYSTEM_END_DATE"        @id("34287d") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"
