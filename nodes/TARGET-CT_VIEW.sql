@id("ce000000-0000-4000-8000-000000000009")
@nodeType("SQLWork")
@materializationType("view")
@final
WITH `f` AS (SELECT * FROM {{ ref('TARGET', 'CT_FCT') }})
SELECT
    `f`.`cust_id`                        AS `cust_id`,
    `f`.`dim_key`                        AS `dim_key`,
    `f`.`dim_name`                       AS `dim_name`,
    CAST(`f`.`amount` AS Decimal(12, 2)) AS `amount`
FROM `f`
