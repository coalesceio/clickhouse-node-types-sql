@id("0e1f0a00-0000-4000-8000-000000000309")
@nodeType("SQLDimension")

SELECT
    generateUUIDv4() AS `MIN_KEY` @id("a9d000") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `s`.`cust_id`     AS `cust_id`     @id("a9d001") @isBusinessKey,
    `s`.`city`        AS `city`        @id("a9d003"),
    
    now64(6)                                            AS `SYSTEM_CREATE_DATE`  @id("a9d093") @isSystemCreateDate,
    now64(6)                                            AS `SYSTEM_UPDATE_DATE`  @id("a9d094") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
