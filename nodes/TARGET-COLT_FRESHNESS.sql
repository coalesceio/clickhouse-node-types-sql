@id("9ca0ada5-8046-562f-a4b8-56ffee96303d")
@nodeType("SQLWork")
@description("@freshness: newest value within interval and unit; fails when all NULL")
SELECT
    CAST(now() AS DateTime)                                                                      AS `p_datetime_hour` @freshness(1, "HOUR"),
    CAST(now64(6) AS DateTime64(6))                                                              AS `p_dt64_minute` @freshness(10, "MINUTE"),
    CAST(now() AS DateTime)                                                                      AS `p_second` @freshness(3600, "SECOND"),
    CAST(now() - INTERVAL 10 DAY AS DateTime)                                                    AS `p_week` @freshness(2, "WEEK"),
    CAST(now() - INTERVAL 10 DAY AS DateTime)                                                    AS `p_month` @freshness(1, "MONTH"),
    CAST(now() - INTERVAL 10 DAY AS DateTime)                                                    AS `p_default_unit_day` @freshness(30),
    CAST(toDateTime('2020-01-01 00:00:00') AS DateTime)                                          AS `f_old_day` @freshness(7, "DAY"),
    CAST(toDateTime('2020-01-01 00:00:00') AS DateTime)                                          AS `f_old_year` @freshness(1, "YEAR"),
    CAST(today() AS Date)                                                                        AS `p_date_today_day` @freshness(1, "DAY"),
    CAST(today() AS Date)                                                                        AS `o_date_today_hour_midnight` @freshness(1, "HOUR"),
    CAST(if(number = 0, now(), toDateTime('2020-01-01 00:00:00')) AS DateTime)                   AS `p_newest_counts` @freshness(1, "DAY"),
    CAST(NULL AS Nullable(DateTime))                                                             AS `f_all_null` @freshness(1, "DAY")
FROM numbers(5)
