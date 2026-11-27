@id("e6fdd022-636a-48dc-a6db-a10b1d161cdb")
@nodeType("SQLWork")
@description("Staged nations: trimmed names and region names")
@orderBy("`n_Nationkey`")
@tests("SELECT 1 FROM {{ ref('SRC', 'Nation_Test') }} HAVING count() = 0", false, "Before")
SELECT
    `n_Nationkey`                                                    AS `n_Nationkey`   @notNull @not_null @uniqueness,
    CAST(trimRight(replaceAll(toString(`n_Name`), '\0', '')) AS String) AS `nation_name` @empty,
    `n_Regionkey`                                                    AS `n_Regionkey`   @min_max(0, 4),
    multiIf(`n_Regionkey` = 0, 'AFRICA',
            `n_Regionkey` = 1, 'AMERICA',
            `n_Regionkey` = 2, 'ASIA',
            `n_Regionkey` = 3, 'EUROPE',
            `n_Regionkey` = 4, 'MIDDLE EAST',
            'UNKNOWN')                                               AS `region_name`,
    `n_Comment`                                                      AS `n_Comment`,
    `last_Modified`                                                  AS `last_Modified`
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
