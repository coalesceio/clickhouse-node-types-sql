@id("79040b1f-a94e-4d69-869a-534a5c49460a")
@nodeType("SQLDimension")
@description("AN pipeline - Dimension: region SCD Type 1 (overwrite in place)")
@materializationType("table")
@writeMode("append")
@mergeStrategy("changeTracking")
@optimize
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'")
@tests("SELECT `r_regionkey` FROM {{ this }} FINAL GROUP BY `r_regionkey` HAVING count() > 1", false, "After")
SELECT
    generateUUIDv4()                                   AS `region_key`         @id("adr01") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()") @description("Surrogate key"),
    `r`.`r_regionkey`                                  AS `r_regionkey`        @id("adr02") @isBusinessKey @notNull @zeroKey("4294967295") @description("Region business key") @not_null @uniqueness,
    trimBoth(toStringCutToZero(`r`.`r_name`))          AS `region_name`        @id("adr03") @notNull @description("Region name") @empty @accepted_values("'AFRICA', 'AMERICA', 'ASIA', 'EUROPE', 'MIDDLE EAST', 'UNKNOWN'"),
    `r`.`r_comment`                                    AS `comment`            @id("adr04") @description("Region comment"),
    CAST(now64(6) AS DateTime64(6))                    AS `SYSTEM_CREATE_DATE` @id("adr05") @isSystemCreateDate @notNull,
    CAST(now64(6) AS DateTime64(6))                    AS `SYSTEM_UPDATE_DATE` @id("adr06") @isSystemUpdateDate @notNull
FROM {{ ref('SRC', 'region') }} `r`
