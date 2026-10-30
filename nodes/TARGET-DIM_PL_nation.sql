@id("d8f4c6a3-5e7b-4a9c-9d3f-2b0e4a8c6f93")
@nodeType("SQLDimension")
@description("Pipeline - nation dimension, change tracking SCD Type 1")
@materializationType("table")
@orderBy("n_nationkey")
@primaryKey("n_nationkey")
@settings("index_granularity = 8192")
@writeMode("append")
@mergeStrategy("changeTracking")
SELECT
    generateUUIDv4()                               AS "DIM_PL_nation_KEY"  @id("5c6d7e") @description("Surrogate key") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()") @uniqueness,
    "n_nationkey"                                  AS "n_nationkey"        @id("6d7e8f") @description("Nation key") @isBusinessKey @notNull @not_null @uniqueness,
    "nation_name"                                  AS "nation_name"        @id("7e8f9a") @description("Nation name") @empty,
    "n_regionkey"                                  AS "n_regionkey"        @id("8f9a0b") @description("Region key") @min_max("0", "4"),
    "n_comment"                                    AS "n_comment"          @id("9a0b1c") @description("Comment"),
    now64(6)                                       AS "SYSTEM_CREATE_DATE" @id("0b1c2d") @isSystemCreateDate @relative_time("<=", "SYSTEM_UPDATE_DATE"),
    now64(6)                                       AS "SYSTEM_UPDATE_DATE" @id("1c2d3e") @isSystemUpdateDate
FROM {{ ref('TARGET', 'WRK_PL_nation') }} "WRK_PL_nation"
