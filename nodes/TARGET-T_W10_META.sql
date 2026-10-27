@id("262b15a9-dc2f-42b9-9215-c4b0bdb493ca")
@nodeType("SQLWork")
@preSQL("SELECT 1")
SELECT
     `n_Nationkey` AS `n_Nationkey`,
     `n_Name` AS `n_Name`,
     `n_Regionkey` AS `n_Regionkey`,
     `last_Modified` AS `last_Modified`,
     CAST(NULL AS Nullable(String)) AS `c_nulls` @notNull @defaultValue("'n/a'")
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
