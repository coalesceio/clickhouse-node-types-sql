@id("28ceab16-49f4-456a-937c-2dc9e602650d")
@nodeType("SQLDimension")
@description("View test - redeploy changes the SQL, so the view is recreated")
@materializationType("view")
SELECT
    generateUUIDv4()                                    AS "DIM_employee_KEY"    @id("139b01") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "id"                                                AS "id"                  @id("9f5d62") @isBusinessKey,
    "name"                                              AS "name"                @id("d29fe6"),
    "department"                                        AS "department"          @id("22145a"),
    "salary"                                            AS "salary"              @id("578ee0"),
    "created_at"                                        AS "created_at"          @id("684a1f"),
    1                                                   AS "SYSTEM_VERSION"      @id("d1b346") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG" @id("bea019") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"  @id("0041f4") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"  @id("3f1992") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"     @id("1efa35") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"