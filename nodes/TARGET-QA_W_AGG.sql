@id("0e1f0a00-0000-4000-8000-000000000114")
@nodeType("SQLWork")
@orderBy("`segment`")
SELECT
    `c`.`segment`                       AS `segment`        @notNull,
    count()                             AS `cnt`,
    countIf(`c`.`cust_name` IS NULL)    AS `null_names`,
    sum(`c`.`balance`)                  AS `sum_balance`,
    avg(`c`.`balance`)                  AS `avg_balance`,
    min(`c`.`updated_at`)               AS `min_upd`,
    max(`c`.`updated_at`)               AS `max_upd`,
    uniqExact(`c`.`region_id`)          AS `uniq_regions`,
    groupArray(`c`.`cust_id`)           AS `cust_ids`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
GROUP BY `c`.`segment`
HAVING count() >= 1
