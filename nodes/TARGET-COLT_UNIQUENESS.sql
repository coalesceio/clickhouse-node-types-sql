@id("a20f766f-1f72-5c4e-a8e3-0c596c2dfd3e")
@nodeType("SQLWork")
@description("@uniqueness: GROUP BY the column HAVING count() > 1; NULLs group together")
SELECT
    CAST(number AS UInt32)                                                                       AS `p_uint_unique` @uniqueness,
    CAST(intDiv(number, 2) AS UInt32)                                                            AS `f_uint_dup` @uniqueness,
    CAST(concat('k', toString(number)) AS String)                                                AS `p_string_unique` @uniqueness,
    CAST(if(number < 2, 'a', toString(number)) AS String)                                        AS `f_string_dup` @uniqueness,
    CAST(multiIf(number = 0, 'A', number = 1, 'a', toString(number)) AS String)                  AS `p_case_differs` @uniqueness,
    CAST(multiIf(number = 0, 'x', number = 1, 'x ', toString(number)) AS String)                 AS `p_trailing_space_differs` @uniqueness,
    CAST(if(number = 0, NULL, number) AS Nullable(UInt32))                                       AS `p_one_null` @uniqueness,
    CAST(if(number < 2, NULL, number) AS Nullable(UInt32))                                       AS `f_two_nulls` @uniqueness,
    CAST(toDate('2026-01-01') + number AS Date)                                                  AS `p_date_unique` @uniqueness,
    CAST(toDateTime('2026-01-01 00:00:00') AS DateTime)                                          AS `f_datetime_all_same` @uniqueness,
    CAST(number * 0.1 AS Float64)                                                                AS `p_float_unique` @uniqueness,
    CAST(1.5 AS Decimal(12, 2))                                                                  AS `f_decimal_all_same` @uniqueness,
    CAST(generateUUIDv4() AS UUID)                                                               AS `p_uuid` @uniqueness
FROM numbers(5)
