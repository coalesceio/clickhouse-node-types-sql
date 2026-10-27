@id("a8e99263-3816-45e8-8d7a-93ad36babfe8")
@nodeType("SQLWork")
@orderBy("n_Nationkey")
WITH `nation_src` AS (
    SELECT
        `n_Nationkey`,
        `n_Name`,
        `n_Regionkey`
    FROM {{ ref('SRC2', 'Nation_Test') }}
    WHERE `n_Nationkey` IS NOT NULL
)
SELECT
     `nation_src`.`n_Nationkey` AS `n_Nationkey` @notNull,
     `nation_src`.`n_Name` AS `n_Name`,
     `nation_src`.`n_Regionkey` AS `n_Regionkey`
FROM `nation_src`
