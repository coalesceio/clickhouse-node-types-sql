@id("0e1f0a00-0000-4000-8000-000000000202")
@nodeType("SQLWork")
SELECT
    `c`.`cust_id`       AS `cust_id`,
    `c`.`cust_name`     AS `customer_name`  @id("c2a001"),
    `c`.`segment`       AS `seg`,
    `c`.`balance`       AS `bal`            @id("c2a002") @description("bal") @defaultValue("0")
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
