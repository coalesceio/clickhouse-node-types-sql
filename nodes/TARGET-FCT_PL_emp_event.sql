@id("a1c7f9d6-8b0e-4d2f-8a6c-5e3b7d1f9c26")
@nodeType("SQLFact")
@description("Pipeline - factless fact of employee / department / nation / hire date, allColumnMatch (insert only new combinations)")
@materializationType("table")
@orderBy("id", "department", "hire_date")
@primaryKey("id", "department")
@settings("index_granularity = 8192")
@writeMode("append")
@mergeStrategy("allColumnMatch")
SELECT
    "id"                                           AS "id"           @id("4b5c7d") @description("Employee id") @notNull @not_null,
    "department"                                   AS "department"   @id("5c6d8e") @description("Department") @notNull @empty,
    "nation_name"                                  AS "nation_name"  @id("6d7e9f") @description("Nation") @notNull,
    toDate("created_at")                           AS "hire_date"    @id("7e8f0a") @description("Hire date") @notNull @min_max("'2000-01-01'", "'2100-01-01'")
FROM {{ ref('TARGET', 'WRK_PL_employee') }} "WRK_PL_employee"
