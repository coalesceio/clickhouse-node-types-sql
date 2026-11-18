@id("a2000000-0000-4000-8000-000000000002")
@nodeType("SQLWork")
SELECT
    CAST('next_node' AS String)                         AS `probe_stage`,
    CAST(currentUser() AS String)                       AS `who`,
    CAST(toString(getSetting('max_query_size')) AS String) AS `max_query_size`
FROM {{ ref('TARGET', 'AU_FIRST') }} `f`
WHERE `f`.`probe_stage` = 'load'
