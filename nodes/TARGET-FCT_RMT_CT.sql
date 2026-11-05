@id("d17d1069-1964-4b4e-acd5-98f1026471b2")
@nodeType("SQLFact")
SELECT
    "n_Nationkey"                        AS "n_Nationkey"        @id("64aab4") @isBusinessKey,
    "n_Name"                             AS "n_Name"             @id("af8b9f"),
    "n_Regionkey"                        AS "n_Regionkey"        @id("a95706"),
    "n_Comment"                          AS "n_Comment"          @id("cb1c25"),
    "last_Modified"                      AS "last_Modified"      @id("7c347b"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS "SYSTEM_CREATE_DATE" @id("fe93c9") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS "SYSTEM_UPDATE_DATE" @id("5aff1c") @isSystemUpdateDate @notNull
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
