@id("3b4279fb-3cbf-40fa-8e3b-0bc65ae1bfe7")
@nodeType("SQLWork")
@tests("SELECT 1 FROM {{ this }} WHERE `view_mt` != '5' OR `view_fin` != 'true' OR `view_jun` != 'true' OR `none_mt` != '2' OR `none_fin` != 'false' OR `none_jun` != 'false'", false, "After")
WITH `v` AS (SELECT * FROM {{ ref('TARGET', 'QS_VIEW') }}),
     `n` AS (SELECT * FROM {{ ref('TARGET', 'QS_VIEW_NONE') }} SETTINGS max_threads = 2, final = 0, join_use_nulls = 0)
SELECT
    CAST(`v`.`mt` AS String)  AS `view_mt`,
    CAST(`v`.`fin` AS String) AS `view_fin`,
    CAST(`v`.`jun` AS String) AS `view_jun`,
    CAST(`n`.`mt` AS String)  AS `none_mt`,
    CAST(`n`.`fin` AS String) AS `none_fin`,
    CAST(`n`.`jun` AS String) AS `none_jun`
FROM `v` CROSS JOIN `n`
