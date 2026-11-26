@id("0e1f0a00-0000-4000-8000-000000000307")
@nodeType("SQLDimension")
@engine("ReplacingMergeTree")
@optimize
SELECT
    `s`.`cust_id`     AS `cust_id`     @id("a7d001") @isBusinessKey,
    `s`.`cust_name`   AS `cust_name`   @id("a7d002"),
    `s`.`city`        AS `city`        @id("a7d003"),
    `s`.`tier`        AS `tier`        @id("a7d004"),
    `s`.`updated_at`  AS `updated_at`  @id("a7d005"),
    1 AS `SYSTEM_VERSION` @id("a7d090") @isSystemVersion,
    now64(6)                                            AS `SYSTEM_CREATE_DATE`  @id("a7d093") @isSystemCreateDate,
    now64(6)                                            AS `SYSTEM_UPDATE_DATE`  @id("a7d094") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
