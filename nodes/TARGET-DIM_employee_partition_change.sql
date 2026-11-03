@id("718db651-ea30-48d8-9cca-74320c5ebf7b")
@nodeType("SQLDimension")
@description("Rebuild test - PARTITION BY toYYYYMM(created_at); redeploy changes it")
@partitionBy("department")
@orderBy("id", "SYSTEM_VERSION")
SELECT
    generateUUIDv4()                                    AS "DIM_employee_KEY"    @id("6480d2") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "id"                                                AS "id"                  @id("3f8f02") @isBusinessKey,
    "name"                                              AS "name"                @id("6d8c1a"),
    "department"                                        AS "department"          @id("3fde57"),
    "salary"                                            AS "salary"              @id("e672fb"),
    "created_at"                                        AS "created_at"          @id("d90ec1"),
    1                                                   AS "SYSTEM_VERSION"      @id("c1159a") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG" @id("944287") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"  @id("6488ea") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"  @id("a3128d") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"     @id("bb7e5f") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"