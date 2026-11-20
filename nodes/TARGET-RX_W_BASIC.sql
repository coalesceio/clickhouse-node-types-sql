@id("7eb148af-92c0-5352-9151-b83bfbe21d97")
@nodeType("SQLWork")
@orderBy("`o_orderkey`")
SELECT
    `o_orderkey`                                           AS `o_orderkey`      @notNull,
    `o_custkey`                                            AS `o_custkey`,
    upper(`o_orderstatus`)                                 AS `o_orderstatus`,
    coalesce(`o_totalprice`, 0)                            AS `o_totalprice`,
    CAST(replaceAll(toString(`o_comment`), '\0', '') AS String) AS `o_comment`,
    `o_orderdate`                                          AS `o_orderdate`
FROM {{ ref('SRC', 'rx_orders') }} `orders`
WHERE `o_orderstatus` != 'F'
