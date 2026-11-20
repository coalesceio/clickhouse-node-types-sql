@id("0a4d8798-4936-505d-aca5-bd82254aa5e9")
@nodeType("SQLWork")
@description("INTERSECT DISTINCT: users with both a view and a purchase (plain INTERSECT is ALL in ClickHouse)")
SELECT `user_id` AS `user_id` FROM {{ ref('SRC', 'sp_events') }} WHERE `event_type` = 'view'
INTERSECT DISTINCT
SELECT `user_id` FROM {{ ref('SRC', 'sp_events') }} WHERE `event_type` = 'purchase'
