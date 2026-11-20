@id("b2000000-0000-4000-8000-0000000000065")
@nodeType("SQLWork")

SELECT
    `c`.`c_custkey` AS `c_custkey`,
    `o`.`o_comment` AS `o_comment` @not_null @empty
FROM {{ ref('SRC', 'rx_customer') }} `c`
LEFT JOIN {{ ref('SRC', 'rx_orders') }} `o` ON `o`.`o_custkey` = `c`.`c_custkey` + 1000
