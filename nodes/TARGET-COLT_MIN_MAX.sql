@id("3629f71f-9a8c-52a9-9c2e-5b87fca12f1e")
@nodeType("SQLWork")
@description("@min_max: inclusive range; numbers, negatives, decimals, dates; NULL passes")
SELECT
    CAST(number AS UInt32)                                                                       AS `p_int_inclusive` @min_max("0", "4"),
    CAST(number AS UInt32)                                                                       AS `f_int_narrow` @min_max("1", "3"),
    CAST(number AS UInt32)                                                                       AS `p_int_unquoted` @min_max(0, 4),
    CAST(toInt32(number) - 2 AS Int32)                                                           AS `p_negative` @min_max("-2", "2"),
    CAST(toInt32(number) - 2 AS Int32)                                                           AS `f_negative` @min_max("-1", "2"),
    CAST(number / 2 AS Decimal(12, 2))                                                           AS `p_decimal` @min_max("0", "2.0"),
    CAST(number * 1.5 AS Float64)                                                                AS `f_float` @min_max("0", "5.9"),
    CAST(toDate('2026-01-01') + number AS Date)                                                  AS `p_date_literal` @min_max("'2026-01-01'", "'2026-01-05'"),
    CAST(toDate('2026-01-01') + number AS Date)                                                  AS `p_date_function` @min_max("toDate('2026-01-01')", "today()"),
    CAST(now() + 3600 AS DateTime)                                                               AS `f_datetime_future` @min_max("toDateTime('2000-01-01 00:00:00')", "now()"),
    CAST(if(number = 0, NULL, number) AS Nullable(UInt32))                                       AS `p_null_passes` @min_max("1", "4")
FROM numbers(5)
