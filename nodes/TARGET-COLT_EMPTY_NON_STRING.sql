@id("0255e76e-995e-5caf-817c-3bc3d747b1ce")
@nodeType("SQLWork")
@description("@empty on a non-string column: the test query is rejected by ClickHouse (trim needs a String)")
SELECT
    CAST(number AS UInt32)                                                                       AS `o_uint_column` @empty
FROM numbers(5)
