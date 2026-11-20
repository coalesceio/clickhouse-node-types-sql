@id("40a2930b-31b0-5e6c-b7ab-e5634c9d25a0")
@nodeType("SQLDimension")
@mergeStrategy("lastModified")
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'", "1900-01-01 00:00:00", false)
SELECT
    generateUUIDv4() AS `contact_key` @id("du01") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `b`.`contact_id` AS `contact_id`  @id("du02") @isBusinessKey @notNull,
    `b`.`email`      AS `email`       @id("du03"),
    `b`.`status`     AS `status`      @id("du06"),
    `b`.`is_deleted` AS `is_deleted`  @id("du07"),
    `b`.`cdc_version` AS `cdc_version` @id("du14"),
    `b`.`updated_at` AS `updated_at`  @id("du15") @lastModifiedTracking(2),
    1   AS `SYSTEM_VERSION`      @id("du09") @isSystemVersion @notNull,
    'Y' AS `SYSTEM_CURRENT_FLAG` @id("du10") @isSystemCurrentFlag,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE` @id("du11") @isSystemEndDate,
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_CREATE_DATE` @id("du12") @isSystemCreateDate,
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_UPDATE_DATE` @id("du13") @isSystemUpdateDate @notNull
FROM {{ ref('TARGET', 'UG_BRZ_CONTACTS') }} `b`
