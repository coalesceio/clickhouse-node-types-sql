@id("e5f264c3-ecb5-57c7-9889-378461011125")
@nodeType("SQLFact")
@mergeStrategy("allColumnMatch")
SELECT
    `en`.`contact_id`  AS `contact_id`  @id("fn01") @notNull,
    `en`.`sequence_id` AS `sequence_id` @id("fn02") @notNull,
    `en`.`enrolled_at` AS `enrolled_at` @id("fn03"),
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_CREATE_DATE` @id("fn04") @isSystemCreateDate
FROM {{ ref('TARGET', 'UG_BRZ_ENROLLMENTS') }} `en`
