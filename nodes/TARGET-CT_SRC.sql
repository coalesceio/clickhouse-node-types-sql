@id("ce000000-0000-4000-8000-000000000001")
@nodeType("SQLWork")
WITH `base` AS (SELECT number AS `n` FROM numbers(6))
SELECT DISTINCT
    CAST(`n` AS UInt32)                                                                        AS `cust_id`,
    CAST(concat('CUST_', toString(`n`)) AS String)                                            AS `name`,
    CAST(`n` % 3 AS UInt32)                                                                    AS `region`,
    CAST(`n` * 12.5 AS Decimal(10, 2))                                                         AS `amount`,
    CAST(toDateTime64('2026-01-01 00:00:00', 3) + toIntervalDay(`n`) AS DateTime64(3))        AS `last_Modified`,
    CAST(if(`n` % 2 = 0, 'GOLD', 'SILVER') AS String)                                        AS `segment`
FROM `base`
