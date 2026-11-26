@id("0e1f0a00-0000-4000-8000-000000000600")
@nodeType("SQLDimension")
@engine("ReplacingMergeTree")
@description("RMT upstream: load_marker changes every run, so every run inserts new copies")
SELECT
    `s`.`cust_id`                               AS `cust_id`      @id("60a001") @isBusinessKey,
    `s`.`city`                                  AS `city`         @id("60a002"),
    toUInt32(toUnixTimestamp(now()))            AS `load_marker`  @id("60a003"),
    now64(6)                                    AS `SYSTEM_CREATE_DATE` @id("60a090") @isSystemCreateDate,
    now64(6)                                    AS `SYSTEM_UPDATE_DATE` @id("60a091") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
