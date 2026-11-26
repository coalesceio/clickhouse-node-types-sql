@id("0e1f0a00-0000-4000-8000-000000000310")
@nodeType("SQLDimension")

SELECT
    generateUUIDv4() AS `QA_D_END_DATETIME_KEY` @id("b7d000") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `s`.`cust_id`     AS `cust_id`     @id("b7d001") @isBusinessKey,
    `s`.`cust_name`   AS `cust_name`   @id("b7d002"),
    `s`.`city`        AS `city`        @id("b7d003") @isChangeTracking,
    `s`.`tier`        AS `tier`        @id("b7d004"),
    `s`.`updated_at`  AS `updated_at`  @id("b7d005"),
    1                                                   AS `SYSTEM_VERSION`      @id("b7d090") @isSystemVersion,
    'Y'                                                 AS `SYSTEM_CURRENT_FLAG` @id("b7d091") @isSystemCurrentFlag,
    CAST('2106-02-07 06:28:15' AS DateTime)           AS `SYSTEM_END_DATE`     @id("b7d092") @isSystemEndDate,
    now64(6)                                            AS `SYSTEM_CREATE_DATE`  @id("b7d093") @isSystemCreateDate,
    now64(6)                                            AS `SYSTEM_UPDATE_DATE`  @id("b7d094") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
