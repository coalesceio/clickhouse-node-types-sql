@id("184bfcfa-66e8-42d2-ba46-bd8c26dc38f8")
@nodeType("SQLDimension")
@description("Materialization test - table; redeploy switches it to a view")
@materializationType("table")
SELECT
    generateUUIDv4()                                    AS "DIM_employee_KEY"    @id("45892a") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "id"                                                AS "id"                  @id("ce6ebe") @isBusinessKey,
    "name"                                              AS "name"                @id("1fc151"),
    "department"                                        AS "department"          @id("04a854"),
    "salary"                                            AS "salary"              @id("6dcc56"),
    "created_at"                                        AS "created_at"          @id("6537de"),
    1                                                   AS "SYSTEM_VERSION"      @id("03b977") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG" @id("cd0a7e") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"  @id("7862e0") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"  @id("499d2d") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"     @id("a0dd1c") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"