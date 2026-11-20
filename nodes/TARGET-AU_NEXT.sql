@id("a2000000-0000-4000-8000-000000000002")
@nodeType("SQLWork")
@description("Query settings demo, next node: no @querySettings or Pre-SQL; shows what carries over from AU_FIRST (max_query_size on the user does, the @querySettings do not). The LEFT JOIN matches only AU_FIRST's load row, so the post_sql row shows what an unmatched join column stores: @defaultValue (a constant or another column), the type's default, or NULL")
SELECT
    CAST(concat('next_node from ', `f`.`probe_stage`) AS String)  AS `probe_stage`,
    CAST(if(`f`.`probe_stage` = 'load', currentUser(), NULL) AS Nullable(String)) AS `who` @notNull @defaultValue("`probe_stage`"),
    CAST(toString(getSetting('join_algorithm')) AS String)        AS `join_algorithm`,
    CAST(toString(getSetting('max_threads')) AS String)           AS `max_threads`,
    CAST(toString(getSetting('max_block_size')) AS String)        AS `max_block_size`,
    CAST(toString(getSetting('max_insert_threads')) AS String)    AS `max_insert_threads`,
    CAST(toString(getSetting('max_query_size')) AS String)        AS `max_query_size`,
    `p`.`max_threads`                                             AS `joined_threads_const_default`  @notNull @defaultValue("'no match'"),
    `p`.`join_algorithm`                                          AS `joined_join_column_default`    @notNull @defaultValue("concat('default from ', `probe_stage`)"),
    `p`.`who`                                                     AS `joined_who_type_default`       @notNull,
    CAST(`p`.`max_query_size` AS Nullable(String))                AS `joined_mqs_nullable`
FROM {{ ref('TARGET', 'AU_FIRST') }} `f`
LEFT JOIN {{ ref('TARGET', 'AU_FIRST') }} `p`
  ON `p`.`probe_stage` = if(`f`.`probe_stage` = 'load', 'post_sql', 'no match')
