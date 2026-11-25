@id("f52bc508-c7d9-4994-8bd2-9d4e09bec562")
@nodeType("SQLFact")
@description("AN pipeline - factless Fact: which supplier ships which part by which ship mode; allColumnMatch inserts new combinations only")
@materializationType("table")
@writeMode("append")
@mergeStrategy("allColumnMatch")
@settings("index_granularity = 8192")
@querySettings("max_threads = 8", "max_memory_usage = 20000000000", "max_bytes_before_external_group_by = 10000000000", "max_bytes_in_join = 10000000000")
@optimize
@tests("SELECT 1 FROM {{ this }} FINAL WHERE `supplier_sk` NOT IN (SELECT `supplier_sk` FROM {{ ref('TARGET', 'AN_DIM_SUPPLIER') }} FINAL)", true, "After")
SELECT
    coalesce(`d`.`supplier_sk`, toUUID('00000000-0000-0000-0000-000000000000'))
                                  AS `supplier_sk`        @id("afs01") @notNull @description("Supplier surrogate key from AN_DIM_SUPPLIER; zero key when unresolved") @not_null,
    `w`.`supplier_key`            AS `supplier_id`        @id("afs02") @notNull @description("Supplier business key (l_suppkey)") @not_null,
    `w`.`part_key`                AS `part_id`            @id("afs03") @notNull @description("Part business key (l_partkey)") @not_null,
    `w`.`ship_mode`               AS `ship_mode`          @id("afs04") @notNull @description("Shipping mode") @accepted_values("'AIR', 'REG AIR', 'RAIL', 'SHIP', 'TRUCK', 'MAIL', 'FOB'"),
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_CREATE_DATE` @id("afs05") @isSystemCreateDate @notNull @description("Load time the combination was first seen"),
    CAST(now64(6) AS DateTime64(6)) AS `SYSTEM_UPDATE_DATE` @id("afs06") @isSystemUpdateDate @notNull @relative_time(">=", "SYSTEM_CREATE_DATE")
FROM {{ ref('TARGET', 'AN_WRK_LINEITEM') }} `w`
LEFT JOIN {{ ref('TARGET', 'AN_DIM_SUPPLIER') }} `d`
  ON `d`.`supplier_id` = `w`.`supplier_key`
GROUP BY `d`.`supplier_sk`, `w`.`supplier_key`, `w`.`part_key`, `w`.`ship_mode`
