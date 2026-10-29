@id("b1a00001-0000-4000-8000-000000000002")
@nodeType("SQLWork")
@description("Suppliers (those on order lines with orderkey <= 500, minus every 10th) with nation and region names")
@orderBy("s_suppkey")
WITH `nation_region` AS (
    SELECT `n`.`n_Nationkey`, `n`.`n_Name`, `r`.`r_name`
    FROM {{ ref('SRC', 'Nation_Test') }} `n`
    INNER JOIN {{ ref('SRC', 'region') }} `r` ON `n`.`n_Regionkey` = `r`.`r_regionkey`
)
SELECT
     `s`.`s_suppkey` AS `s_suppkey` @notNull,
     CAST(replaceAll(toString(`s`.`s_name`), '\0', '') AS String) AS `s_name`,
     `s`.`s_address` AS `s_address`,
     `s`.`s_nationkey` AS `s_nationkey`,
     CAST(replaceAll(toString(`nation_region`.`n_Name`), '\0', '') AS String) AS `nation_name`,
     CAST(replaceAll(toString(`nation_region`.`r_name`), '\0', '') AS String) AS `region_name`,
     `s`.`s_acctbal` AS `s_acctbal`
FROM {{ ref('SRC', 'supplier') }} `s`
LEFT JOIN `nation_region` ON `s`.`s_nationkey` = `nation_region`.`n_Nationkey`
WHERE `s`.`s_suppkey` IN (SELECT `l_suppkey` FROM {{ ref('SRC', 'lineitem') }} WHERE `l_orderkey` <= 500)
  AND `s`.`s_suppkey` % 10 != 0