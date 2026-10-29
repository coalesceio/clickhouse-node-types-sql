@id("b1a00001-0000-4000-8000-000000000001")
@nodeType("SQLWork")
@description("Customers (those on orders with orderkey <= 500) with nation and region names")
@orderBy("c_custkey")
WITH `nation_region` AS (
    SELECT `n`.`n_Nationkey`, `n`.`n_Name`, `r`.`r_name`
    FROM {{ ref('SRC', 'Nation_Test') }} `n`
    INNER JOIN {{ ref('SRC', 'region') }} `r` ON `n`.`n_Regionkey` = `r`.`r_regionkey`
)
SELECT
     `c`.`c_custkey` AS `c_custkey` @notNull,
     `c`.`c_name` AS `c_name`,
     `c`.`c_address` AS `c_address`,
     `c`.`c_nationkey` AS `c_nationkey`,
     CAST(replaceAll(toString(`nation_region`.`n_Name`), '\0', '') AS String) AS `nation_name`,
     CAST(replaceAll(toString(`nation_region`.`r_name`), '\0', '') AS String) AS `region_name`,
     CAST(replaceAll(toString(`c`.`c_mktsegment`), '\0', '') AS String) AS `c_mktsegment`,
     `c`.`c_acctbal` AS `c_acctbal`
FROM {{ ref('SRC', 'customer') }} `c`
LEFT JOIN `nation_region` ON `c`.`c_nationkey` = `nation_region`.`n_Nationkey`
WHERE `c`.`c_custkey` IN (SELECT `o_custkey` FROM {{ ref('SRC', 'orders') }} WHERE `o_orderkey` <= 500)