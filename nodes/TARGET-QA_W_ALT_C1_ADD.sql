@id("0e1f0a00-0000-4000-8000-000000000201")
@nodeType("SQLWork")
@description("P2 add columns")
SELECT
    `c`.`cust_id`       AS `cust_id`,
    `c`.`cust_name`     AS `cust_name`,
    `c`.`region_id`     AS `region_id`,
    `c`.`segment`       AS `seg_notnull`    @notNull,
    generateUUIDv4()    AS `uuid_col`       @defaultValue("generateUUIDv4()"),
    'x'                 AS `const_def`      @defaultValue("'D'")
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
