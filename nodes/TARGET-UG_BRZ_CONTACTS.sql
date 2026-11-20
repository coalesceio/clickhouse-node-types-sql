@id("3ab3b7f8-c64d-5fda-a50b-2228807f60b9")
@nodeType("SQLWork")
@materializationType("view")
@final
SELECT
    `c`.`id`                 AS `contact_id`,
    `c`.`email`              AS `email`,
    `c`.`owner_id`           AS `owner_id`,
    `c`.`status`             AS `status`,
    `c`.`updated_at`         AS `updated_at`,
    `c`.`_peerdb_is_deleted` AS `is_deleted`,
    `c`.`_peerdb_version`    AS `cdc_version`
FROM {{ ref('SRC', 'ug_contacts') }} `c`
