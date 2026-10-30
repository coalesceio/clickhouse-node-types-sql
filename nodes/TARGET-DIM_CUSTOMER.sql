@id("b1a00001-0000-4000-8000-000000000011")
@nodeType("SQLDimension")
@description("Customer dimension, SCD Type 2 on address and market segment")
@orderBy("c_custkey", "SYSTEM_VERSION")
SELECT
     generateUUIDv4() AS `customer_key` @id("dc0001") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
     `WRK_CUSTOMER`.`c_custkey` AS `c_custkey` @id("dc0002") @isBusinessKey @notNull ,
     `WRK_CUSTOMER`.`c_name` AS `c_name` @id("dc0003") @description("Name"),
     `WRK_CUSTOMER`.`c_address` AS `c_address` @id("dc0004") ,
     `WRK_CUSTOMER`.`c_mktsegment` AS `c_mktsegment` @id("dc0005"),
     `WRK_CUSTOMER`.`nation_name` AS `nation_name` @id("dc0006"),
     `WRK_CUSTOMER`.`region_name` AS `region_name` @id("dc0007"),
     `WRK_CUSTOMER`.`c_acctbal` AS `c_acctbal` @id("dc0008"),
     1 AS `SYSTEM_VERSION` @id("dcv") @isSystemVersion,
     'Y' AS `SYSTEM_CURRENT_FLAG` @id("dcf") @isSystemCurrentFlag,
     CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE` @id("dce") @isSystemEndDate,
     CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("dcc") @isSystemCreateDate,
     CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("dcu") @isSystemUpdateDate
FROM {{ ref('TARGET', 'WRK_CUSTOMER') }} `WRK_CUSTOMER`
WHERE `WRK_CUSTOMER`.`c_mktsegment` != ''