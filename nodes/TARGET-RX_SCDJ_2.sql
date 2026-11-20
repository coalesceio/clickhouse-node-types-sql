@id("b3000000-0000-4000-8000-000000000002")
@nodeType("SQLDimension")
SELECT
    generateUUIDv4() AS `k` @id("c00002") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `c`.`c_custkey` AS `c_custkey` @id("c10002") @isBusinessKey @notNull,
    CAST(`o`.`o_comment` AS Nullable(String)) AS `o_comment` @id("c20002") @isChangeTracking,
    1 AS `SYSTEM_VERSION` @id("c30002") @isSystemVersion @notNull,
    'Y' AS `SYSTEM_CURRENT_FLAG` @id("c40002") @isSystemCurrentFlag,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE` @id("c50002") @isSystemEndDate,
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_CREATE_DATE` @id("c60002") @isSystemCreateDate,
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_UPDATE_DATE` @id("c70002") @isSystemUpdateDate @notNull
FROM {{ ref('SRC', 'rx_customer') }} `c`
LEFT JOIN {{ ref('SRC', 'rx_orders') }} `o` ON `o`.`o_custkey` = `c`.`c_custkey` + 1000
