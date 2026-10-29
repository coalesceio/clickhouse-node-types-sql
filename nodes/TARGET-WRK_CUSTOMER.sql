@id("9433f26f-e27e-464c-a729-372e913d177b")
@nodeType("SQLWork")
@writeMode("truncateInsert")
SELECT
    COALESCE(`c_custkey`, 0)                  AS `c_custkey`    @notNull @not_null @uniqueness,
    TRIM(COALESCE(`c_name`, ''))               AS `c_name`       @notNull @not_null @empty,
    COALESCE(`c_address`, '')                 AS `c_address`,
    COALESCE(`c_nationkey`, 0)                AS `c_nationkey`  @notNull @not_null,
    COALESCE(`c_phone`, '')                   AS `c_phone`,
    COALESCE(`c_acctbal`, 0)                  AS `c_acctbal`    @notNull @min_max(-999.99, 9999.99),
    UPPER(TRIM(COALESCE(`c_mktsegment`, '')))  AS `c_mktsegment` @notNull @accepted_values("'AUTOMOBILE'", "'BUILDING'", "'FURNITURE'", "'HOUSEHOLD'", "'MACHINERY'"),
    COALESCE(`c_comment`, '')                 AS `c_comment`
FROM {{ ref('SRC', 'STG_customer') }} `STG_customer`
