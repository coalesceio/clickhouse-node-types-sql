@id("94147299-46fb-5278-acd5-92963e4d58ec")
@nodeType("SQLWork")
@description("@rejected_values: list forms, types and quoting; NULL passes")
SELECT
    CAST(number AS UInt32)                                                                       AS `p_int` @rejected_values("9, 10"),
    CAST(number AS UInt32)                                                                       AS `f_int` @rejected_values("2"),
    CAST(number AS UInt32)                                                                       AS `f_int_separate_args` @rejected_values("7", "4"),
    CAST(['A', 'B', 'C'][number % 3 + 1] AS String)                                              AS `p_string` @rejected_values("'DELETED'", "'TEST'"),
    CAST(['A', 'B', 'C'][number % 3 + 1] AS String)                                              AS `f_string` @rejected_values("'B'"),
    CAST(['A', 'B', 'C'][number % 3 + 1] AS String)                                              AS `f_repeated_merged` @rejected_values("'X'") @rejected_values("'C'"),
    CAST(if(number % 2 = 0, NULL, 'X') AS Nullable(String))                                      AS `p_null_passes` @rejected_values("'Y'"),
    CAST(toDate('2026-01-01') + number AS Date)                                                  AS `f_date` @rejected_values("'2026-01-03'"),
    CAST(number % 2 = 0 AS Bool)                                                                 AS `f_bool` @rejected_values(false),
    CAST('a,b' AS String)                                                                        AS `o_value_with_comma` @rejected_values("'a,b'")
FROM numbers(5)
