@id("15e828e5-4789-4649-b4dd-0b1263b04d8d")
@nodeType("SQLWork")
@description("Staged customers (generated sample data, 200 customers)")
@orderBy("`customer_id`")
WITH `c` AS (
    SELECT
        toUInt32(number + 1)                                             AS `customer_id`,
        concat('Customer#', leftPad(toString(number + 1), 5, '0'))       AS `customer_name`,
        toUInt32(number % 25)                                            AS `nation_key`,
        ['RETAIL', 'CORPORATE', 'SMB'][(if(number < 20, number + 1, number) % 3) + 1] AS `segment`,
        concat('+1-555-', leftPad(toString(number + 1), 4, '0'))         AS `phone`,
        concat('cust', toString(number + 1), '@example.com')             AS `email`,
        toDateTime64('2026-01-01 00:00:00', 3) + toIntervalHour(number)  AS `updated_at`
    FROM numbers(200)
)
SELECT
    `customer_id`      AS `customer_id`      @notNull @not_null @uniqueness,
    `customer_name`    AS `customer_name`    @empty,
    `nation_key`       AS `nation_key`       @min_max(0, 24),
    `segment`          AS `segment`          @accepted_values("'RETAIL', 'CORPORATE', 'SMB'"),
    `email`            AS `email`,
    `phone`            AS `phone`,
    CAST(`updated_at` AS DateTime64(3)) AS `updated_at`
FROM `c`
