@id("56ad6457-47ef-54da-9395-9f6f88292fa3")
@nodeType("SQLDimension")
@materializationType("view")
SELECT
    `c_custkey`                              AS `c_custkey`          @id("0a0001"),
    `c_name`                                 AS `c_name`             @id("0a0002")
FROM {{ ref('SRC', 'rx_customer') }} `customer`
