@id("9d4db585-e7b9-5760-b24f-9bb0d13063c1")
@nodeType("SQLFact")
@mergeStrategy("lastModified")
@partitionBy("toYYYYMM(`event_at`)")
@querySettings("max_memory_usage = 40000000000", "max_bytes_in_join = 12000000000")
SELECT
    `e`.`event_id`   AS `event_id`   @id("fe01") @isBusinessKey @notNull,
    coalesce(`dc`.`contact_key`, toUUID('00000000-0000-0000-0000-000000000000'))
                     AS `contact_key` @id("fe02") @notNull,
    `e`.`sequence_id` AS `sequence_id` @id("fe03") @notNull,
    `e`.`event_type` AS `event_type` @id("fe05"),
    `e`.`event_at`   AS `event_at`   @id("fe06") @notNull,
    `e`.`updated_at` AS `updated_at` @id("fe07") @lastModifiedTracking,
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_CREATE_DATE` @id("fe08") @isSystemCreateDate,
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_UPDATE_DATE` @id("fe09") @isSystemUpdateDate @notNull
FROM {{ ref('TARGET', 'UG_BRZ_EMAIL_EVENTS') }} `e`
LEFT JOIN {{ ref('TARGET', 'UG_DIM_CONTACT') }} `dc`
  ON `dc`.`contact_id` = `e`.`contact_id` AND `dc`.`SYSTEM_CURRENT_FLAG` = 'Y'
