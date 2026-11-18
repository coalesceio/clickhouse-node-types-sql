@id("a2000000-0000-4000-8000-000000000001")
@nodeType("SQLWork")
@preSQL("ALTER USER `tanvi.kamat.contractor` MODIFY SETTINGS max_query_size = 10485760")
@postSQL("INSERT INTO {{ this }} (`probe_stage`, `who`, `max_query_size`) SELECT 'post_sql', currentUser(), toString(getSetting('max_query_size'))")
@tests("SELECT 1 WHERE getSetting('max_query_size') != 10485760", true, "After")
SELECT
    CAST('load' AS String)                              AS `probe_stage`,
    CAST(currentUser() AS String)                       AS `who`,
    CAST(toString(getSetting('max_query_size')) AS String) AS `max_query_size`
FROM numbers(1)
