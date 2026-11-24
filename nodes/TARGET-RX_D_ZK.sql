@id("e43f4db3-5d56-595a-8abb-235d9c442893")
@nodeType("SQLDimension")
@engine("MergeTree")
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'", "1900-01-01 00:00:00", true)
@orderBy("`c_custkey`")
SELECT
    generateUUIDv4()                         AS `customer_key`       @id("f10000") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `c_custkey`                              AS `c_custkey`          @id("f10001") @isBusinessKey,
    `c_name`                                 AS `c_name`             @id("f10002") @zeroKey("'N/A'"),
    `c_mktsegment`                           AS `c_mktsegment`       @id("f10003"),
    now64(6)                                 AS `SYSTEM_CREATE_DATE` @id("f10008") @isSystemCreateDate,
    now64(6)                                 AS `SYSTEM_UPDATE_DATE` @id("f10009") @isSystemUpdateDate
FROM {{ ref('SRC', 'rx_customer') }} `customer`
