@id("6eafa0be-0e61-5d89-b41a-19591e827f8d")
@nodeType("SQLWork")
@description("@max_value: fails rows above the bound; NULL passes")
SELECT
    CAST(number AS UInt32)                                                                       AS `p_int` @max_value("4"),
    CAST(number AS UInt32)                                                                       AS `f_int` @max_value("3"),
    CAST(toInt32(number) - 2 AS Int32)                                                           AS `f_negative` @max_value("-1"),
    CAST(number * 1.5 AS Float64)                                                                AS `p_float` @max_value("6"),
    CAST(now() - 60 AS DateTime)                                                                 AS `p_datetime_now` @max_value("now()"),
    CAST(now() + 3600 AS DateTime)                                                               AS `f_datetime_future` @max_value("now()"),
    CAST(toDate('2026-01-01') + number AS Date)                                                  AS `f_date` @max_value("'2026-01-03'"),
    CAST(if(number = 4, NULL, number) AS Nullable(UInt32))                                       AS `p_null_passes` @max_value("3")
FROM numbers(5)
