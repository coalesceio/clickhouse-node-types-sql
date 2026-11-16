@id("bc08423a-782c-402d-a1dc-795fbaf1acfa")
@nodeType("SQLWork")
@materializationType("view")
@joinUseNulls
@final
SELECT
     `mt` AS `mt`,
     `bs` AS `bs`,
     `mm` AS `mm`,
     `it` AS `it`
FROM {{ ref('TARGET', 'QS_PRIORITY') }} `QS_PRIORITY`