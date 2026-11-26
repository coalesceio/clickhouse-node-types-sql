@id("0e1f0a00-0000-4000-8000-000000000312")
@nodeType("SQLDimension")

SELECT
    `s`.`cust_id`     AS `cust_id`     @id("b9d001") @isBusinessKey @zeroKey("-1"),
    `s`.`city`        AS `city`        @id("b9d003") @zeroKey("'X'"),
    
    now64(6)                                            AS `SYSTEM_CREATE_DATE`  @id("b9d093") @isSystemCreateDate,
    now64(6)                                            AS `SYSTEM_UPDATE_DATE`  @id("b9d094") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
