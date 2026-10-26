@id("38bb4ce0-b576-4f7e-a105-b45cbe8f8e33")
@nodeType("SQLWork")
SELECT
     `n_Nationkey` AS `n_Nationkey`,
     `n_Name` AS `n_Name`,
     `n_Regionkey` AS `n_Regionkey`,
     `n_Comment` AS `n_Comment`,
     `last_Modified` AS `last_Modified`
FROM {{ ref('TARGET', 'Nation_Test') }} `Nation_Test`