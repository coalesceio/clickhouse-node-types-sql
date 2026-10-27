@id("7fa00669-51ae-495f-b669-82d55cfee9c3")
@nodeType("SQLWork")
@partitionBy("n_Regionkey", "toYear(`last_Modified`)")
@orderBy("n_Nationkey")
@settings("merge_with_ttl_timeout = 7200")
SELECT
     `n_Nationkey` AS `n_Nationkey`,
     `n_Name` AS `n_Name`,
     `n_Regionkey` AS `n_Regionkey`,
     `last_Modified` AS `last_Modified`
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
