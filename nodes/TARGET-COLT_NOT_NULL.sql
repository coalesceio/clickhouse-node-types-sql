@id("fd3c57e0-b518-53c3-ba32-73ad732f7e29")
@nodeType("SQLWork")
@description("@not_null: every column has @not_null; p_ = expected pass, f_ = expected fail")
SELECT
    CAST(number AS UInt32)                                                                       AS `p_uint32` @not_null,
    CAST(toString(number) AS String)                                                             AS `p_string` @not_null,
    CAST('' AS String)                                                                           AS `p_empty_string_is_not_null` @not_null,
    CAST(number AS Nullable(UInt32))                                                             AS `p_nullable_no_nulls` @not_null,
    CAST(if(number = 2, NULL, number) AS Nullable(UInt32))                                       AS `f_nullable_one_null` @not_null,
    CAST(NULL AS Nullable(String))                                                               AS `f_nullable_all_null` @not_null,
    CAST(if(number = 0, NULL, toDate('2026-01-01')) AS Nullable(Date))                           AS `f_nullable_date` @not_null,
    CAST(if(number = 1, NULL, now64(6)) AS Nullable(DateTime64(6)))                              AS `f_nullable_dt64` @not_null,
    CAST('a' AS LowCardinality(Nullable(String)))                                                AS `p_lowcard_nullable_no_nulls` @not_null,
    CAST(if(number = 3, NULL, 'a') AS LowCardinality(Nullable(String)))                          AS `f_lowcard_nullable_null` @not_null,
    CAST([number] AS Array(UInt64))                                                              AS `p_array` @not_null,
    CAST(if(number = 2, NULL, number) AS Nullable(UInt32))                                       AS `p_notnull_annot_null_stored_as_0` @notNull @not_null
FROM numbers(5)
