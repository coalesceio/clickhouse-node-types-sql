@id("6dc1b9d5-5d07-4851-af2d-72cbf315531f")
@nodeType("SQLDimension")
SELECT
    generateUUIDv4()                                    AS "DIM_employee_KEY"    @id("a89a36") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "id"                                                AS "id"                  @id("325ac3") @isBusinessKey,
    "name"                                              AS "name"                @id("9e961c"),
    "department"                                        AS "department"          @id("f3dbb1"),
    "salary"                                            AS "salary"              @id("b873c1"),
    "created_at"                                        AS "created_at"          @id("1ff528"),
    1                                                   AS "SYSTEM_VERSION"      @id("aef0f0") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG" @id("110f12") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"  @id("169d66") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"  @id("5304d0") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"     @id("35af00") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"