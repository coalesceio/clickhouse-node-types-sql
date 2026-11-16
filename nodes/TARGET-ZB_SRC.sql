@id("2d0145f5-ff9c-4196-bb5b-ae3e49ba3b69")
@nodeType("SQLWork")
SELECT
    CAST(multiIf(number = 0, 0, number IN (1, 2), 1, NULL) AS Nullable(UInt32))                         AS `k`,
    CAST(multiIf(number = 0, 'a0', number IN (1, 2), concat('a1_v', '{{ parameters.test_ver | default(1) }}'), 'anull') AS String)           AS `attr`,
    CAST(toDateTime64('2026-01-01 00:00:00', 3) + toIntervalDay(if(number IN (1, 2), {{ parameters.test_ver | default(1) }}, 0)) AS DateTime64(3)) AS `last_Modified`
FROM numbers(5)
