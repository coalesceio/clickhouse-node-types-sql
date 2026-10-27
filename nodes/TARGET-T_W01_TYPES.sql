@id("e3b6804c-f88e-4359-a4fa-068c35d064bf")
@nodeType("SQLWork")
@materializationType("view")
@description("Types test v2")
SELECT
     CAST(`n_Nationkey` AS UInt64)                                               AS `n_Nationkey`,
     `n_Name`                                                                    AS `n_Name` @notNull,
     CAST(`n_Regionkey` AS Nullable(UInt32))                                     AS `c_wrapped` @notNull,
     `n_Comment`                                                                 AS `n_Comment` @notNull @defaultValue("'n/a'") @description("Comment changed"),
     [`n_Regionkey`]                                                             AS `c_array` @notNull,
     CAST(map('name', toString(`n_Name`)) AS Map(String, String))                AS `c_map` @notNull,
     CAST(toString(`n_Name`) AS LowCardinality(String))                          AS `c_lc_nullable`,
     CAST(toString(`n_Name`) AS LowCardinality(String))                          AS `c_lc_notnull` @notNull,
     CAST(toString(`n_Name`) AS LowCardinality(Nullable(String)))                AS `c_lc_inner_nullable`,
     `n_Regionkey`                                                               AS `c_default` @defaultValue("1"),
     `n_Regionkey`                                                               AS `c_default2`,
     `last_Modified`                                                             AS `last_Modified` @notNull,
     `n_Regionkey` + 1                                                           AS `c_new_plain`,
     now64(3)                                                                    AS `c_new_default` @defaultValue("now64(3)")
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
