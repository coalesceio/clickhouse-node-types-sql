@id("71fd0e20-9bc5-415e-8f90-8cc70532fb8e")
@nodeType("SQLWork")
SELECT
    CAST('next_node'                               AS String) AS `probe_stage`,
    CAST(toString(getSetting('max_query_size'))    AS String) AS `max_query_size`,
    CAST(toString(getSetting('max_threads'))       AS String) AS `max_threads`,
    CAST(toString(getSetting('join_algorithm'))    AS String) AS `join_algorithm`
FROM {{ ref('TARGET', 'QS_DBT_MEMORY') }} `src`
WHERE `src`.`probe_stage` = 'load'
