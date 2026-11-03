@id("5a7dad3a-9a1c-4aa0-8ea6-44d6e224d430")
@nodeType("SQLDimension")
@description("Rebuild test - no PARTITION BY; redeploy adds one")
@orderBy("id", "SYSTEM_VERSION")
SELECT
    generateUUIDv4()                                    AS "DIM_employee_KEY"    @id("cedacb") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "id"                                                AS "id"                  @id("74d90c") @isBusinessKey,
    "name"                                              AS "name"                @id("1b23ec"),
    "department"                                        AS "department"          @id("5ae283"),
    "salary"                                            AS "salary"              @id("858bef"),
    "created_at"                                        AS "created_at"          @id("ef2a3b"),
    1                                                   AS "SYSTEM_VERSION"      @id("4b9b3c") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG" @id("a6903e") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"  @id("675f0d") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"  @id("2d5630") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"     @id("81b3b6") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"