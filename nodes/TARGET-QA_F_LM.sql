@id("0e1f0a00-0000-4000-8000-000000000403")
@nodeType("SQLFact")
@materializationType("view")
@mergeStrategy("lastModified")
SELECT
    `f`.`order_id`    AS `order_id`    @id("c3e001") @isBusinessKey,
    `f`.`line_no`     AS `line_no`     @id("c3e002") @isBusinessKey,
    `f`.`cust_id`     AS `cust_id`     @id("c3e003"),
    `f`.`qty`         AS `qty`         @id("c3e004"),
    `f`.`amount`      AS `amount`      @id("c3e005"),
    `f`.`status`      AS `status`      @id("c3e006"),
    `f`.`updated_at`  AS `updated_at`  @id("c3e007") @lastModifiedTracking,
    now64(6)            AS `SYSTEM_CREATE_DATE` @id("c3e090") @isSystemCreateDate,
    now64(6)            AS `SYSTEM_UPDATE_DATE` @id("c3e091") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_FACT') }} `f`
