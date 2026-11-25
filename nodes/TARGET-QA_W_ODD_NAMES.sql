@id("0e1f0a00-0000-4000-8000-000000000149")
@nodeType("SQLWork")
@orderBy("`order`")
SELECT
    `c`.`cust_id`       AS `order`,
    `c`.`segment`       AS `select`,
    `c`.`cust_name`     AS `my col`,
    `c`.`balance`       AS `Balance`,
    `c`.`balance`       AS `balance`,
    `c`.`region_id`     AS `région`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
