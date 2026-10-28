@id("4d6c23dd-77fb-43b8-b79f-e8ec203f9159")
@nodeType("SQLDimension")
@description("Employee dimension - INSERT + DELETE load, change tracking SCD Type 2, plain MergeTree")
@engine("MergeTree")
@orderBy("id", "SYSTEM_VERSION")
@mergeStrategy("changeTracking")
SELECT
    toUInt64(0)                                    AS "DIM_emp_IU_CT_SCD2_KEY" @id("702c2a") @isSurrogateKey @notNull,
    "id"                                           AS "id"                     @id("899508") @isBusinessKey @notNull,
    "name"                                         AS "name"                   @id("5009dc") @isChangeTracking,
    "department"                                   AS "department"             @id("e59802"),
    "salary"                                       AS "salary"                 @id("d49f65"),
    "created_at"                                   AS "created_at"             @id("21b05b"),
    toUInt32(1)                                    AS "SYSTEM_VERSION"         @id("654591") @isSystemVersion,
    'Y'                                            AS "SYSTEM_CURRENT_FLAG1"    @id("30db06") @isSystemCurrentFlag,
    now64(6)                                       AS "SYSTEM_CREATE_DATE"     @id("601c32") @isSystemCreateDate,
    now64(6)                                       AS "SYSTEM_UPDATE_DATE"     @id("ee8680") @isSystemUpdateDate,
    toDateTime64('2299-12-31 00:00:00', 6)         AS "SYSTEM_END_DATE"        @id("316c04") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"
