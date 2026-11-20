@id("bbd81f1a-934c-5fd2-b6f3-a28d73680155")
@nodeType("SQLWork")
@description("Date dimension: one row per day for 2020-2030 from numbers()")
@orderBy("`date_key`")
WITH `d` AS (
    SELECT toDate('2020-01-01') + number AS `dt` FROM numbers(4018)
)
SELECT
    toUInt32(toYYYYMMDD(`dt`))                AS `date_key` @notNull @uniqueness,
    CAST(`dt` AS Date)                        AS `full_date`,
    toYear(`dt`)                              AS `year`,
    toQuarter(`dt`)                           AS `quarter`,
    toMonth(`dt`)                             AS `month`,
    monthName(`dt`)                           AS `month_name`,
    toISOWeek(`dt`)                           AS `iso_week`,
    toDayOfMonth(`dt`)                        AS `day_of_month`,
    toDayOfWeek(`dt`)                         AS `day_of_week`,
    CAST(dateName('weekday', `dt`) AS String) AS `day_name`,
    toDayOfWeek(`dt`) IN (6, 7)               AS `is_weekend`,
    toStartOfMonth(`dt`)                      AS `month_start`,
    CAST(toLastDayOfMonth(`dt`) AS Date)      AS `month_end`,
    toYear(addMonths(`dt`, 9))                AS `fiscal_year_apr`
FROM `d`
