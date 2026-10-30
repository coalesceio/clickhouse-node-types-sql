@id("f0b6e8c5-7a9d-4c1e-9f5b-4d2a6c0e8b15")
@nodeType("SQLFact")
@description("Pipeline - salary fact with employee and nation dimension keys, last modified SCD Type 1")
@materializationType("table")
@orderBy("id")
@primaryKey("id")
@partitionBy("toYYYYMM(created_at)")
@settings("index_granularity = 8192")
@writeMode("append")
@mergeStrategy("lastModified")
@disableTests(false)
@tests("SELECT id FROM WORKSPACE_PRANJAL.FCT_PL_salary GROUP BY id HAVING count() > 1", true, "After")
@preSQL("SELECT count() FROM WORKSPACE_PRANJAL.DIM_PL_employee")
@postSQL("SELECT count() FROM WORKSPACE_PRANJAL.FCT_PL_salary")
SELECT
    "e"."id"                                       AS "id"                  @id("5e6f8a") @description("Employee id") @isBusinessKey @notNull @not_null @uniqueness,
    ifNull("de"."DIM_PL_employee_KEY",
           toUUID('00000000-0000-0000-0000-000000000000')) AS "DIM_PL_employee_KEY" @id("6f7a9b") @description("Employee dimension key (zero key when not found)") @not_null,
    ifNull("dn"."DIM_PL_nation_KEY",
           toUUID('00000000-0000-0000-0000-000000000000')) AS "DIM_PL_nation_KEY"   @id("7a8b0c") @description("Nation dimension key"),
    "e"."salary"                                   AS "salary"              @id("8b9c1d") @description("Salary") @min_value("0") @max_value("10000000") @min_max("0", "10000000"),
    "e"."EMP_HASH"                                 AS "EMP_HASH"            @id("9c0d2e") @description("Employee hash from the work node") @inHash("ROW_HASH", 2),
    "e"."created_at"                               AS "created_at"          @id("0d1e3f") @description("Hire time - drives the incremental load") @lastModifiedTracking @inHash("ROW_HASH", 1) @relative_time("<=", "SYSTEM_CREATE_DATE"),
    {{ get_hash("ROW_HASH", "cityHash64", "") }}   AS "ROW_HASH"            @id("1e2f4a") @description("cityHash64 of created_at and employee hash"),
    now64(6)                                       AS "SYSTEM_CREATE_DATE"  @id("2f3a5b") @isSystemCreateDate,
    now64(6)                                       AS "SYSTEM_UPDATE_DATE"  @id("3a4b6c") @isSystemUpdateDate @freshness(1, "DAY")
FROM {{ ref('TARGET', 'WRK_PL_employee') }} "e"
LEFT JOIN {{ ref('TARGET', 'DIM_PL_employee') }} "de"
    ON "e"."id" = "de"."id" AND "de"."SYSTEM_CURRENT_FLAG" = 'Y'
LEFT JOIN {{ ref('TARGET', 'DIM_PL_nation') }} "dn"
    ON "e"."nation_key" = "dn"."n_nationkey"
