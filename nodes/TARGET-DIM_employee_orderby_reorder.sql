@id("89003059-2215-47fc-9e75-26c267f105a3")
@nodeType("SQLDimension")
@description("Rebuild test - ORDER BY (id, SYSTEM_VERSION) without primaryKey; redeploy reorders it")
@orderBy("id", "SYSTEM_VERSION")
SELECT
    generateUUIDv4()                                    AS "DIM_employee_KEY"    @id("f5873a") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "id"                                                AS "id"                  @id("0e6e93") @isBusinessKey,
    "name"                                              AS "name"                @id("ac5a04"),
    "department"                                        AS "department"          @id("3db967"),
    "salary"                                            AS "salary"              @id("506a41"),
    "created_at"                                        AS "created_at"          @id("ed0913"),
    1                                                   AS "SYSTEM_VERSION"      @id("b59145") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG" @id("b5d6c5") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"  @id("18554e") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"  @id("cb3497") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"     @id("6fb914") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"