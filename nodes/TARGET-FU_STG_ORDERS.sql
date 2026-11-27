@id("1726fc3f-efb8-4d25-9c15-6bcb069165f5")
@nodeType("SQLWork")
@description("Staged orders (generated sample data, 1000 orders; customers 201-210 do not exist)")
@orderBy("`order_id`")
@partitionBy("toYYYYMM(`order_date`)")
WITH `o` AS (
    SELECT
        toUInt64(number + 1)                                         AS `order_id`,
        toUInt32((number * 7) % 210 + 1)                             AS `customer_id`,
        toDate('2026-01-01') + toIntervalDay(number % 300)           AS `order_date`,
        CAST(10 + (number % 97) * 3.25 AS Decimal(12, 2))            AS `amount`,
        ['O', 'F', 'P'][(number % 3) + 1]                            AS `order_status`
    FROM numbers(1000)
)
SELECT
    `order_id`         AS `order_id`         @notNull @uniqueness,
    `customer_id`      AS `customer_id`      @notNull,
    CAST(`order_date` AS Date) AS `order_date` @notNull,
    `amount`           AS `amount`           @min_value("0"),
    `order_status`     AS `order_status`     @accepted_values("'O', 'F', 'P'")
FROM `o`
