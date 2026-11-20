@id("ed706924-764d-5b3b-97d4-51419d7a7044")
@nodeType("SQLDimension")
@engine("MergeTree")
@mergeStrategy("changeTracking")
@tests("SELECT `n_Nationkey`, `n_Name` FROM {{ ref('SRC', 'Nation_Test') }} GROUP BY `n_Nationkey`, `n_Name` HAVING count() > 1 OR `n_Nationkey` IS NULL OR `n_Name` IS NULL", false, "Before")  -- runs Before the load, continueOnFailure=false
SELECT
    generateUUIDv4()                         AS `DIM_NATION_KEY`     @id("a1b2c3") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `n_Nationkey`                            AS `n_Nationkey`        @id("b2c3d4") @isBusinessKey,
    `n_Name`                                 AS `n_Name`             @id("c3d4e5") @isBusinessKey,
    `n_Regionkey`                            AS `n_Regionkey`        @id("d4e5f6"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE` @id("e5f6a7") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE` @id("f6a7b8") @isSystemUpdateDate
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
