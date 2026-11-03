@id("5ec23b72-7560-4ca0-9dfc-2d554e7ce620")
@nodeType("SQLDimension")
@description("Rebuild test - ORDER BY (id, SYSTEM_VERSION) with primaryKey(id); redeploy appends an existing column")
@orderBy("id", "SYSTEM_VERSION")
@primaryKey("id")
SELECT
    generateUUIDv4()                                    AS "DIM_employee_KEY"    @id("fd051e") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "id"                                                AS "id"                  @id("484f7f") @isBusinessKey,
    "name"                                              AS "name"                @id("a165bb"),
    "department"                                        AS "department"          @id("b1053a"),
    "salary"                                            AS "salary"              @id("9bb0fd"),
    "created_at"                                        AS "created_at"          @id("5927b4"),
    1                                                   AS "SYSTEM_VERSION"      @id("a5d4b4") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG" @id("fa98e6") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"  @id("833a0b") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"  @id("ad5b23") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"     @id("e40b3a") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"