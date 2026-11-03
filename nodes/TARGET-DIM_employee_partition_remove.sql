@id("b61ccda5-3a4b-43df-b68c-6c068deb4e1a")
@nodeType("SQLDimension")
@description("Rebuild test - PARTITION BY toYYYYMM(created_at); redeploy removes it")
@orderBy("id", "SYSTEM_VERSION")
SELECT
    generateUUIDv4()                                    AS "DIM_employee_KEY"    @id("428b0b") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "id"                                                AS "id"                  @id("34abb1") @isBusinessKey,
    "name"                                              AS "name"                @id("16b195"),
    "department"                                        AS "department"          @id("16ed64"),
    "salary"                                            AS "salary"              @id("6afc94"),
    "created_at"                                        AS "created_at"          @id("ab0770"),
    1                                                   AS "SYSTEM_VERSION"      @id("cfe1cf") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG" @id("32c5ee") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"  @id("63cc88") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"  @id("b23da7") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"     @id("f3d918") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"