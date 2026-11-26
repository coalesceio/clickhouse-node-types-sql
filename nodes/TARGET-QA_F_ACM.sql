@id("0e1f0a00-0000-4000-8000-000000000404")
@nodeType("SQLFact")
@mergeStrategy("allColumnMatch")
@orderBy("`order_id`", "`line_no`")
SELECT
    `f`.`order_id`    AS `order_id`    @id("c4e001"),
    `f`.`line_no`     AS `line_no`     @id("c4e002"),
    `f`.`cust_id`     AS `cust_id`     @id("c4e003"),
    `f`.`qty`         AS `qty`         @id("c4e004"),
    now64(3)            AS `seen_at`     @id("c4e005"),
    'batch-1'           AS `batch`       @id("c4e006"),
    now64(6)            AS `SYSTEM_CREATE_DATE` @id("c4e090") @isSystemCreateDate
FROM {{ ref('TARGET', 'QA_W_SRC_FACT') }} `f`
