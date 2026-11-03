@id("2c3b070c-f19b-4fac-b70e-268475bc3372")
@nodeType("SQLDimension")
@description("Rebuild test - PRIMARY KEY (id) differs from ORDER BY; redeploy changes the primary key")
@orderBy("id", "department", "SYSTEM_VERSION")
@primaryKey("id")
SELECT
    generateUUIDv4()                                    AS "DIM_employee_KEY"    @id("3e15d5") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "id"                                                AS "id"                  @id("c420e0") @isBusinessKey,
    "name"                                              AS "name"                @id("da8846"),
    "department"                                        AS "department"          @id("48c98c"),
    "salary"                                            AS "salary"              @id("c988d9"),
    "created_at"                                        AS "created_at"          @id("a04c55"),
    1                                                   AS "SYSTEM_VERSION"      @id("4650e3") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG" @id("f10ae6") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"  @id("66b7e2") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"  @id("c77552") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"     @id("62481d") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"