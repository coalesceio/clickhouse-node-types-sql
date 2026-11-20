@id("544557a5-2620-5f21-9239-ecc9b90d4901")
@nodeType("SQLWork")
@description("Comma list to rows (splitByChar + ARRAY JOIN)")
SELECT
    `r`.`id`       AS `id`,
    `tag`          AS `tag`
FROM {{ ref('SRC', 'sp_raw') }} `r`
ARRAY JOIN splitByChar(',', `r`.`tags`) AS `tag`
WHERE `tag` != ''
