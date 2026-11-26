@id("0e1f0a00-0000-4000-8000-000000000311")
@nodeType("SQLDimension")
@final
@joinUseNulls
@querySettings("transform_null_in = 0", "final = 0")
SELECT
    `s`.`alt_key`     AS `alt_key`     @id("b8d001") @isBusinessKey,
    `s`.`city`        AS `city`        @id("b8d003") @zeroKey("'X'"),
    `s`.`updated_at`  AS `updated_at`  @id("b8d005") @lastModifiedTracking(1),
    
    now64(6)                                            AS `SYSTEM_CREATE_DATE`  @id("b8d093") @isSystemCreateDate,
    now64(6)                                            AS `SYSTEM_UPDATE_DATE`  @id("b8d094") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
