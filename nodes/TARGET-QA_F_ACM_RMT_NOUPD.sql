@id("0e1f0a00-0000-4000-8000-000000000406")
@nodeType("SQLFact")
@engine("ReplacingMergeTree")
@mergeStrategy("ALLCOLUMNMATCH")
SELECT
    `f`.`order_id`    AS `order_id`    @id("c6e001"),
    `f`.`line_no`     AS `line_no`     @id("c6e002"),
    now64(3)            AS `seen_at`     @id("c6e005")
FROM {{ ref('TARGET', 'QA_W_SRC_FACT') }} `f`
