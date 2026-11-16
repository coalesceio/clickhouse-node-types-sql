@id("536eaff1-1c0e-44c3-b598-351dc5e56f7c")
@nodeType("SQLWork")
@materializationType("view")
SELECT
    CAST(toString(getSetting('max_threads')) AS String) AS `mt`,
    CAST(toString(getSetting('max_memory_usage')) AS String) AS `mm`,
    CAST(toString(getSetting('max_block_size')) AS String) AS `bs`,
    CAST(toString(getSetting('final')) AS String) AS `fin`,
    CAST(toString(getSetting('join_use_nulls')) AS String) AS `jun`
FROM numbers(1)
