@id("7e700000-0000-4000-8000-000000000001")
@nodeType("SQLWork")
SELECT
    CAST(number AS UInt32)                                         AS `k`    @notNull,
    CAST(concat('NAME_', toString(number)) AS String)              AS `name` @notNull,
    CAST(now() - toIntervalDay(number * 150) AS DateTime)          AS `d`    @notNull,
    CAST(toString(now() - toIntervalDay(number * 150)) AS String)  AS `s`    @notNull
FROM numbers(6)
