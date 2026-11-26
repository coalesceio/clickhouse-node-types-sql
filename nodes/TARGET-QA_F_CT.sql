@id("0e1f0a00-0000-4000-8000-000000000402")
@nodeType("SQLFact")
@orderBy("`order_id`", "`line_no`")
SELECT
    `f`.`order_id`    AS `order_id`    @id("c2e001") @isBusinessKey,
    `f`.`line_no`     AS `line_no`     @id("c2e002") @isBusinessKey,
    `f`.`cust_id`     AS `cust_id`     @id("c2e003"),
    `f`.`qty`         AS `qty`         @id("c2e004"),
    CAST(`f`.`amount` AS Decimal(18, 4)) AS `amount` @id("c2e005"),
    `f`.`status`      AS `order_status` @id("c2e006"),
    `f`.`amount` * 2  AS `amount_x2`   @id("c2e008"),
    now64(6)            AS `SYSTEM_CREATE_DATE` @id("c2e090") @isSystemCreateDate,
    now64(6)            AS `SYSTEM_UPDATE_DATE` @id("c2e091") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_FACT') }} `f`
