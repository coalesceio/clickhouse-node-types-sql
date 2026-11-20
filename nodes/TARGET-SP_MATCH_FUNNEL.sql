@id("41accc03-5d54-509f-a564-44f341c3268a")
@nodeType("SQLWork")
@description("Funnel: windowFunnel gives how far each user got through view -> cart -> purchase within 1 hour")
SELECT
    `e`.`user_id`                                                                                            AS `user_id`,
    CAST(windowFunnel(3600)(`e`.`ts`, `e`.`event_type` = 'view', `e`.`event_type` = 'cart', `e`.`event_type` = 'purchase') AS UInt8) AS `funnel_step`
FROM {{ ref('SRC', 'sp_events') }} `e`
GROUP BY `e`.`user_id`
