@id("0e1f0a00-0000-4000-8000-000000000131")
@nodeType("SQLWork")
SELECT
    `c`.`cust_id`       AS `cust_id`,
    `c`.`cust_name`     AS `cust_name_nn`       @notNull,
    `c`.`cust_name`     AS `cust_name_nn_def`   @notNull @defaultValue("'NONAME'"),
    `c`.`region_id`     AS `region_nn`          @notNull,
    `c`.`region_id`     AS `region_nn_def`      @notNull @defaultValue("42")
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
