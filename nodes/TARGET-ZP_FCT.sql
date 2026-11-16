@id("0c964f58-02b1-426e-a792-3cf54262b608")
@nodeType("SQLFact")
@optimize
@final
@partitionBy("`n_Regionkey`")
@tests("SELECT 1 FROM {{ this }} SETTINGS final = 0", true, "After")
@tests("SELECT 1 FROM {{ this }} FINAL", true, "After")
@tests("SELECT `n_Nationkey` FROM {{ this }} FINAL GROUP BY `n_Nationkey` HAVING count() > 1", true, "After")
@tests("SELECT `n_Nationkey` FROM {{ this }} GROUP BY `n_Nationkey` HAVING count() > 1 SETTINGS final = 0", true, "After")
@tests("SELECT 1 FROM {{ this }} FINAL WHERE `n_Nationkey` = 1 AND `n_Regionkey` = {{ parameters.test_ver | default(1) }} % 2", true, "After")
SELECT
    "n_Nationkey"                   AS "n_Nationkey"        @id("426478") @isBusinessKey,
    "n_Name"                        AS "n_Name"             @id("434bba"),
    "n_Regionkey"                   AS "n_Regionkey"        @id("09a2d4"),
    CAST(now64(6) AS DateTime64(6)) AS "SYSTEM_CREATE_DATE" @id("f6f3e5") @isSystemCreateDate,
    CAST(now64(6) AS DateTime64(6)) AS "SYSTEM_UPDATE_DATE" @id("cb7bfc") @isSystemUpdateDate @notNull
FROM {{ ref('TARGET', 'ZP_SRC') }} `ZP_SRC`
