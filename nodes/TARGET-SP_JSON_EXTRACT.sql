@id("cfd53ffa-0d1e-51f9-9820-e780ceeb6b1d")
@nodeType("SQLWork")
@description("JSON fields from a String column")
SELECT
    `r`.`id`                                                      AS `id`,
    JSONExtractString(`r`.`payload`, 'name')                      AS `name`,
    CAST(JSONExtract(`r`.`payload`, 'age', 'Nullable(UInt8)') AS Nullable(UInt8)) AS `age`,
    JSONExtractString(`r`.`payload`, 'address', 'city')           AS `city`,
    CAST(JSONExtract(`r`.`payload`, 'skills', 'Array(String)') AS Array(String)) AS `skills`,
    CAST(JSONHas(`r`.`payload`, 'age') AS UInt8)                  AS `has_age`
FROM {{ ref('SRC', 'sp_raw') }} `r`
