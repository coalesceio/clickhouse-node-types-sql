@id("53609d9b-1284-5cb3-8042-483da27a1a5e")
@nodeType("SQLWork")
WITH `all_nations` AS (
    SELECT `n_Nationkey`, `n_Name`, `n_Regionkey`, `last_Modified` FROM {{ ref('SRC', 'rx_Nation_Copy1') }}
    UNION ALL
    SELECT `n_Nationkey`, `n_Name`, `n_Regionkey`, `last_Modified` FROM {{ ref('SRC', 'rx_Nation_Copy2') }}
)
SELECT
    `n_Nationkey`                    AS `n_Nationkey`,
    `n_Name`                         AS `n_Name`,
    `n_Regionkey`                    AS `n_Regionkey`,
    `last_Modified`                  AS `last_Modified`
FROM `all_nations`
