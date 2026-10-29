@id("b1a00001-0000-4000-8000-000000000003")
@nodeType("SQLWork")
@description("Parts (those on order lines with orderkey <= 500), de-duplicated")
@orderBy("p_partkey")
SELECT DISTINCT
     `part`.`p_partkey` AS `p_partkey` @notNull,
     `part`.`p_name` AS `p_name`,
     CAST(replaceAll(toString(`part`.`p_mfgr`), '\0', '') AS String) AS `p_mfgr`,
     CAST(replaceAll(toString(`part`.`p_brand`), '\0', '') AS String) AS `p_brand`,
     `part`.`p_type` AS `p_type`,
     `part`.`p_size` AS `p_size`,
     `part`.`p_retailprice` AS `p_retailprice`
FROM {{ ref('SRC', 'part') }} `part`
WHERE `part`.`p_partkey` IN (SELECT `l_partkey` FROM {{ ref('SRC', 'lineitem') }} WHERE `l_orderkey` <= 500)