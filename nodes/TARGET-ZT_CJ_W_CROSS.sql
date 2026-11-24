@id("7f3c2a10-0004-4c1e-9a11-0000000000c4")
@nodeType("SQLWork")
SELECT
    `a`.`a_id`                             AS `a_id`   @id("cj0d01"),
    `a`.`a_name`                           AS `a_name` @id("cj0d02"),
    `b`.`b_code`                           AS `b_code` @id("cj0d03")
FROM {{ ref('TARGET', 'ZT_CJ_A') }} `a`
CROSS JOIN {{ ref('TARGET', 'ZT_CJ_B') }} `b`
