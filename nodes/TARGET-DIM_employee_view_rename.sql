@id("570f46f9-061e-49cf-82cf-5ff25947ec5e")
@nodeType("SQLDimension")
@description("View test - redeploy renames the view only")
@materializationType("view")
SELECT
    generateUUIDv4()                                    AS "DIM_employee_KEY"    @id("756cd6") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "id"                                                AS "id"                  @id("430b47") @isBusinessKey,
    "name"                                              AS "name"                @id("ff899d"),
    "department"                                        AS "department"          @id("cbea4c"),
    "salary"                                            AS "salary"              @id("6822ac"),
    "created_at"                                        AS "created_at"          @id("43be4c"),
    1                                                   AS "SYSTEM_VERSION"      @id("e8043d") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG" @id("b15816") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"  @id("44c54f") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"  @id("38f4d6") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"     @id("465355") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"