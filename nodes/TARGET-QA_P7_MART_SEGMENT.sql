@id("0e1f0a00-0000-4000-8000-000000000709")
@nodeType("SQLWork")
@description("P7 mart: sales by segment and region")
@orderBy("`segment`", "`region_name`")
@tests("SELECT 1 FROM (SELECT sum(`total_amount`) s FROM {{ this }}) m, (SELECT sum(`amount`) s FROM {{ ref('TARGET', 'QA_P7_FCT_ORDERS') }}) f WHERE m.s != f.s", false, "After")
SELECT
    `v`.`segment`                     AS `segment`      @notNull,
    `v`.`region_name`                 AS `region_name`  @notNull,
    count()                            AS `order_lines`,
    sum(`v`.`amount`)                 AS `total_amount`
FROM {{ ref('TARGET', 'QA_P7_V_SALES') }} `v`
GROUP BY `v`.`segment`, `v`.`region_name`
