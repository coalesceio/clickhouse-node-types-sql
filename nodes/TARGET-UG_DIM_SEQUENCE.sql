@id("9078855f-2c76-5d63-9ef2-8d487aac6232")
@nodeType("SQLDimension")
@optimize
SELECT
    generateUUIDv4() AS `sequence_key`  @id("ds01") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `s`.`sequence_id`   AS `sequence_id`   @id("ds02") @isBusinessKey @notNull,
    `s`.`sequence_name` AS `sequence_name` @id("ds03") @not_null,
    `s`.`channel`       AS `channel`       @id("ds04"),
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_CREATE_DATE` @id("ds05") @isSystemCreateDate,
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_UPDATE_DATE` @id("ds06") @isSystemUpdateDate @notNull
FROM {{ ref('TARGET', 'UG_BRZ_SEQUENCES') }} `s`
