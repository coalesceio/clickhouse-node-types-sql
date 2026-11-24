@id("7f3c2a10-0004-4c1e-9a11-0000000000c9")
@nodeType("SQLWork")
SELECT
    `d`.`a_id`                               AS `a_id`                @id("cj1201"),
    `d`.`SYSTEM_VERSION`                     AS `dim_version`         @id("cj1202"),
    `d`.`cfg_env`                            AS `cfg_env`             @id("cj1203"),
    `b`.`b_code`                             AS `b_code`              @id("cj1204")
FROM {{ ref('TARGET', 'ZT_CJ_DIM') }} `d`
CROSS JOIN {{ ref('TARGET', 'ZT_CJ_B') }} `b`
