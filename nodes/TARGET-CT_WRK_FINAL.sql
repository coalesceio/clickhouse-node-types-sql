@id("ce000000-0000-4000-8000-000000000010")
@nodeType("SQLWork")
WITH `v` AS (SELECT * FROM {{ ref('TARGET', 'CT_VIEW') }})
SELECT
    `v`.`cust_id`                        AS `cust_id`,
    `v`.`amount`                         AS `amount`,
    CAST(`v`.`amount` * 2 AS Decimal(14, 2)) AS `amount_x2`
FROM `v`
