@id("5656e91e-e641-4c1a-9e1b-4806b67ee36a")
@nodeType("SQLWork")
SELECT
    CAST(number AS UInt32)                                                                                                                         AS `n_Nationkey`,
    CAST(if(number = 2, concat('NAME_2_v', '{{ parameters.test_ver | default(1) }}'), concat('NAME_', toString(number))) AS String)                AS `n_Name`,
    CAST(if(number = 1, {{ parameters.test_ver | default(1) }} % 2, number % 2) AS UInt32)                                                         AS `n_Regionkey`,
    CAST(toDateTime64('2026-01-01 00:00:00', 3) + toIntervalDay(if(number IN (1, 2), {{ parameters.test_ver | default(1) }}, 0)) AS DateTime64(3)) AS `last_Modified`
FROM numbers(4)
