@id("b7d4f1a2-8e6c-4b3a-a5d9-2c7e9f0a1b63")
@nodeType("SQLFact")
@orderBy("o_custkey", "l_suppkey")
@description("Factless fact tracking which suppliers a customer has purchased from")
@tests("SELECT \"o_custkey\", \"l_suppkey\", count() AS cnt FROM {{ ref('TARGET', 'FCT_CUSTOMER_SUPPLIER_COVERAGE') }} GROUP BY \"o_custkey\", \"l_suppkey\" HAVING cnt > 1")
SELECT DISTINCT
    "o"."o_custkey"                       AS "o_custkey"         @id("f60001") @notNull @not_null @description("Customer key from the orders source feeding this coverage pair"),
    "l"."l_suppkey"                        AS "l_suppkey"         @id("f60002") @notNull @not_null @description("Supplier key the customer has purchased from, from lineitem"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)  AS "SYSTEM_CREATE_DATE" @id("f60003") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)  AS "SYSTEM_UPDATE_DATE" @id("f60004") @isSystemUpdateDate
FROM {{ ref('SRC', 'orders') }} "o"
JOIN {{ ref('TARGET', 'WRK_LINEITEM') }} "l"
    ON "o"."o_orderkey" = "l"."l_orderkey"
