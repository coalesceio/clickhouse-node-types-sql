@id("4b8a2e71-6d3f-4a9c-9e12-8f5c0d7a3b64")
@nodeType("SQLFact")
@orderBy("ps_partkey", "ps_suppkey")
@mergeStrategy("changeTracking")
@disableTests
@preSQL("SELECT throwIf(cnt > 1, 'Duplicate partsupp business key detected') FROM (SELECT count() AS cnt FROM {{ ref('SRC', 'partsupp') }} GROUP BY ps_partkey, ps_suppkey) WHERE cnt > 1")
@postSQL("OPTIMIZE TABLE {{ ref('TARGET', 'FCT_PARTSUPP') }} FINAL")
SELECT
    "ps_partkey"                          AS "ps_partkey"         @id("d40001") @isBusinessKey @notNull @not_null,
    "ps_suppkey"                          AS "ps_suppkey"         @id("d40002") @isBusinessKey @notNull @not_null,
    "ps_availqty"                         AS "ps_availqty"        @id("d40003") @notNull @min_value(0),
    "ps_supplycost"                       AS "ps_supplycost"      @id("d40004") @notNull @min_value(0),
    "ps_comment"                          AS "ps_comment"         @id("d40005"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)  AS "SYSTEM_CREATE_DATE" @id("d40006") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)  AS "SYSTEM_UPDATE_DATE" @id("d40007") @isSystemUpdateDate
FROM {{ ref('SRC', 'partsupp') }} "partsupp"
