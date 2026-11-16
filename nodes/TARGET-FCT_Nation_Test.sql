@id("2f989a55-0c9c-4837-9c7e-1ece4a55dc99")
@nodeType("SQLFact")
@engine("ReplacingMergeTree")
SELECT
    "n_Nationkey"                        AS "n_Nationkey"        @id("8f7590") @isBusinessKey,
    "n_Name"                             AS "n_Name"             @id("84d449"),
    "n_Regionkey"                        AS "n_Regionkey"        @id("1523c2"),
    "n_Comment"                          AS "n_Comment"          @id("51b52a"),
    "last_Modified"                      AS "last_Modified"      @id("b366c8"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS "SYSTEM_CREATE_DATE" @id("259b87") @isSystemCreateDate @notNull,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS "SYSTEM_UPDATE_DATE" @id("ea2402") @isSystemUpdateDate @notNull
FROM {{ ref('SRC', 'Nation_Test') }} "Nation_Test"