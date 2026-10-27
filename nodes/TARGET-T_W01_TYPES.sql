@id("e3b6804c-f88e-4359-a4fa-068c35d064bf")
@nodeType("SQLWork")
@description("Types test: it's quoted")
SELECT
     `n_Nationkey`                                     AS `n_Nationkey`,
     `n_Name`                                          AS `n_Name` @notNull,
     CAST(`n_Regionkey` AS Nullable(UInt32))           AS `c_wrapped` @notNull,
     `n_Comment`                                       AS `n_Comment` @description("Comment with 'quote'"),
     [`n_Regionkey`]                                   AS `c_array`,
     CAST(map('name', toString(`n_Name`)) AS Map(String, String))                AS `c_map`,
     CAST(tuple(`n_Nationkey`, `n_Regionkey`) AS Tuple(UInt32, UInt32))          AS `c_tuple`,
     CAST(toString(`n_Name`) AS LowCardinality(String))                          AS `c_lc_nullable`,
     CAST(toString(`n_Name`) AS LowCardinality(String))                          AS `c_lc_notnull` @notNull,
     CAST(toString(`n_Name`) AS LowCardinality(Nullable(String)))                AS `c_lc_inner_nullable`,
     `n_Regionkey`                                     AS `c_default` @defaultValue("0"),
     `n_Regionkey`                                     AS `c_default2` @defaultValue("5"),
     `last_Modified`                                   AS `last_Modified`
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
