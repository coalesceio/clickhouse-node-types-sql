@id("c7e3b5f2-4d6a-4f8b-8c2e-1a9d3f7b5e82")
@nodeType("SQLWork")
@description("Pipeline - employees enriched with nation and salary band, full reload each run")
@materializationType("table")
@orderBy("id", "toYYYYMM(created_at)")
@primaryKey("id")
@partitionBy("toYYYYMM(created_at)")
@settings("index_granularity = 8192")
@writeMode("truncateInsert")
@disableTests(false)
@tests("SELECT 1 FROM coalesce_test_pr.employee HAVING count() = 0", false, "Before")
@tests("SELECT id FROM WORKSPACE_PRANJAL.WRK_PL_employee WHERE salary < 0", true, "After")
@preSQL("SELECT count() FROM coalesce_test_pr.employee")
@postSQL("OPTIMIZE TABLE WORKSPACE_PRANJAL.WRK_PL_employee FINAL")
SELECT
    "employee"."id"                                AS "id"             @id("5e6f7a") @description("Employee id") @notNull @inHash("EMP_HASH", 1) @not_null @uniqueness @min_value("1"),
    trim("employee"."name")                        AS "name"           @id("6f7a8b") @description("Employee name") @inHash("EMP_HASH", 2) @empty @rejected_values("'UNKNOWN'", "'N/A'"),
    "employee"."department"                        AS "department"     @id("7a8b9c") @description("Department") @defaultValue("'UNASSIGNED'") @inHash("EMP_HASH", 3) @not_null,
    "employee"."salary"                            AS "salary"         @id("8b9c0d") @description("Salary") @min_max("0", "10000000") @max_value("10000000"),
    multiIf("employee"."salary" < 50000, 'LOW',
            "employee"."salary" < 100000, 'MID',
            'HIGH')                                AS "salary_band"    @id("9c0d1e") @description("Salary band") @accepted_values("'LOW', 'MID'") @accepted_values("'HIGH'"),
    "nation"."n_nationkey"                         AS "nation_key"     @id("0d1e2f") @description("Nation key (id mod 25)"),
    "nation"."nation_name"                         AS "nation_name"    @id("1e2f3a") @description("Nation name"),
    "employee"."created_at"                        AS "created_at"     @id("2f3a4b") @description("Hire time") @notNull @relative_time("<=", "LOAD_TS"),
    {{ get_hash("EMP_HASH", "MD5", "|") }}         AS "EMP_HASH"       @id("3a4b5c") @description("MD5 of id, name, department"),
    now64(6)                                       AS "LOAD_TS"        @id("4b5c6d") @description("Load time") @notNull @freshness(1, "DAY") @min_value("'2020-01-01 00:00:00'")
FROM {{ ref('SRC', 'employee') }} "employee"
LEFT JOIN {{ ref('TARGET', 'WRK_PL_nation') }} "nation"
    ON ("employee"."id" % 25) = "nation"."n_nationkey"
