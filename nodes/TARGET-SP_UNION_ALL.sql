@id("f11adafd-c232-5005-aa91-58ae102b5931")
@nodeType("SQLWork")
@description("UNION ALL: keeps duplicates")
SELECT `product` AS `product` FROM {{ ref('SRC', 'sp_sales') }} WHERE `region` = 'EU'
UNION ALL
SELECT `product` FROM {{ ref('SRC', 'sp_prices') }}
