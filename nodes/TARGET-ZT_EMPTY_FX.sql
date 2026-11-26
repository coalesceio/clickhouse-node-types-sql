@id("7f3c2a10-0004-4c1e-9a11-0000000000e1")
@nodeType("SQLWork")
SELECT
    CAST(number + 1 AS UInt32)                                               AS `id`   @id("fe0001"),
    CAST(['', ' ', '   ', 'a'][number + 1] AS FixedString(3))                AS `fx`   @id("fe0002") @empty,
    CAST([NULL, '', ' ', 'a'][number + 1] AS Nullable(FixedString(3)))       AS `nfx`  @id("fe0003") @empty,
    CAST(['', ' ', '   ', 'a'][number + 1] AS LowCardinality(FixedString(3))) AS `lcfx` @id("fe0004") @empty,
    CAST(['', ' ', 'x', 'y'][number + 1] AS String)                          AS `s`    @id("fe0005") @empty
FROM numbers(4)
