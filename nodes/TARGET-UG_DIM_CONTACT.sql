@id("6debd262-63d9-50fb-b142-f603dad31f81")
@nodeType("SQLDimension")
@mergeStrategy("lastModified")
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'", "1900-01-01 00:00:00", false)
@tests("SELECT `contact_id` FROM {{ this }} FINAL WHERE `SYSTEM_CURRENT_FLAG` = 'Y' GROUP BY `contact_id` HAVING count() > 1", false, "After")
SELECT
    generateUUIDv4() AS `contact_key` @id("dv01") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `b`.`contact_id` AS `contact_id`  @id("dv02") @isBusinessKey @notNull,
    `b`.`email`      AS `email`       @id("dv03"),
    `b`.`owner_id`   AS `owner_id`    @id("dv05"),
    `b`.`status`     AS `status`      @id("dv06") @accepted_values("'lead', 'prospect', 'customer', 'UNKNOWN'"),
    `b`.`is_deleted` AS `is_deleted`  @id("dv07"),
    `b`.`cdc_version` AS `cdc_version` @id("dv14") @lastModifiedTracking(2),
    1   AS `SYSTEM_VERSION`      @id("dv09") @isSystemVersion @notNull,
    'Y' AS `SYSTEM_CURRENT_FLAG` @id("dv10") @isSystemCurrentFlag,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE` @id("dv11") @isSystemEndDate,
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_CREATE_DATE` @id("dv12") @isSystemCreateDate,
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_UPDATE_DATE` @id("dv13") @isSystemUpdateDate @notNull
FROM {{ ref('TARGET', 'UG_BRZ_CONTACTS') }} `b`
