@id("0e1f0a00-0000-4000-8000-000000000213")
@nodeType("SQLWork")
@orderBy("`cust_id`")
@settings("index_granularity = 8192", "merge_with_ttl_timeout = 7200", "ttl_only_drop_parts = 1")
SELECT
    `c`.`cust_id`       AS `cust_id`,
    `c`.`segment`       AS `segment`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }} `c`
