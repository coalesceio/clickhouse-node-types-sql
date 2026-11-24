@id("b3000000-0000-4000-8000-000000000013")
@nodeType("SQLDimension")
SELECT
    generateUUIDv4() AS `k` @id("d0013") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `o`.`o_orderkey` AS `o_orderkey` @id("d1013") @isBusinessKey @notNull,
    `o`.`o_totalprice` AS `o_totalprice` @id("d2013") @notNull @isChangeTracking,
    1 AS `SYSTEM_VERSION` @id("d3013") @isSystemVersion @notNull,
    'Y' AS `SYSTEM_CURRENT_FLAG` @id("d4013") @isSystemCurrentFlag,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE` @id("d5013") @isSystemEndDate,
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_CREATE_DATE` @id("d6013") @isSystemCreateDate,
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_UPDATE_DATE` @id("d7013") @isSystemUpdateDate @notNull
FROM {{ ref('SRC', 'rx_orders') }} `o`
