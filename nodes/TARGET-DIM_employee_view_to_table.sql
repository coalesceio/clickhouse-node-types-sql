@id("d6ec1908-7e1c-4417-9263-d251cc96cceb")
@nodeType("SQLDimension")
@description("Materialization test - view; redeploy switches it to a table")
@materializationType("view")
SELECT
    generateUUIDv4()                                    AS "DIM_employee_KEY"    @id("ae3703") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "id"                                                AS "id"                  @id("02b62e") @isBusinessKey,
    "name"                                              AS "name"                @id("a39c2e"),
    "department"                                        AS "department"          @id("f87ca0"),
    "salary"                                            AS "salary"              @id("2353f9"),
    "created_at"                                        AS "created_at"          @id("bf3683"),
    1                                                   AS "SYSTEM_VERSION"      @id("e3d30f") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG" @id("734c05") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"  @id("0f232d") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"  @id("88b4dd") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"     @id("44bdd6") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"