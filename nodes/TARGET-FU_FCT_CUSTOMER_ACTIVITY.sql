@id("b5607baf-0750-4cd0-9b17-f46d17503ee2")
@nodeType("SQLFact")
@description("Factless fact: which customer ordered on which day")
@mergeStrategy("allColumnMatch")
@orderBy("`customer_id`", "`activity_date`")
SELECT
    `o`.`customer_id`        AS `customer_id`        @id("d4f001") @notNull,
    `o`.`order_date`         AS `activity_date`      @id("d4f002") @notNull,
    now64(6)                 AS `SYSTEM_CREATE_DATE` @id("d4f003") @isSystemCreateDate
FROM {{ ref('TARGET', 'FU_STG_ORDERS') }} `o`
