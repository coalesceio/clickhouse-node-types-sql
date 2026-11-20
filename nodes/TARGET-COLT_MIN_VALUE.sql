@id("43fd3f0c-b526-5e57-bad1-09157805d748")
@nodeType("SQLWork")
@description("@min_value: fails rows below the bound; NULL passes")
SELECT
    CAST(number AS UInt32)                                                                       AS `p_int` @min_value("0"),
    CAST(number AS UInt32)                                                                       AS `f_int` @min_value("1"),
    CAST(toInt32(number) - 2 AS Int32)                                                           AS `p_negative` @min_value("-2"),
    CAST(toInt32(number) - 2 AS Int32)                                                           AS `f_negative` @min_value("-1"),
    CAST(number / 2 AS Decimal(12, 2))                                                           AS `f_decimal` @min_value("0.5"),
    CAST(toDate('2026-01-01') + number AS Date)                                                  AS `p_date` @min_value("'2026-01-01'"),
    CAST(toDate('2026-01-01') + number AS Date)                                                  AS `f_date` @min_value("toDate('2026-01-02')"),
    CAST(if(number = 0, NULL, number) AS Nullable(UInt32))                                       AS `p_null_passes` @min_value("1")
FROM numbers(5)
