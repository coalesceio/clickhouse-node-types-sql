@id("ce000000-0000-4000-8000-000000000008")
@nodeType("SQLFact")
@mergeStrategy("lastModified")
@tests("SELECT 1 FROM {{ this }} SETTINGS final = 1", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `SYSTEM_CREATE_DATE` < toDateTime('{{ parameters.cutoff | default('2000-01-01 00:00:00') }}') SETTINGS final = 1", true, "After")
WITH `w` AS (SELECT * FROM {{ ref('TARGET', 'CT_WRK') }})
SELECT
    `w`.`cust_id`        AS `cust_id`       @id("c00001") @isBusinessKey,
    `w`.`amount`         AS `amount`        @id("c00002"),
    `w`.`last_Modified`  AS `last_Modified` @id("c00005") @lastModifiedTracking,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("c00008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("c00009") @isSystemUpdateDate @notNull
FROM `w`
