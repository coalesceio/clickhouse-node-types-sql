@id("8f7e1f39-7c23-49de-9920-41016672462f")
@nodeType("SQLWork")
SELECT * EXCEPT(`c_custkey`)
FROM {{ ref('SRC', 'customer') }} `customer`