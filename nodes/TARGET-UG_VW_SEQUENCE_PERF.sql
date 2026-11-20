@id("88ab0a27-b5ac-5023-9d5e-0069d9997505")
@nodeType("SQLWork")
@materializationType("view")
@final
@joinUseNulls
SELECT
    `m`.`sequence_id`                        AS `sequence_id`,
    coalesce(`d`.`sequence_name`, 'UNKNOWN') AS `sequence_name`,
    sum(`m`.`sent`)                          AS `sent`,
    sum(`m`.`replied`)                       AS `replied`,
    round(sum(`m`.`replied`) / nullIf(sum(`m`.`sent`), 0), 4) AS `reply_rate`
FROM {{ ref('TARGET', 'UG_MART_SEQUENCE_DAILY') }} `m`
LEFT JOIN {{ ref('TARGET', 'UG_DIM_SEQUENCE') }} `d`
  ON `d`.`sequence_id` = `m`.`sequence_id`
GROUP BY `m`.`sequence_id`, `d`.`sequence_name`
