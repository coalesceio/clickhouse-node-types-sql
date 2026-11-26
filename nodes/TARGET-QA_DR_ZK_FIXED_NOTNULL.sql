@id("0e1f0a00-0000-4000-8000-000000000362")
@nodeType("SQLDimension")
@zeroKey("00000000-0000-0000-0000-000000000000", "'TOO_LONG'")
SELECT
    generateUUIDv4() AS `K` @id("f62000") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `s`.`cust_id` AS `cust_id` @id("f62001") @isBusinessKey,
    `s`.`code` AS `code` @id("f62002"),
    now64(6) AS `SYSTEM_CREATE_DATE` @id("f62004") @isSystemCreateDate,
    now64(6) AS `SYSTEM_UPDATE_DATE` @id("f62005") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
