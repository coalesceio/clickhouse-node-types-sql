@id("dc07ef9c-7da3-44ff-950f-e3a52f1fd001")
@nodeType("SQLDimension")
@description("Rename test - table; redeploy renames the node only")
SELECT
    generateUUIDv4()                                    AS "DIM_employee_KEY"    @id("bc80c3") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "id"                                                AS "id"                  @id("86ea2f") @isBusinessKey,
    "name"                                              AS "name"                @id("31b878"),
    "department"                                        AS "department"          @id("66c0e8"),
    "salary"                                            AS "salary"              @id("0ac477"),
    "created_at"                                        AS "created_at"          @id("9c4191"),
    1                                                   AS "SYSTEM_VERSION"      @id("e9ecae") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG" @id("441d46") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"  @id("35818e") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"  @id("90ca90") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"     @id("edd047") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"