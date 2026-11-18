@id("239c3066-2909-4f53-bd2d-e0fd40dfbc63")
@nodeType("SQLWork")
@tests("SELECT 1 FROM {{ this }} WHERE `mt` != '3' OR `mm` != '10000000000' OR `fin` != 'true' OR `jun` != 'true'", false, "After")
SELECT
    CAST(toString(getSetting('max_threads')) AS String) AS `mt`,
    CAST(toString(getSetting('max_memory_usage')) AS String) AS `mm`,
    CAST(toString(getSetting('max_block_size')) AS String) AS `bs`,
    CAST(toString(getSetting('final')) AS String) AS `fin`,
    CAST(toString(getSetting('join_use_nulls')) AS String) AS `jun`
FROM numbers(1)
