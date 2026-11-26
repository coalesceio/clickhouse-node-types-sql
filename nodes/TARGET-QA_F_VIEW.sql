@id("0e1f0a00-0000-4000-8000-00000000040a")
@nodeType("SQLFact")
@description("fact as a view")
SELECT
    `f`.`order_id`    AS `order_id`    @id("cae001") @isBusinessKey,
    `f`.`line_no`     AS `line_no`     @id("cae002") @isBusinessKey,
    `f`.`cust_id`     AS `cust_id`     @id("cae003"),
    `f`.`qty`         AS `qty`         @id("cae004"),
    `f`.`amount`      AS `amount`      @id("cae005"),
    `f`.`status`      AS `status`      @id("cae006"),
    `f`.`updated_at`  AS `updated_at`  @id("cae007"),
    now64(6)            AS `SYSTEM_CREATE_DATE` @id("cae090") @isSystemCreateDate,
    now64(6)            AS `SYSTEM_UPDATE_DATE` @id("cae091") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_FACT') }} `f`
