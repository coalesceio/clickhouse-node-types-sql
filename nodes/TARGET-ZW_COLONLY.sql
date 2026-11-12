@id("b16c0e51-0000-4000-8000-0000000000d4")
@nodeType("SQLDimension")
SELECT
    generateUUIDv4()                     AS `ZW_COLONLY_KEY`     @id("k00000") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    CAST(`n_Nationkey` AS Int32)         AS `n_Nationkey`        @id("k00001") @isBusinessKey @zeroKey("-1"),
    `n_Name`                             AS `n_Name`             @id("k00002") @zeroKey("'N/A'"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("k00008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("k00009") @isSystemUpdateDate @notNull
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
