@id("3c113f89-46d7-4f94-b4aa-718cfa1f9d96")
@nodeType("SQLWork")
SELECT DISTINCT
     `n_Regionkey` AS `n_Regionkey`
FROM {{ ref('SRC2', 'Nation_Test') }} `Nation_Test`
