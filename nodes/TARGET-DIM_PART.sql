@id("b1a00001-0000-4000-8000-000000000013")
@nodeType("SQLDimension")
@description("Part dimension, SCD Type 1")
@orderBy("p_partkey")
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'", "1900-01-01 00:00:00", true)
SELECT
     generateUUIDv4() AS `part_key` @id("dp0001") @isSurrogateKey @defaultValue("generateUUIDv4()"),
     `WRK_PART`.`p_partkey` AS `p_partkey` @id("dp0002") @isBusinessKey,
     `WRK_PART`.`p_name` AS `p_name` @id("dp0003"),
     `WRK_PART`.`p_mfgr` AS `p_mfgr` @id("dp0004"),
     `WRK_PART`.`p_brand` AS `p_brand` @id("dp0005"),
     `WRK_PART`.`p_type` AS `p_type` @id("dp0006"),
     `WRK_PART`.`p_size` AS `p_size` @id("dp0007"),
     `WRK_PART`.`p_retailprice` AS `p_retailprice` @id("dp0008"),
     1 AS `SYSTEM_VERSION` @id("dpv") @isSystemVersion,
     'Y' AS `SYSTEM_CURRENT_FLAG` @id("dpf") @isSystemCurrentFlag,
     CAST('2999-12-31 00:00:00' AS TIMESTAMP) AS `SYSTEM_END_DATE` @id("dpe") @isSystemEndDate,
     CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("dpc") @isSystemCreateDate,
     CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("dpu") @isSystemUpdateDate
FROM {{ ref('TARGET', 'WRK_PART') }} `WRK_PART`
WHERE `WRK_PART`.`p_size` > 0