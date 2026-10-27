@id("d6a6e257-66bd-4927-b3d4-53c9789aeb9b")
@nodeType("SQLWork")
@materializationType("view")
@description("View renamed, description changed")
SELECT
     `n_Nationkey` AS `n_Nationkey`,
     `n_Name` AS `n_Name`
FROM {{ ref('SRC2', 'Nation_Test') }} `Nation_Test`
