@id("e4c8383d-912e-5cd2-ba03-a9f0382383c0")
@nodeType("SQLWork")
@description("Regex extract and replace")
SELECT
    `r`.`id`                                                                AS `id`,
    extract(`r`.`note`, '[A-Z]-[0-9]+')                                     AS `order_code`,
    toDateOrNull(extract(`r`.`note`, '[0-9]{4}-[0-9]{2}-[0-9]{2}'))         AS `ship_date`,
    replaceRegexpAll(`r`.`note`, '[0-9]', '#')                              AS `masked_note`,
    match(`r`.`note`, 'delayed')                                            AS `is_delayed`
FROM {{ ref('SRC', 'sp_raw') }} `r`
