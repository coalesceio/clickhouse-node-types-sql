@id("d9693c3f-b46d-45d7-b44d-b5a4ef3655c7")
@nodeType("SQLWork")
@materializationType("view")
@final
@joinUseNulls
@querySettings("max_threads = 5")
SELECT
    CAST(toString(getSetting('max_threads')) AS String) AS `mt`,
    CAST(toString(getSetting('max_memory_usage')) AS String) AS `mm`,
    CAST(toString(getSetting('max_block_size')) AS String) AS `bs`,
    CAST(toString(getSetting('final')) AS String) AS `fin`,
    CAST(toString(getSetting('join_use_nulls')) AS String) AS `jun`
FROM numbers(1)
