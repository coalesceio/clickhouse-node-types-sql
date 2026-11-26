@id("0e1f0a00-0000-4000-8000-000000000703")
@nodeType("SQLWork")
@description("P7 staging: cleaned customers with region")
@orderBy("`cust_id`")
@tests("SELECT 1 FROM {{ this }} GROUP BY `cust_id` HAVING count() > 1", false, "After")
SELECT
    `c`.`cust_id`                                                        AS `cust_id`      @not_null @uniqueness,
    coalesce(nullIf(trimBoth(initcap(`c`.`cust_name`)), ''), 'UNKNOWN')   AS `cust_name`    @empty,
    `c`.`segment`                                                        AS `segment`      @accepted_values("'RETAIL'", "'CORPORATE'", "'SMB'"),
    `c`.`city`                                                           AS `city`,
    `c`.`region_id`                                                      AS `region_id`,
    coalesce(`r`.`region_name`, 'NO REGION')                              AS `region_name`,
    `c`.`updated_at`                                                     AS `updated_at`
FROM {{ ref('TARGET', 'QA_P7_SRC_CUST') }} `c`
LEFT JOIN {{ ref('TARGET', 'QA_P7_SRC_REGION') }} `r` ON `r`.`region_id` = `c`.`region_id`
