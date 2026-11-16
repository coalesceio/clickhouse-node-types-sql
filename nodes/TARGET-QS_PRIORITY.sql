@id("af7df6a0-8517-4b28-8c9d-5f97dcb4ed8a")
@nodeType("SQLWork")
@querySettings("max_threads = 2", "max_block_size = 4096")
SELECT
    CAST(toString(getSetting('max_threads'))      AS String) AS `mt`,
    CAST(toString(getSetting('max_block_size'))   AS String) AS `bs`,
    CAST(toString(getSetting('max_memory_usage')) AS String) AS `mm`,
    CAST(toString(getSetting('max_insert_threads')) AS String) AS `it`
FROM numbers(1)
SETTINGS max_threads = 1
