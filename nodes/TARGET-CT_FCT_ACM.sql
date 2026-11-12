@id("ce000000-0000-4000-8000-000000000007")
@nodeType("SQLFact")
@engine("MergeTree")
@mergeStrategy("allColumnMatch")
@optimize
@tests("SELECT 1 FROM {{ this }} SETTINGS final = 1", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `SYSTEM_CREATE_DATE` < toDateTime('{{ parameters.cutoff | default('2000-01-01 00:00:00') }}') SETTINGS final = 1", true, "After")
WITH `w` AS (SELECT DISTINCT `region_name` FROM {{ ref('TARGET', 'CT_WRK') }})
SELECT
    `w`.`region_name`    AS `region_name` @id("c00003"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("c00008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("c00009") @isSystemUpdateDate @notNull
FROM `w`
