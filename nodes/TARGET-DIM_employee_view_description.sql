@id("f051ad53-4980-436f-a36c-e573ade00144")
@nodeType("SQLDimension")
@description("View test - description changed on redeploy")
@materializationType("view")
SELECT
    generateUUIDv4()                                    AS "DIM_employee_KEY"    @id("bcc93d") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "id"                                                AS "id"                  @id("c9e6d6") @isBusinessKey,
    "name"                                              AS "name"                @id("bf5e5c"),
    "department"                                        AS "department"          @id("87d269"),
    "salary"                                            AS "salary"              @id("1b64bc"),
    "created_at"                                        AS "created_at"          @id("eb68c0"),
    1                                                   AS "SYSTEM_VERSION"      @id("e22ecf") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG" @id("606587") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"  @id("ac1805") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"  @id("5efc21") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"     @id("59cfb7") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"