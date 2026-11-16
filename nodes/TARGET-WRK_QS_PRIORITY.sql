@id("8bd30618-4023-4294-8c1b-2d6c80e71004")
@nodeType("SQLWork")
SELECT
     `mt` AS `mt`,
     `bs` AS `bs`,
     `mm` AS `mm`,
     `it` AS `it`
FROM {{ ref('TARGET', 'QS_PRIORITY') }} `QS_PRIORITY`