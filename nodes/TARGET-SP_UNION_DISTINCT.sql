@id("ad5fc1d4-ca22-5b8a-adcd-1e3054d2db0a")
@nodeType("SQLWork")
@description("UNION DISTINCT: removes duplicates")
SELECT `product` AS `product` FROM {{ ref('SRC', 'sp_sales') }}
UNION DISTINCT
SELECT `product` FROM {{ ref('SRC', 'sp_prices') }}
