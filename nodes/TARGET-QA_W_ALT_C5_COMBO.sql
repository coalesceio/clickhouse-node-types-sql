@id("0e1f0a00-0000-4000-8000-000000000205")
@nodeType("SQLWork")
@description("P2 combo after")
@orderBy("`cust_id`", "`updated_at`")
@primaryKey("`cust_id`")
SELECT
    `c`.`cust_id`                               AS `cust_id`,
    `c`.`cust_name`                             AS `cname`          @id("c5a001") @description("renamed"),
    CAST(`c`.`segment` AS LowCardinality(String)) AS `segment`      @id("c5a002") @description("now LC"),
    CAST(`c`.`balance` AS Decimal(18, 4))       AS `balance`        @id("c5a003"),
    `c`.`updated_at`                            AS `updated_at`     @id("c5a005")
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
