@id("ce000000-0000-4000-8000-000000000003")
@nodeType("SQLDimension")
@settings("min_bytes_for_wide_part = 10485760")
@tests("SELECT 1 FROM system.tables WHERE database = 'WORKSPACE_TANVI_QA' AND name = 'CT_DIM1' AND engine_full LIKE '%min_bytes_for_wide_part = 0%'", true, "After")
@tests("SELECT 1 FROM system.tables WHERE database = 'WORKSPACE_TANVI_QA' AND name = 'CT_DIM1' AND engine_full LIKE '%merge_with_ttl_timeout = 3600%'", true, "After")
@tests("SELECT 1 FROM system.tables WHERE database = 'WORKSPACE_TANVI_QA' AND name = 'CT_DIM1' AND engine_full LIKE '%min_bytes_for_wide_part = 10485760%'", true, "After")
@tests("SELECT 1 FROM system.tables WHERE database = 'WORKSPACE_TANVI_QA' AND name = 'CT_DIM1' AND engine_full LIKE '%allow_nullable_key = 1%'", true, "After")
@tests("SELECT 1 FROM system.tables WHERE database = 'WORKSPACE_TANVI_QA' AND name = 'CT_DIM1' AND engine_full LIKE '%ReplacingMergeTree%'", true, "After")
@tests("SELECT 1 FROM {{ this }} SETTINGS final = 1", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `SYSTEM_CREATE_DATE` < toDateTime('{{ parameters.cutoff | default('2000-01-01 00:00:00') }}') SETTINGS final = 1", true, "After")
WITH `w` AS (SELECT * FROM {{ ref('TARGET', 'CT_WRK') }})
SELECT
    generateUUIDv4()     AS `CT_DIM1_KEY` @id("c00000") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `w`.`cust_id`        AS `cust_id`     @id("c00001") @isBusinessKey,
    `w`.`name`           AS `name`        @id("c00002"),
    `w`.`region_name`    AS `region_name` @id("c00003"),
    `w`.`segment`        AS `segment`     @id("c00004"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("c00008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("c00009") @isSystemUpdateDate @notNull
FROM `w`
