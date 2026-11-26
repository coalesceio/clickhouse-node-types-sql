@id("0e1f0a00-0000-4000-8000-0000000004a1")
@nodeType("SQLDimension")
SELECT
    `s`.`cust_id` AS `cust_id` @id("4a1a01") @isBusinessKey,
    `s`.`city` AS `city` @id("4a1a02"),
    `s`.`tier` AS `city1` @id("4a1a03"),
    now64(6) AS `SYSTEM_CREATE_DATE` @id("4a1a90") @isSystemCreateDate,
    now64(6) AS `SYSTEM_UPDATE_DATE` @id("4a1a91") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
