@id("0e1f0a00-0000-4000-8000-000000000370")
@nodeType("SQLDimension")
@zeroKey("00000000-0000-0000-0000-000000000000")
SELECT
    generateUUIDv4()                                                        AS `K`        @id("70a000") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `s`.`cust_id`                                                           AS `cust_id`  @id("70a001") @isBusinessKey @zeroKey("999999"),
    CAST([`s`.`cust_id`] AS Array(UInt32))                                  AS `arr`      @id("70a002"),
    CAST(tuple(`s`.`cust_id`, `s`.`city`) AS Tuple(UInt32, String))         AS `tup`      @id("70a003"),
    CAST(map(`s`.`city`, toUInt8(1)) AS Map(String, UInt8))                 AS `mp`       @id("70a004"),
    CAST(if(`s`.`tier` = 'GOLD', 'gold', 'other') AS Enum8('gold' = 1, 'other' = 2)) AS `en` @id("70a005"),
    CAST('10.0.0.1' AS IPv4)                                                AS `ip`       @id("70a006"),
    CAST('12:00:00' AS Time)                                                AS `tm`       @id("70a007"),
    `s`.`cust_name`                                                         AS `nm`       @id("70a008"),
    CAST(if(`s`.`tier` = 'GOLD', 'gold', NULL) AS Nullable(Enum8('gold' = 1, 'other' = 2))) AS `en_null` @id("70a009"),
    now64(6)                                                                AS `SYSTEM_CREATE_DATE` @id("70a090") @isSystemCreateDate,
    now64(6)                                                                AS `SYSTEM_UPDATE_DATE` @id("70a091") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
