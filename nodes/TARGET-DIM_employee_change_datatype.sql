@id("f94e4793-4c9e-40a7-ab43-ef268d817d2d")
@nodeType("SQLDimension")
SELECT
    generateUUIDv4()                                    AS "DIM_employee_KEY"    @id("514a70") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "id"                                                AS "id"                  @id("8fca28") @isBusinessKey,
    "name"                                              AS "name"                @id("79bf05"),
    "department"                                        AS "department"          @id("eac8d2"),
    CAST("salary" AS Float64)                           AS "salary"              @id("59886b"),
    "created_at"                                        AS "created_at"          @id("dd1835"),
    1                                                   AS "SYSTEM_VERSION"      @id("e7906c") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG" @id("bd9580") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"  @id("dce3a8") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"  @id("be5108") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"     @id("cee931") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"