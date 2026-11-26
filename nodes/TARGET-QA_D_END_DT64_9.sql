@id("0e1f0a00-0000-4000-8000-00000000030f")
@nodeType("SQLDimension")

SELECT
    generateUUIDv4() AS `QA_D_END_DT64_9_KEY` @id("b6d000") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `s`.`cust_id`     AS `cust_id`     @id("b6d001") @isBusinessKey,
    `s`.`cust_name`   AS `cust_name`   @id("b6d002"),
    `s`.`city`        AS `city`        @id("b6d003") @isChangeTracking,
    `s`.`tier`        AS `tier`        @id("b6d004"),
    `s`.`updated_at`  AS `updated_at`  @id("b6d005"),
    1                                                   AS `SYSTEM_VERSION`      @id("b6d090") @isSystemVersion,
    'Y'                                                 AS `SYSTEM_CURRENT_FLAG` @id("b6d091") @isSystemCurrentFlag,
    CAST('2262-04-11 00:00:00' AS DateTime64(9))      AS `SYSTEM_END_DATE`     @id("b6d092") @isSystemEndDate,
    now64(6)                                            AS `SYSTEM_CREATE_DATE`  @id("b6d093") @isSystemCreateDate,
    now64(6)                                            AS `SYSTEM_UPDATE_DATE`  @id("b6d094") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
