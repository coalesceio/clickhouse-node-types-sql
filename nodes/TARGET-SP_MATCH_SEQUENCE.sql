@id("80b598ba-f5ab-547a-80bb-d8a4375c4da0")
@nodeType("SQLWork")
@description("MATCH_RECOGNIZE alternative: sequenceMatch / sequenceCount per user (view then purchase within 1 hour)")
SELECT
    `e`.`user_id`                                                                                   AS `user_id`,
    CAST(sequenceMatch('(?1)(?t<=3600)(?2)')(`e`.`ts`, `e`.`event_type` = 'view', `e`.`event_type` = 'purchase') AS UInt8) AS `view_then_purchase_1h`,
    CAST(sequenceCount('(?1)(?2)')(`e`.`ts`, `e`.`event_type` = 'view', `e`.`event_type` = 'view') AS UInt64) AS `double_views`
FROM {{ ref('SRC', 'sp_events') }} `e`
GROUP BY `e`.`user_id`
