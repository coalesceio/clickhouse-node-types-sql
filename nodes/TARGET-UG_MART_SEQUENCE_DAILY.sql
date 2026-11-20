@id("fc653b43-1ba1-5c9d-aaac-3c0122e5da50")
@nodeType("SQLWork")
@writeMode("truncateInsert")
@orderBy("`sequence_id`", "`event_date`")
@partitionBy("toYYYYMM(`event_date`)")
SELECT
    `f`.`sequence_id`                  AS `sequence_id` @notNull,
    toDate(`f`.`event_at`)             AS `event_date`  @notNull,
    countIf(`f`.`event_type` = 'sent')    AS `sent`,
    countIf(`f`.`event_type` = 'opened')  AS `opened`,
    countIf(`f`.`event_type` = 'replied') AS `replied`,
    countIf(`f`.`event_type` = 'bounced') AS `bounced`,
    uniqExact(`f`.`contact_key`)       AS `contacts_touched`
FROM {{ ref('TARGET', 'UG_FCT_EMAIL_EVENTS') }} `f`
GROUP BY `f`.`sequence_id`, toDate(`f`.`event_at`)
