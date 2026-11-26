@id("0e1f0a00-0000-4000-8000-00000000040b")
@nodeType("SQLFact")
@mergeStrategy("allColumnMatch")
SELECT
    `f`.`order_id`    AS `order_id`    @id("cbe001") @isBusinessKey,
    `f`.`line_no`     AS `line_no`     @id("cbe002") @isBusinessKey,
    `f`.`cust_id`     AS `cust_id`     @id("cbe003"),
    `f`.`qty`         AS `qty`         @id("cbe004"),
    `f`.`amount`      AS `amount`      @id("cbe005"),
    `f`.`status`      AS `status`      @id("cbe006"),
    `f`.`updated_at`  AS `updated_at`  @id("cbe007") @lastModifiedTracking,
    now64(6)            AS `SYSTEM_CREATE_DATE` @id("cbe090") @isSystemCreateDate
FROM {{ ref('TARGET', 'QA_W_SRC_FACT') }} `f`
