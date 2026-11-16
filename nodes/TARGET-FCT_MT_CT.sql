@id("0bb03ec2-77cb-49f3-b4ce-44fc47322346")
@nodeType("SQLFact")
@engine("MergeTree")
@mergeStrategy("allColumnMatch")
SELECT
    "n_Nationkey"                        AS "n_Nationkey"        @id("64aab4"),
    "n_Name"                             AS "n_Name"             @id("af8b9f"),
    "n_Regionkey"                        AS "n_Regionkey"        @id("a95706"),
    "n_Comment"                          AS "n_Comment"          @id("cb1c25"),
    "last_Modified"                      AS "last_Modified"      @id("7c347b"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS "SYSTEM_CREATE_DATE" @id("fe93c9") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS "SYSTEM_UPDATE_DATE" @id("5aff1c") @isSystemUpdateDate @notNull
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
