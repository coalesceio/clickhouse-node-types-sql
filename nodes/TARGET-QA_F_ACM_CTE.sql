@id("0e1f0a00-0000-4000-8000-000000000407")
@nodeType("SQLFact")
@mergeStrategy("allColumnMatch")
WITH `src` AS (SELECT `order_id`, `line_no`, `qty` FROM {{ ref('TARGET', 'QA_W_SRC_FACT') }})
SELECT
    `order_id`        AS `order_id`    @id("c7e001"),
    `line_no`         AS `line_no`     @id("c7e002"),
    `qty`             AS `qty`         @id("c7e004"),
    now64(6)            AS `SYSTEM_CREATE_DATE` @id("c7e090") @isSystemCreateDate
FROM `src`
