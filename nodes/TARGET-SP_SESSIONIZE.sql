@id("b81c1267-7768-59a2-9210-33661c2f2e7c")
@nodeType("SQLWork")
@description("Sessions: a new session when the gap since the previous event is over 30 minutes")
WITH `gaps` AS (
    SELECT
        `user_id`, `ts`, `event_type`,
        if(dateDiff('minute', lagInFrame(`ts`, 1, `ts`) OVER (PARTITION BY `user_id` ORDER BY `ts` ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), `ts`) > 30, 1, 0) AS `is_new`
    FROM {{ ref('SRC', 'sp_events') }}
)
SELECT
    `user_id`                                                                                     AS `user_id`,
    `ts`                                                                                          AS `ts`,
    `event_type`                                                                                  AS `event_type`,
    sum(`is_new`) OVER (PARTITION BY `user_id` ORDER BY `ts` ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) + 1 AS `session_no`
FROM `gaps`
