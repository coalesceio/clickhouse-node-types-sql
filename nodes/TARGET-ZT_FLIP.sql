@id("7f3c2a10-0009-4c1e-9a11-000000000009")
@nodeType("SQLDimension")
@description("Temporary test: nullability flips on redeploy (phase A)")
SELECT
    generateUUIDv4()                                    AS `ZT_KEY`              @id("fl01") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `o`.`emp_id`                                        AS `emp_id`              @id("fl02") @isBusinessKey,
    `o`.`manager_id`                                    AS `c_to_notnull`        @id("fl03") @notNull @defaultValue("0") @isChangeTracking,
    `o`.`manager_id`                                    AS `c_to_nullable`       @id("fl04") @isChangeTracking,
    1                                                   AS `SYSTEM_VERSION`      @id("fl05") @isSystemVersion,
    'Y'                                                 AS `SYSTEM_CURRENT_FLAG` @id("fl06") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS `SYSTEM_CREATE_DATE`  @id("fl07") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS `SYSTEM_UPDATE_DATE`  @id("fl08") @isSystemUpdateDate @notNull,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE`     @id("fl09") @isSystemEndDate
FROM {{ ref('SRC', 'sp_org') }} `o`
