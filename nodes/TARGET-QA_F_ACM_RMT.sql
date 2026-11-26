@id("0e1f0a00-0000-4000-8000-000000000405")
@nodeType("SQLFact")
@engine("ReplacingMergeTree")
@mergeStrategy("allColumnMatch")
SELECT
    `f`.`order_id`    AS `order_id`    @id("c5e001"),
    `f`.`line_no`     AS `line_no`     @id("c5e002"),
    `f`.`qty`         AS `qty`         @id("c5e004"),
    `f`.`cust_id`     AS `cust_id`     @id("c5e003"),
    now64(6)            AS `SYSTEM_CREATE_DATE` @id("c5e090") @isSystemCreateDate,
    now64(6)            AS `SYSTEM_UPDATE_DATE` @id("c5e091") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_FACT') }} `f`
