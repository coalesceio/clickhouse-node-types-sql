@id("58105cd2-5e2b-5238-ba50-ee5a909fd92f")
@nodeType("SQLWork")
@materializationType("view")
@final
SELECT
    `s`.`id`         AS `sequence_id`,
    `s`.`name`       AS `sequence_name`,
    `s`.`channel`    AS `channel`,
    `s`.`updated_at` AS `updated_at`
FROM {{ ref('SRC', 'ug_sequences') }} `s`
WHERE `s`.`_peerdb_is_deleted` = 0
