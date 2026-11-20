@id("b0e4d6f5-74c0-5f7e-bd16-a1688d180139")
@nodeType("SQLWork")
@tests("SELECT 1 FROM {{ this }} WHERE `GH_COL_COMBINED1` != `README_EXPANSION`", false, "After")
SELECT
    `n_Nationkey` AS `n_Nationkey` @inHash("GH_COL1", 1) @inHash("GH_COL2", 2) @inHash("GH_D", 1) @inHash("GH_M", 1) @inHash("GH_S", 1) @inHash("GH_C", 1),
    `n_Name`      AS `n_Name`      @inHash("GH_COL1", 2) @inHash("GH_S", 2),
    `n_Regionkey` AS `n_Regionkey` @inHash("GH_COL2", 1),
    {{ get_hash('GH_D') }} AS `H_DEFAULT`,
    {{ get_hash('GH_M', 'MD5') }} AS `H_MD5`,
    {{ get_hash('GH_S', algo='SHA256', delimiter='~') }} AS `H_SHA256`,
    {{ get_hash('GH_C', 'cityHash64') }} AS `H_CITY`,
    {{ get_hash('GH_COL1') }} AS `GH_COL_COMBINED1`,
    {{ get_hash('GH_COL2', delimiter='~') }} AS `GH_COL_COMBINED2`,
    lower(hex(SHA1(ifNull(toString(`n_Nationkey`), 'null') || '||' || ifNull(toString(`n_Name`), 'null')))) AS `README_EXPANSION`
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
