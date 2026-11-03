@id("4fbc3ef8-fc13-4bc6-87fd-9462f81a20c1")
@nodeType("SQLDimension")
SELECT
    generateUUIDv4()                                    AS "DIM_employee_KEY"    @id("073d86") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "id"                                                AS "id"                  @id("fafffb") @isBusinessKey,
    "name"                                              AS "name"                @id("3867cc"),
    "department"                                        AS "department"          @id("946450"),
    "salary"                                            AS "salary"              @id("26d0cf"),
    "created_at"                                        AS "created_at"          @id("267515"),
    1                                                   AS "SYSTEM_VERSION"      @id("7ce316") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG" @id("41a5c1") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"  @id("4302f4") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"  @id("ff7021") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"     @id("046218") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"