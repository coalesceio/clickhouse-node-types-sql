@id("63d6f841-ba22-49b5-a166-7ef1d6de97f2")
@nodeType("SQLDimension")
@orderBy("n_nationkey")
SELECT
    generateUUIDv4()                     AS "DIM_NATION_KEY"    @id("a10001") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    "n"."n_nationkey"                    AS "n_nationkey"       @id("a10002") @isBusinessKey @notNull @not_null @uniqueness,
    "n"."n_name"                         AS "n_name"            @id("a10003") @notNull @not_null,
    "r"."r_name"                         AS "r_name"            @id("a10004") @notNull @not_null,
    "n"."n_comment"                      AS "n_comment"         @id("a10005"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS "SYSTEM_CREATE_DATE" @id("a10006") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS "SYSTEM_UPDATE_DATE" @id("a10007") @isSystemUpdateDate
FROM {{ ref('SRC', 'nation') }} "n"
JOIN {{ ref('SRC', 'region') }} "r" ON "n"."n_regionkey" = "r"."r_regionkey"
