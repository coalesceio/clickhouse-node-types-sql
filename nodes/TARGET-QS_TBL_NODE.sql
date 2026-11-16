@id("dcfcd76d-43d4-4f16-9163-64b45211d556")
@nodeType("SQLWork")
@querySettings("max_threads = 7", "max_block_size = 4096", "final = 0")
@tests("SELECT 1 FROM {{ this }} WHERE `mt` != '7' OR `bs` != '4096' OR `mm` != '10000000000' OR `fin` != 'true' OR `jun` != 'true'", false, "After")
SELECT
    CAST(toString(getSetting('max_threads')) AS String) AS `mt`,
    CAST(toString(getSetting('max_memory_usage')) AS String) AS `mm`,
    CAST(toString(getSetting('max_block_size')) AS String) AS `bs`,
    CAST(toString(getSetting('final')) AS String) AS `fin`,
    CAST(toString(getSetting('join_use_nulls')) AS String) AS `jun`
FROM numbers(1)
