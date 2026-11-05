@id("ddbef192-9323-41a8-8db6-b5b8f127f893")
@nodeType("SQLFact")
SELECT
    "n_Nationkey"                        AS "n_Nationkey"        @id("dc2cf1") @isBusinessKey,
    "n_Name"                             AS "n_Name"             @id("6040fd"),
    "n_Regionkey"                        AS "n_Regionkey"        @id("210372"),
    "n_Comment"                          AS "n_Comment"          @id("c46215"),
    "last_Modified"                      AS "last_Modified"      @id("545b56") @lastModifiedTracking,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS "SYSTEM_CREATE_DATE" @id("49427d") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS "SYSTEM_UPDATE_DATE" @id("6a266c") @isSystemUpdateDate @notNull
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
