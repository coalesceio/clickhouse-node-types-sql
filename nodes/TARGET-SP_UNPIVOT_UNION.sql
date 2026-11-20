@id("60315f03-9b43-5df3-87d7-a765a0f2dcbe")
@nodeType("SQLWork")
@description("Unpivot with UNION ALL, one branch per column")
SELECT `region` AS `region`, `sale_month` AS `sale_month`, 'A' AS `product`, `amount_a` AS `amount` FROM {{ ref('TARGET', 'SP_PIVOT_SUMIF') }}
UNION ALL
SELECT `region`, `sale_month`, 'B', `amount_b` FROM {{ ref('TARGET', 'SP_PIVOT_SUMIF') }}
UNION ALL
SELECT `region`, `sale_month`, 'C', `amount_c` FROM {{ ref('TARGET', 'SP_PIVOT_SUMIF') }}
