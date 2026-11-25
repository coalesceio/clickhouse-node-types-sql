@id("0e1f0a00-0000-4000-8000-000000000130")
@nodeType("SQLWork")
@orderBy("`date_key`")
WITH `d` AS (
    SELECT toDate('2026-01-01') + number AS `dt` FROM numbers(31)
)
SELECT
    toUInt32(toYYYYMMDD(`dt`))                AS `date_key` @notNull @uniqueness,
    CAST(`dt` AS Date)                        AS `full_date`,
    toYear(`dt`)                              AS `year`,
    monthName(`dt`)                           AS `month_name`,
    CAST(dateName('weekday', `dt`) AS String) AS `day_name`,
    toDayOfWeek(`dt`) IN (6, 7)               AS `is_weekend`,
    CAST(toLastDayOfMonth(`dt`) AS Date)      AS `month_end`
FROM `d`
