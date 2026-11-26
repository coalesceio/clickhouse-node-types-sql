@id("0e1f0a00-0000-4000-8000-000000000301")
@nodeType("SQLDimension")
@engine("MergeTree")
@orderBy("`cust_id`", "`SYSTEM_VERSION`")
@primaryKey("`cust_id`")
@description("P5: columns altered")
SELECT
    generateUUIDv4() AS `QA_D_CT_SCD1_KEY` @id("a1d000") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `s`.`cust_id`     AS `cust_id`     @id("a1d001") @isBusinessKey,
    `s`.`cust_name`   AS `cust_name`   @id("a1d002"),
    CAST(`s`.`city` AS LowCardinality(String)) AS `city` @id("a1d003") @description("now LowCardinality") @isChangeTracking,
    `s`.`tier`        AS `cust_tier`   @id("a1d004"),
    'NA'              AS `region`      @id("a1d006") @defaultValue("'NA'"),
    1 AS `SYSTEM_VERSION` @id("a1d090") @isSystemVersion,
    'Y' AS `SYSTEM_CURRENT_FLAG` @id("a1d091") @isSystemCurrentFlag,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS `SYSTEM_END_DATE` @id("a1d092") @isSystemEndDate,
    now64(6)                                            AS `SYSTEM_CREATE_DATE`  @id("a1d093") @isSystemCreateDate,
    now64(6)                                            AS `SYSTEM_UPDATE_DATE`  @id("a1d094") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
