@id("0e1f0a00-0000-4000-8000-000000000204")
@nodeType("SQLWork")
@description("P2 props after")
SELECT
    `c`.`cust_id`       AS `cust_id`,
    `c`.`cust_name`     AS `name_desc_add`      @description("added desc"),
    `c`.`cust_name`     AS `name_desc_chg`      @description("new desc"),
    `c`.`cust_name`     AS `name_desc_del`,
    `c`.`region_id`     AS `reg_def_add`        @defaultValue("9"),
    `c`.`region_id`     AS `reg_def_chg`        @defaultValue("5"),
    `c`.`region_id`     AS `reg_def_del`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
