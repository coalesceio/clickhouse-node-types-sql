@id("3533783b-c41d-5b2e-8466-a569b73a4898")
@nodeType("SQLDimension")
@engine("MergeTree")
@orderBy("`c_custkey`")
SELECT
    generateUUIDv4()                         AS `customer_key`       @id("a10000") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `c_custkey`                              AS `c_custkey`          @id("a10001") @isBusinessKey @notNull,
    `c_name`                                 AS `c_name`             @id("a10002"),
    `c_address`                              AS `c_address`          @id("a10003"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE` @id("a10008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE` @id("a10009") @isSystemUpdateDate
FROM {{ ref('SRC', 'rx_customer') }} `customer`
