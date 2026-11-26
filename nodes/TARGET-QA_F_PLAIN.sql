@id("0e1f0a00-0000-4000-8000-000000000401")
@nodeType("SQLFact")
@orderBy("`order_id`", "`line_no`")
SELECT
    `f`.`order_id`    AS `order_id`    @id("c1e001") @isBusinessKey,
    `f`.`line_no`     AS `line_no`     @id("c1e002") @isBusinessKey,
    `f`.`cust_id`     AS `cust_id`     @id("c1e003"),
    `f`.`qty`         AS `qty`         @id("c1e004"),
    `f`.`amount`      AS `amount`      @id("c1e005"),
    `f`.`status`      AS `status`      @id("c1e006"),
    `f`.`updated_at`  AS `updated_at`  @id("c1e007"),
    now64(6)            AS `SYSTEM_CREATE_DATE` @id("c1e090") @isSystemCreateDate,
    now64(6)            AS `SYSTEM_UPDATE_DATE` @id("c1e091") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_FACT') }} `f`
