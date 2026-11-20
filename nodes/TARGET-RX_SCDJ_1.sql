@id("b3000000-0000-4000-8000-000000000001")
@nodeType("SQLDimension")
SELECT
    generateUUIDv4() AS `k` @id("c00001") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `c`.`c_custkey` AS `c_custkey` @id("c10001") @isBusinessKey @notNull,
    `o`.`o_comment` AS `o_comment` @id("c20001") @isChangeTracking,
    1 AS `SYSTEM_VERSION` @id("c30001") @isSystemVersion @notNull,
    'Y' AS `SYSTEM_CURRENT_FLAG` @id("c40001") @isSystemCurrentFlag,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE` @id("c50001") @isSystemEndDate,
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_CREATE_DATE` @id("c60001") @isSystemCreateDate,
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_UPDATE_DATE` @id("c70001") @isSystemUpdateDate @notNull
FROM {{ ref('SRC', 'rx_customer') }} `c`
LEFT JOIN {{ ref('SRC', 'rx_orders') }} `o` ON `o`.`o_custkey` = `c`.`c_custkey` + 1000
