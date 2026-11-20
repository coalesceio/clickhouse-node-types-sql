@id("b3000000-0000-4000-8000-000000000014")
@nodeType("SQLFact")
@engine("MergeTree")
SELECT
    `c`.`c_custkey` AS `c_custkey` @id("f1014") @isBusinessKey @notNull,
    `o`.`o_comment` AS `o_comment` @id("f2014"),
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_CREATE_DATE` @id("f6014") @isSystemCreateDate,
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_UPDATE_DATE` @id("f7014") @isSystemUpdateDate @notNull
FROM {{ ref('SRC', 'rx_customer') }} `c`
LEFT JOIN {{ ref('SRC', 'rx_orders') }} `o` ON `o`.`o_custkey` = `c`.`c_custkey` + 1000
