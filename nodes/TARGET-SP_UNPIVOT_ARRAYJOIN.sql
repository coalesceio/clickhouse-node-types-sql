@id("3437b2f9-41d3-599c-a538-ddf1206f65ac")
@nodeType("SQLWork")
@description("Unpivot: wide columns back to rows with ARRAY JOIN over (name, value) tuples")
SELECT
    `p`.`region`                 AS `region`,
    `p`.`sale_month`             AS `sale_month`,
    CAST(`kv`.1 AS String)       AS `product`,
    CAST(`kv`.2 AS Decimal(38, 2)) AS `amount`
FROM {{ ref('TARGET', 'SP_PIVOT_SUMIF') }} `p`
ARRAY JOIN [('A', `p`.`amount_a`), ('B', `p`.`amount_b`), ('C', `p`.`amount_c`)] AS `kv`
