@id("0e1f0a00-0000-4000-8000-000000000706")
@nodeType("SQLDimension")
@description("P7 region dimension, SCD1, ReplacingMergeTree")
@engine("ReplacingMergeTree")
@optimize
SELECT
    `r`.`region_id`       AS `region_id`           @id("7b0001") @isBusinessKey,
    `r`.`region_name`     AS `region_name`         @id("7b0002"),
    now64(6)                AS `SYSTEM_CREATE_DATE`  @id("7b0093") @isSystemCreateDate,
    now64(6)                AS `SYSTEM_UPDATE_DATE`  @id("7b0094") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_P7_SRC_REGION') }} `r`
