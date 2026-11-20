@id("30a5c74d-22eb-5478-857d-c9a9270e0c43")
@nodeType("SQLWork")
SELECT generateUUIDv4() AS `customer_key`, `c_custkey` AS `c_custkey`, 'Y' AS `SYSTEM_CURRENT_FLAG`, concat('Region ', toString(`c_custkey` % 4)) AS `region_name`, `c_mktsegment` AS `c_mktsegment`
FROM {{ ref('SRC', 'rx_customer') }} `c`
