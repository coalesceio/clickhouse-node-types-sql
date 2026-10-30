@id("3e9b2c71-8f4a-4d6e-b1c5-7a0f2d9e4b83")
@nodeType("SQLDimension")
@description("Employee dimension - geo columns with zero key test, change tracking SCD Type 1, plain MergeTree")
@orderBy("id")
@mergeStrategy("changeTracking")
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'", "1900-01-01 00:00:00", true)
SELECT
    generateUUIDv4()                               AS "DIM_emp_GEO_ZK_KEY"     @id("4a7c1e") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "id"                                           AS "id"                     @id("5b8d2f") @isBusinessKey @notNull,
    "name"                                         AS "name"                   @id("6c9e3a"),
    CAST("department" AS LowCardinality(String))   AS "department"           @id("b14d8f"),
    CAST((toFloat64("id"), 0) AS Point)           AS "location"               @id("7d0f4b"),
    CAST([[(0, 0), (toFloat64("id"), 0), (0, 1)]] AS Polygon) AS "area"        @id("8e1a5c"),
    now64(6)                                       AS "SYSTEM_CREATE_DATE"     @id("9f2b6d") @isSystemCreateDate,
    now64(6)                                       AS "SYSTEM_UPDATE_DATE"     @id("a03c7e") @isSystemUpdateDate
FROM {{ ref('SRC', 'employee') }} "employee"
