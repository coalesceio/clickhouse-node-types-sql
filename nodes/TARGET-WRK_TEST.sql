@id("1791e2f3-3f92-4a73-af7c-7b8d9a859c10")
@nodeType("SQLWork")
SELECT
    `c`.`customer_id`                                   AS `customer_id`,
    `r`.`region_name`                                   AS `name_nullable`,
    `r`.`region_name`                                   AS `name_notnull` @notNull,
    coalesce(`r`.`region_name`, 'UNKNOWN')              AS `name_clean`,
    CAST(isNull(`r`.`region_name`) AS UInt8)            AS `was_null`
FROM {{ ref('TARGET', 'JN_CUSTOMERS') }} `c`
LEFT JOIN {{ ref('TARGET', 'JN_REGIONS') }} `r` ON `r`.`region_id` = `c`.`region_id`