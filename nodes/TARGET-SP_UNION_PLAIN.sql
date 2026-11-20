@id("8490d27b-81a8-5abf-868d-3c979d791f32")
@nodeType("SQLWork")
@description("Plain UNION: needs union_default_mode (empty on ClickHouse Cloud), set here for the load")
@querySettings("union_default_mode = 'DISTINCT'")
SELECT `product` AS `product` FROM {{ ref('SRC', 'sp_sales') }}
UNION
SELECT `product` FROM {{ ref('SRC', 'sp_prices') }}
