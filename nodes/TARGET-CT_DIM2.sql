@id("ce000000-0000-4000-8000-000000000004")
@nodeType("SQLDimension")
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'")
@tests("SELECT 1 FROM {{ this }} SETTINGS final = 1", true, "After")
@tests("SELECT 1 FROM {{ this }} WHERE `SYSTEM_CREATE_DATE` < toDateTime('{{ parameters.cutoff | default('2000-01-01 00:00:00') }}') SETTINGS final = 1", true, "After")
WITH `w` AS (SELECT * FROM {{ ref('TARGET', 'CT_WRK') }} WHERE `amount` >= 0)
SELECT
    generateUUIDv4()                AS `CT_DIM2_KEY`  @id("c00000") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    CAST(`w`.`cust_id` AS Int32)    AS `cust_id`      @id("c00001") @isBusinessKey @zeroKey("-1"),
    `w`.`name`                      AS `cust_name` @id("c00002") @isChangeTracking,
    `w`.`region_name`               AS `region_name`  @id("c00003"),
    1                               AS `SYSTEM_VERSION`      @id("c00010") @isSystemVersion,
    'Y'                             AS `SYSTEM_CURRENT_FLAG` @id("c00011") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("c00008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("c00009") @isSystemUpdateDate @notNull,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE` @id("c00012") @isSystemEndDate
FROM `w`
