@id("a05c0e51-0000-4000-8000-0000000000c4")
@nodeType("SQLDimension")
@zeroKey("00000000-0000-0000-0000-000000000001", "'NA'")
SELECT
    generateUUIDv4()                     AS `ZV_D1_NOVER_KEY`         @id("h00000") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    CAST(`n_Nationkey` AS Int32)         AS `n_Nationkey`        @id("h00001") @isBusinessKey @zeroKey("-1"),
    `n_Name`                             AS `n_Name`             @id("h00002"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("h00008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("h00009") @isSystemUpdateDate @notNull
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
