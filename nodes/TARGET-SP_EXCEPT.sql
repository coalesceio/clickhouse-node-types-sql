@id("a7f330c9-4682-50b2-a902-4a9b7a965d0f")
@nodeType("SQLWork")
@description("EXCEPT DISTINCT: users who viewed but never purchased (plain EXCEPT is ALL in ClickHouse)")
SELECT `user_id` AS `user_id` FROM {{ ref('SRC', 'sp_events') }} WHERE `event_type` = 'view'
EXCEPT DISTINCT
SELECT `user_id` FROM {{ ref('SRC', 'sp_events') }} WHERE `event_type` = 'purchase'
