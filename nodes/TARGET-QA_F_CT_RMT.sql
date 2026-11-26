@id("0e1f0a00-0000-4000-8000-000000000408")
@nodeType("SQLFact")
@engine("MergeTree")
@orderBy("`order_id`", "`line_no`")
SELECT
    `f`.`order_id`    AS `order_id`    @id("c8e001") @isBusinessKey,
    `f`.`line_no`     AS `line_no`     @id("c8e002") @isBusinessKey,
    `f`.`cust_id`     AS `cust_id`     @id("c8e003"),
    `f`.`qty`         AS `qty`         @id("c8e004"),
    `f`.`amount`      AS `amount`      @id("c8e005"),
    `f`.`status`      AS `status`      @id("c8e006"),
    `f`.`updated_at`  AS `updated_at`  @id("c8e007"),
    now64(6)            AS `SYSTEM_CREATE_DATE` @id("c8e090") @isSystemCreateDate,
    now64(6)            AS `SYSTEM_UPDATE_DATE` @id("c8e091") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_FACT') }} `f`
