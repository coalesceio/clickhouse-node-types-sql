@id("b857e5e3-6c81-529a-b4cc-4199709fd00e")
@nodeType("SQLWork")
@description("Pattern with window functions: rows where view, cart, purchase happen back to back (lagInFrame)")
WITH `seq` AS (
    SELECT
        `user_id`, `ts`, `event_type`,
        lagInFrame(`event_type`, 1, '') OVER (PARTITION BY `user_id` ORDER BY `ts` ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS `prev1`,
        lagInFrame(`event_type`, 2, '') OVER (PARTITION BY `user_id` ORDER BY `ts` ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS `prev2`
    FROM {{ ref('SRC', 'sp_events') }}
)
SELECT
    `user_id`     AS `user_id`,
    `ts`          AS `purchase_ts`
FROM `seq`
WHERE `event_type` = 'purchase' AND `prev1` = 'cart' AND `prev2` = 'view'
