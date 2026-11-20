@id("09dea576-c48a-5b53-89e2-8c4d03c0a055")
@nodeType("SQLWork")
@description("@accepted_values: list forms, types and quoting; NULL passes")
SELECT
    CAST(number AS UInt32)                                                                       AS `p_int_one_list` @accepted_values("0, 1, 2, 3, 4"),
    CAST(number AS UInt32)                                                                       AS `f_int_missing_3_4` @accepted_values("0, 1, 2"),
    CAST(number AS UInt32)                                                                       AS `p_int_separate_args` @accepted_values("0", "1", "2", "3", "4"),
    CAST(number AS UInt32)                                                                       AS `p_int_repeated_merged` @accepted_values("0, 1") @accepted_values("2, 3, 4"),
    CAST(number AS UInt32)                                                                       AS `p_int_unquoted` @accepted_values(0, 1, 2, 3, 4),
    CAST(['A', 'B', 'C'][number % 3 + 1] AS String)                                              AS `p_string` @accepted_values("'A', 'B', 'C'"),
    CAST(['A', 'B', 'C'][number % 3 + 1] AS String)                                              AS `f_string_wrong_case` @accepted_values("'a', 'b', 'c'"),
    CAST(if(number % 2 = 0, NULL, 'X') AS Nullable(String))                                      AS `p_null_passes` @accepted_values("'X'"),
    CAST(number % 2 = 0 AS Bool)                                                                 AS `p_bool` @accepted_values(true, false),
    CAST(number % 2 = 0 AS Bool)                                                                 AS `f_bool_only_true` @accepted_values(true),
    CAST(toDate('2026-01-01') + number % 2 AS Date)                                              AS `p_date_literal` @accepted_values("'2026-01-01', '2026-01-02'"),
    CAST(toDate('2026-01-01') + number % 2 AS Date)                                              AS `p_date_function` @accepted_values("toDate('2026-01-01')", "toDate('2026-01-02')"),
    CAST(['a', 'b'][number % 2 + 1] AS Enum8('a' = 1, 'b' = 2))                                  AS `p_enum` @accepted_values("'a', 'b'"),
    CAST(1.5 + number % 2 AS Decimal(12, 2))                                                     AS `p_decimal` @accepted_values("1.5, 2.5"),
    CAST('a,b' AS String)                                                                        AS `o_value_with_comma` @accepted_values("'a,b'")
FROM numbers(5)
