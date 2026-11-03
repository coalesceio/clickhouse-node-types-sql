@id("fc89ad38-57a6-4317-babd-d5e3a1be54a3")
@nodeType("SQLDimension")
@description("Rename test - table; redeploy renames the node and adds a column")
SELECT
    generateUUIDv4()                                    AS "DIM_employee_KEY"    @id("9e416e") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "id"                                                AS "id"                  @id("0d39ac") @isBusinessKey,
    "name"                                              AS "name"                @id("df08a3"),
    "department"                                        AS "department"          @id("e3b2d3"),
    "salary"                                            AS "salary"              @id("211f20"),
    "created_at"                                        AS "created_at"          @id("f5c7fe"),
    "salary" * 12                                       AS "annual_salary"       @id("21f0c3"),
    1                                                   AS "SYSTEM_VERSION"      @id("42504e") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG" @id("e6924f") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"  @id("d375c3") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"  @id("6900c6") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"     @id("5a48be") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"