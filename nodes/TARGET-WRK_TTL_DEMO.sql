@id("2bb1b336-5230-4e6f-8535-c2b39ffe20aa")
@nodeType("SQLWork")
@orderBy("`order_id`")
@ttl("`order_date` + INTERVAL 90 DAY")
@postSQL("OPTIMIZE TABLE {{ this }} FINAL")
@tests("SELECT 1 FROM {{ this }} WHERE `order_date` < now() - INTERVAL 90 DAY", true, "After")
SELECT
    CAST(number + 1 AS UInt32)                             AS `order_id`   @id("f0e001") @notNull,
    CAST(concat('ORDER_', toString(number + 1)) AS String) AS `order_name` @id("f0e002"),
    CAST(now() - toIntervalDay(number * 25) AS DateTime)   AS `order_date` @id("f0e003") @notNull
FROM numbers(6)
