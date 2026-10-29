@id("b1a00001-0000-4000-8000-000000000012")
@nodeType("SQLDimension")
@description("Supplier dimension, SCD Type 1")
@orderBy("s_suppkey")
@zeroKey(0, "'UNKNOWN'", "1900-01-01 00:00:00", false)
SELECT
     generateUUIDv4() AS `supplier_key` @id("ds0001") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
     `WRK_SUPPLIER`.`s_suppkey` AS `s_suppkey` @id("ds0002") @isBusinessKey,
     `WRK_SUPPLIER`.`s_name` AS `s_name` @id("ds0003"),
     `WRK_SUPPLIER`.`s_address` AS `s_address` @id("ds0004"),
     `WRK_SUPPLIER`.`nation_name` AS `nation_name` @id("ds0005"),
     `WRK_SUPPLIER`.`region_name` AS `region_name` @id("ds0006"),
     `WRK_SUPPLIER`.`s_acctbal` AS `s_acctbal` @id("ds0007"),
     1 AS `SYSTEM_VERSION` @id("dsv") @isSystemVersion,
     'Y' AS `SYSTEM_CURRENT_FLAG` @id("dsf") @isSystemCurrentFlag,
     CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE` @id("dse") @isSystemEndDate,
     CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("dsc") @isSystemCreateDate,
     CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("dsu") @isSystemUpdateDate
FROM {{ ref('TARGET', 'WRK_SUPPLIER') }} `WRK_SUPPLIER`
WHERE `WRK_SUPPLIER`.`s_acctbal` IS NOT NULL