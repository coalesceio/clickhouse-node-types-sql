@id("212f14d4-23f9-5cb4-91f4-7b3e8ad8d68e")
@nodeType("SQLFact")
@engine("MergeTree")
@orderBy("`event_at`", "`event_id`")
@partitionBy("toYYYYMM(`event_at`)")
SELECT
    `e`.`event_id`    AS `event_id`    @id("fa01") @notNull,
    `e`.`contact_id`  AS `contact_id`  @id("fa02") @notNull,
    `e`.`sequence_id` AS `sequence_id` @id("fa03") @notNull,
    `e`.`event_type`  AS `event_type`  @id("fa04"),
    `e`.`event_at`    AS `event_at`    @id("fa05") @notNull
FROM {{ ref('TARGET', 'UG_BRZ_EMAIL_EVENTS') }} `e`
WHERE `e`.`event_at` > (
  SELECT coalesce(max(`event_at`), toDateTime64('1970-01-01 00:00:00', 6))
  FROM {{ this }})
