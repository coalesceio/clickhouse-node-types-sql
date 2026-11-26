@id("0e1f0a00-0000-4000-8000-00000000040c")
@nodeType("SQLFact")

SELECT
    `f`.`order_id`    AS `order_id`    @id("cce001"),
    `f`.`line_no`     AS `line_no`     @id("cce002"),
    `f`.`cust_id`     AS `cust_id`     @id("cce003"),
    `f`.`qty`         AS `qty`         @id("cce004"),
    `f`.`amount`      AS `amount`      @id("cce005"),
    `f`.`status`      AS `status`      @id("cce006"),
    `f`.`updated_at`  AS `updated_at`  @id("cce007") @lastModifiedTracking,
    now64(6)            AS `SYSTEM_CREATE_DATE` @id("cce090") @isSystemCreateDate
FROM {{ ref('TARGET', 'QA_W_SRC_FACT') }} `f`
