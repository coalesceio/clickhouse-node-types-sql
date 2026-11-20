@id("b1331342-ed07-5f84-99a2-18754dea6d73")
@nodeType("SQLWork")
@materializationType("view")
@final
SELECT
    `n`.`contact_id`  AS `contact_id`,
    `n`.`sequence_id` AS `sequence_id`,
    `n`.`enrolled_at` AS `enrolled_at`
FROM {{ ref('SRC', 'ug_enrollments') }} `n`
WHERE `n`.`_peerdb_is_deleted` = 0
