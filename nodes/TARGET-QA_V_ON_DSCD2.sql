@id("0e1f0a00-0000-4000-8000-000000000380")
@nodeType("SQLWork")
@materializationType("view")
SELECT
    `d`.`cust_id`             AS `cust_id`,
    `d`.`city`                AS `city`,
    `d`.`SYSTEM_VERSION`      AS `SYSTEM_VERSION`
FROM {{ ref('TARGET', 'QA_D_CT_SCD2') }} `d`
WHERE `d`.`SYSTEM_CURRENT_FLAG` = 'Y'
