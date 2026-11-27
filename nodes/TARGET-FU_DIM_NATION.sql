@id("142e65de-d1a7-4cf9-9e7c-30caf030a08e")
@nodeType("SQLDimension")
@description("Nation dimension, SCD Type 1, with an UNKNOWN zero key record")
@mergeStrategy("changeTracking")
@orderBy("`n_Nationkey`")
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'")
SELECT
    generateUUIDv4()          AS `FU_DIM_NATION_KEY`   @id("a1d001") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `n`.`n_Nationkey`         AS `n_Nationkey`         @id("a1d002") @isBusinessKey @notNull @zeroKey("4294967295"),
    `n`.`nation_name`         AS `nation_name`         @id("a1d003") @not_null,
    `n`.`n_Regionkey`         AS `n_Regionkey`         @id("a1d004"),
    `n`.`region_name`         AS `region_name`         @id("a1d005"),
    `n`.`n_Comment`           AS `n_Comment`           @id("a1d006"),
    now64(6)                  AS `SYSTEM_CREATE_DATE`  @id("a1d007") @isSystemCreateDate,
    now64(6)                  AS `SYSTEM_UPDATE_DATE`  @id("a1d008") @isSystemUpdateDate
FROM {{ ref('TARGET', 'FU_STG_NATION') }} `n`
