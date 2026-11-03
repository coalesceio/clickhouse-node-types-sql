@id("bb4585b7-0144-42bf-9d65-4c9742aa828b")
@nodeType("SQLDimension")
@description("Rebuild test - id is in ORDER BY; redeploy changes its type")
@orderBy("id", "SYSTEM_VERSION")
SELECT
    generateUUIDv4()                                    AS "DIM_employee_KEY"    @id("9e76c4") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "id"                                                AS "id"                  @id("f47796") @isBusinessKey,
    "name"                                              AS "name"                @id("1417ed"),
    "department"                                        AS "department"          @id("570ad1"),
    "salary"                                            AS "salary"              @id("d34e74"),
    "created_at"                                        AS "created_at"          @id("fc848f"),
    1                                                   AS "SYSTEM_VERSION"      @id("b5d3e9") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG" @id("d8cbe9") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"  @id("06a1fb") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"  @id("6d348a") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"     @id("43b78f") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"