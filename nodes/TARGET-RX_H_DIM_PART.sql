@id("5dd9ca1d-b098-5695-944f-26c8607ac006")
@nodeType("SQLWork")
SELECT generateUUIDv4() AS `part_key`, `ps_partkey` AS `p_partkey`
FROM {{ ref('SRC', 'rx_partsupp') }} `p` WHERE `ps_suppkey` = 1
