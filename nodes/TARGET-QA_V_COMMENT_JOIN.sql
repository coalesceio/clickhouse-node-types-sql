@id("0e1f0a00-0000-4000-8000-000000000170")
@nodeType("SQLWork")
@materializationType("view")
-- LEFT JOIN in a node comment
SELECT
    `c`.`cust_id`                                       AS `cust_id`,
    `c`.`cust_id`                                       AS `JOIN_ID`,
    'left join text'                                    AS `note`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
/* INNER JOIN in a block comment */
WHERE `c`.`segment` != 'x join y' -- RIGHT JOIN trailing comment
