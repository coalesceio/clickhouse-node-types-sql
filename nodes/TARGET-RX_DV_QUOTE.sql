@id("b5000000-0000-4000-8000-000000000001")
@nodeType("SQLWork")
SELECT
    CAST(concat('stage of ', `f`.`probe_stage`) AS String) AS `probe_stage`,
    `p`.`who` AS `dv_backtick` @notNull @defaultValue("`probe_stage`"),
    `p`.`who` AS `dv_single`   @notNull @defaultValue("'probe_stage'"),
    `p`.`who` AS `dv_bare`     @notNull @defaultValue("probe_stage")
FROM {{ ref('TARGET', 'AU_FIRST') }} `f`
LEFT JOIN {{ ref('TARGET', 'AU_FIRST') }} `p`
  ON `p`.`probe_stage` = if(`f`.`probe_stage` = 'load', 'post_sql', 'no match')
