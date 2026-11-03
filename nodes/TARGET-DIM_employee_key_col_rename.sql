@id("53227326-3dd6-4c01-bd8a-30cace10510b")
@nodeType("SQLDimension")
@description("Rebuild test - id is in ORDER BY; redeploy renames it")
@orderBy("emp_id", "SYSTEM_VERSION")
SELECT
    generateUUIDv4()                                    AS "DIM_employee_KEY"    @id("189cc6") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "id"                                                AS "emp_id"              @id("ef0334") @isBusinessKey,
    "name"                                              AS "name"                @id("8384d0"),
    "department"                                        AS "department"          @id("647b7e"),
    "salary"                                            AS "salary"              @id("e1ace8"),
    "created_at"                                        AS "created_at"          @id("6f9d06"),
    1                                                   AS "SYSTEM_VERSION"      @id("c68f3e") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG" @id("9dcecd") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"  @id("eb7dab") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"  @id("cf0ee3") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"     @id("cbaf16") @isSystemEndDate
FROM {{ ref('SRC', 'employee') }} "employee"