@id("18f9087b-30a2-5e6c-ac3b-a15bb624d4b9")
@nodeType("SQLWork")
@description("@empty: fails rows whose value trims to empty; NULL passes")
SELECT
    CAST('abc' AS String)                                                                        AS `p_string` @empty,
    CAST(if(number = 0, '', 'x') AS String)                                                      AS `f_empty_string` @empty,
    CAST(if(number = 1, '   ', 'x') AS String)                                                   AS `f_only_spaces` @empty,
    CAST(if(number = 2, NULL, 'x') AS Nullable(String))                                          AS `p_null_passes` @empty,
    CAST(if(number = 2, '', 'x') AS Nullable(String))                                            AS `f_nullable_empty` @empty,
    CAST(if(number = 3, '', 'x') AS LowCardinality(String))                                      AS `f_lowcard_empty` @empty,
    CAST(if(number = 0, char(9), 'x') AS String)                                                 AS `o_tab_only` @empty,
    CAST(if(number = 0, '', 'abc') AS FixedString(3))                                            AS `o_fixedstring_empty` @empty
FROM numbers(5)
