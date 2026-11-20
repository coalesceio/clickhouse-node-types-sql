@id("b3000000-0000-4000-8000-000000000012")
@nodeType("SQLDimension")
SELECT
    generateUUIDv4() AS `k` @id("d012") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `c`.`c_custkey` AS `c_custkey` @id("d112") @isBusinessKey @notNull,
    `o`.`o_comment` AS `o_comment` @notNull @defaultValue("concat('x', toString(`c_custkey`))") @id("d212") @isChangeTracking,
    1 AS `SYSTEM_VERSION` @id("d312") @isSystemVersion @notNull,
    'Y' AS `SYSTEM_CURRENT_FLAG` @id("d412") @isSystemCurrentFlag,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE` @id("d512") @isSystemEndDate,
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_CREATE_DATE` @id("d612") @isSystemCreateDate,
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_UPDATE_DATE` @id("d712") @isSystemUpdateDate @notNull
FROM {{ ref('SRC', 'rx_customer') }} `c`
LEFT JOIN {{ ref('SRC', 'rx_orders') }} `o` ON `o`.`o_custkey` = `c`.`c_custkey` + 1000
