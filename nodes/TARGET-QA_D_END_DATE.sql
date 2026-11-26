@id("0e1f0a00-0000-4000-8000-00000000030e")
@nodeType("SQLDimension")

SELECT
    generateUUIDv4() AS `QA_D_END_DATE_KEY` @id("b5d000") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `s`.`cust_id`     AS `cust_id`     @id("b5d001") @isBusinessKey,
    `s`.`cust_name`   AS `cust_name`   @id("b5d002"),
    `s`.`city`        AS `city`        @id("b5d003") @isChangeTracking,
    `s`.`tier`        AS `tier`        @id("b5d004"),
    `s`.`updated_at`  AS `updated_at`  @id("b5d005"),
    1                                                   AS `SYSTEM_VERSION`      @id("b5d090") @isSystemVersion,
    'Y'                                                 AS `SYSTEM_CURRENT_FLAG` @id("b5d091") @isSystemCurrentFlag,
    CAST('2149-06-06' AS Date)                        AS `SYSTEM_END_DATE`     @id("b5d092") @isSystemEndDate,
    now64(6)                                            AS `SYSTEM_CREATE_DATE`  @id("b5d093") @isSystemCreateDate,
    now64(6)                                            AS `SYSTEM_UPDATE_DATE`  @id("b5d094") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
