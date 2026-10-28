@id("cfa39963-cf2b-4e93-abb9-5cac5cce681c")
@nodeType("SQLDimension")
@orderBy("id")
@mergeStrategy("changeTracking")
SELECT
    toUInt64(0)                                    AS "DIM_employee_KEY"   @id("31f9da") @isSurrogateKey @notNull,
    "id"                                           AS "id"                  @id("caab20") @isBusinessKey @notNull,
    "name"                                         AS "name"                @id("48b8bf"),
    "department"                                   AS "department"          @id("083f5f"),
    "salary"                                       AS "salary"              @id("138129"),
    "created_at"                                   AS "created_at"          @id("469423"),
    1                                              AS "SYSTEM_VERSION"      @id("c11bd6") @isSystemVersion,
    'Y'                                            AS "SYSTEM_CURRENT_FLAG" @id("6c3749") @isSystemCurrentFlag,
    now64(6)                                       AS "SYSTEM_CREATE_DATE"  @id("6c650e") @isSystemCreateDate,
    now64(6)                                       AS "SYSTEM_UPDATE_DATE"  @id("d81bcc") @isSystemUpdateDate @notNull,
    toDateTime64('2299-12-31 00:00:00', 6)         AS "SYSTEM_END_DATE"     @id("e51684") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"
