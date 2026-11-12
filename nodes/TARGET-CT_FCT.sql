@id("ce000000-0000-4000-8000-000000000006")
@nodeType("SQLFact")
@tests("SELECT 1 FROM {{ this }} SETTINGS final = 1", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `SYSTEM_CREATE_DATE` < toDateTime('{{ parameters.cutoff | default('2000-01-01 00:00:00') }}') SETTINGS final = 1", true, "After")
WITH `w` AS (SELECT * FROM {{ ref('TARGET', 'CT_WRK') }}),
`d` AS (SELECT `CT_DIM2_KEY`, CAST(`cust_id` AS UInt32) AS `cust_id`, `cust_name` FROM {{ ref('TARGET', 'CT_DIM2') }} FINAL WHERE `SYSTEM_CURRENT_FLAG` = 'Y')
SELECT
    `w`.`cust_id`                                                                  AS `cust_id` @id("c00001") @isBusinessKey,
    ifNull(`d`.`CT_DIM2_KEY`, toUUID('00000000-0000-0000-0000-000000000000'))    AS `dim_key` @id("c00006"),
    CAST(`d`.`cust_name` AS String)                                               AS `dim_name` @id("c00007"),
    CAST(`w`.`amount` AS Decimal(12, 2))                                                                   AS `amount`  @id("c00002"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("c00008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("c00009") @isSystemUpdateDate @notNull
FROM `w`
LEFT JOIN `d` ON `w`.`cust_id` = `d`.`cust_id`
