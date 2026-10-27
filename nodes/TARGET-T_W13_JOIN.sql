@id("0f9ce892-2152-483b-9022-51ec9ef9a2da")
@nodeType("SQLWork")
@orderBy("n_Nationkey")
SELECT
     `Nation_Test`.`n_Nationkey` AS `n_Nationkey` @notNull,
     `Nation_Test`.`n_Name` AS `n_Name`,
     `T_W02_ORDER`.`n_Name` AS `w02_Name`,
     `T_W02_ORDER`.`last_Modified` AS `w02_last_Modified`
FROM {{ ref('SRC2', 'Nation_Test') }} `Nation_Test`
LEFT JOIN {{ ref('TARGET', 'T_W02_ORDER') }} `T_W02_ORDER`
    ON `Nation_Test`.`n_Nationkey` = `T_W02_ORDER`.`n_Nationkey`
