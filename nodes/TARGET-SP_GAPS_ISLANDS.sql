@id("bee918fb-7c99-57bd-b1fc-1e4d988d7c60")
@nodeType("SQLWork")
@description("Gaps and islands: streaks of consecutive login days per user")
WITH `days` AS (
    SELECT DISTINCT `user_id`, toDate(`ts`) AS `d`
    FROM {{ ref('SRC', 'sp_events') }}
    WHERE `event_type` = 'login'
),
`grp` AS (
    SELECT `user_id`, `d`, `d` - toIntervalDay(row_number() OVER (PARTITION BY `user_id` ORDER BY `d`)) AS `island`
    FROM `days`
)
SELECT
    `user_id`       AS `user_id`,
    min(`d`)        AS `streak_start`,
    max(`d`)        AS `streak_end`,
    count()         AS `streak_days`
FROM `grp`
GROUP BY `user_id`, `island`
