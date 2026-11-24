@id("7f3c2a10-0004-4c1e-9a11-0000000000c8")
@nodeType("SQLWork")
@materializationType("view")
SELECT
    `a`.`a_id`                             AS `a_id`     @id("cj1101"),
    `c`.`cfg_env`                          AS `cfg_env`  @id("cj1102"),
    `a`.`a_id` * `c`.`cfg_rate`            AS `amount`   @id("cj1103")
FROM {{ ref('TARGET', 'ZT_CJ_A') }} `a`
CROSS JOIN {{ ref('TARGET', 'ZT_CJ_CFG') }} `c`
