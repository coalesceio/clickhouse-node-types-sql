@id("0e1f0a00-0000-4000-8000-000000000303")
@nodeType("SQLDimension")
@engine("MergeTree")
@mergeStrategy("lastModified")
@orderBy("`cust_id`")
@partitionBy("toYYYYMM(`updated_at`)")
SELECT
    generateUUIDv4() AS `QA_D_LM_SCD1_KEY` @id("a3d000") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `s`.`cust_id`     AS `cust_id`     @id("a3d001") @isBusinessKey,
    `s`.`cust_name`   AS `cust_name`   @id("a3d002"),
    `s`.`city`        AS `city`        @id("a3d003"),
    `s`.`tier`        AS `tier`        @id("a3d004"),
    `s`.`updated_at`  AS `updated_at`  @id("a3d005") @lastModifiedTracking(1),
    now64(6)                                            AS `SYSTEM_CREATE_DATE`  @id("a3d093") @isSystemCreateDate,
    now64(6)                                            AS `SYSTEM_UPDATE_DATE`  @id("a3d094") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
