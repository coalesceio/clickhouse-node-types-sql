@id("7aac188e-ad66-524d-ad53-73d9fee9c198")
@nodeType("SQLWork")
@materializationType("view")
@final
SELECT
    `e`.`id`          AS `event_id`,
    `e`.`contact_id`  AS `contact_id`,
    `e`.`sequence_id` AS `sequence_id`,
    `e`.`event_type`  AS `event_type`,
    `e`.`event_at`    AS `event_at`,
    `e`.`updated_at`  AS `updated_at`
FROM {{ ref('SRC', 'ug_email_events') }} `e`
WHERE `e`.`_peerdb_is_deleted` = 0
