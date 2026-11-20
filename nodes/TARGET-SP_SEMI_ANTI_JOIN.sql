@id("bed74ef6-2f92-58f9-853c-827a53b2cef8")
@nodeType("SQLWork")
@description("Customers (users) with a purchase (SEMI) and without one (ANTI)")
SELECT DISTINCT
    `v`.`user_id`                         AS `user_id`,
    'has_purchase'                        AS `kind`
FROM {{ ref('SRC', 'sp_events') }} `v`
LEFT SEMI JOIN (SELECT `user_id` FROM {{ ref('SRC', 'sp_events') }} WHERE `event_type` = 'purchase') `p` ON `p`.`user_id` = `v`.`user_id`
UNION ALL
SELECT DISTINCT
    `v`.`user_id`,
    'no_purchase'
FROM {{ ref('SRC', 'sp_events') }} `v`
LEFT ANTI JOIN (SELECT `user_id` FROM {{ ref('SRC', 'sp_events') }} WHERE `event_type` = 'purchase') `p` ON `p`.`user_id` = `v`.`user_id`
