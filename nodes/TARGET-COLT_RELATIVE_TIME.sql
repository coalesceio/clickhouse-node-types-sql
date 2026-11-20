@id("7715234c-2f33-550e-a072-8399c657c32d")
@nodeType("SQLWork")
@description("@relative_time: compares with another date/time column; either side NULL is skipped")
SELECT
    CAST(toDateTime('2026-01-01 00:00:00') + INTERVAL number DAY AS DateTime)                    AS `start_dt`,
    CAST(toDateTime('2026-01-02 00:00:00') + INTERVAL number DAY AS DateTime)                    AS `end_dt`,
    CAST(toDateTime('2026-01-01 00:00:00') + INTERVAL number DAY AS DateTime)                    AS `p_lt` @relative_time("<", "end_dt"),
    CAST(toDateTime('2026-01-01 00:00:00') + INTERVAL number DAY AS DateTime)                    AS `p_le_equal` @relative_time("<=", "start_dt"),
    CAST(toDateTime('2026-01-01 00:00:00') + INTERVAL number DAY AS DateTime)                    AS `p_ge_equal` @relative_time(">=", "start_dt"),
    CAST(toDateTime('2026-01-01 00:00:00') + INTERVAL number DAY AS DateTime)                    AS `p_ne` @relative_time("!=", "end_dt"),
    CAST(toDateTime('2026-01-01 00:00:00') + INTERVAL number DAY AS DateTime)                    AS `f_gt` @relative_time(">", "end_dt"),
    CAST(toDateTime('2026-01-01 00:00:00') + INTERVAL number DAY AS DateTime)                    AS `f_eq` @relative_time("=", "end_dt"),
    CAST(if(number = 0, NULL, toDateTime('2026-01-09 00:00:00')) AS Nullable(DateTime))          AS `f_null_skipped_rest_fail` @relative_time("<", "end_dt"),
    CAST(if(number = 0, NULL, toDateTime('2025-01-01 00:00:00')) AS Nullable(DateTime))          AS `p_null_skipped` @relative_time("<", "end_dt"),
    CAST(toDate('2026-01-01') + number AS Date)                                                  AS `o_date_vs_datetime` @relative_time("<", "end_dt")
FROM numbers(5)
