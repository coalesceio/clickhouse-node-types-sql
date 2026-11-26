@id("0e1f0a00-0000-4000-8000-000000000363")
@nodeType("SQLDimension")
@zeroKey("0")
SELECT
    toUInt64(`s`.`cust_id`) AS `K` @id("f63000") @isSurrogateKey @defaultValue("rand64()"),
    `s`.`cust_id` AS `cust_id` @id("f63001") @isBusinessKey @zeroKey("0"),
    CAST(map(`s`.`city`, 1) AS Map(String, UInt8)) AS `m` @id("f63002"),
    CAST(tuple(`s`.`cust_id`, `s`.`city`) AS Tuple(UInt32, String)) AS `t` @id("f63003"),
    now64(6) AS `SYSTEM_CREATE_DATE` @id("f63004") @isSystemCreateDate,
    now64(6) AS `SYSTEM_UPDATE_DATE` @id("f63005") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
