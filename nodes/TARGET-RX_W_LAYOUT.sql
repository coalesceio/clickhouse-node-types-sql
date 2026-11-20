@id("62a9526d-53c5-560b-829d-60c2671c0b64")
@nodeType("SQLWork")
@orderBy("`n_Nationkey`", "`n_Name`")
@primaryKey("`n_Nationkey`")
@partitionBy("toYYYYMM(`last_Modified`)")
@settings("index_granularity = 8192")
@description("Nation work table")
SELECT
    `n_Nationkey`    AS `n_Nationkey`    @notNull,
    `n_Name`         AS `n_Name`         @description("Nation name"),
    `last_Modified`  AS `last_Modified`
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
