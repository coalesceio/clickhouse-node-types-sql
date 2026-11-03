@id("d38d43d7-c63f-4199-bd3d-b8620e0d09a0")
@nodeType("SQLDimension")
SELECT
    generateUUIDv4()                                    AS "DIM_employee_KEY"    @id("f575d4") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "id"                                                AS "id"                  @id("be7f62") @isBusinessKey,
    "name"                                              AS "name"                @id("c708c3"),
    "department"                                        AS "department"          @id("3936e0"),
    "salary"                                            AS "salary"              @id("daa9cb"),
    "created_at"                                        AS "created_at"          @id("183252"),
    1                                                   AS "SYSTEM_VERSION"      @id("442f64") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG" @id("6ffc6c") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"  @id("c12c47") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"  @id("48a46c") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"     @id("b8877d") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"