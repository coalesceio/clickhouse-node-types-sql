@id("b4000000-0000-4000-8000-000000000001")
@nodeType("SQLWork")
SELECT
    `o`.`o_orderkey`   AS `o_orderkey`,
    `o`.`o_custkey`    AS `o_custkey`,
    `o`.`o_comment`    AS `o_comment`,
    `o`.`o_totalprice` AS `o_totalprice`  @notNull @defaultValue("`o_custkey` * 10"),
    `o`.`o_comment`    AS `comment_copy`  @notNull @defaultValue("concat('from ', `o_comment`)")
FROM {{ ref('SRC', 'rx_orders') }} `o`
