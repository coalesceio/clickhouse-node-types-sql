@id("b1a00001-0000-4000-8000-000000000022")
@nodeType("SQLFact")
@description("Part-supplier inventory snapshots; a changed quantity or cost is added as a new row")
@mergeStrategy("allColumnMatch")
@orderBy("ps_partkey", "ps_suppkey")
SELECT
     `partsupp`.`ps_partkey` AS `ps_partkey` @id("fp0001") @notNull,
     `partsupp`.`ps_suppkey` AS `ps_suppkey` @id("fp0002") @notNull,
     `partsupp`.`ps_availqty` AS `ps_availqty` @id("fp0003"),
     `partsupp`.`ps_supplycost` AS `ps_supplycost` @id("fp0004"),
     CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("fp0005") @isSystemCreateDate,
     CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("fp0006") @isSystemUpdateDate
FROM {{ ref('SRC', 'partsupp') }} `partsupp`
WHERE `partsupp`.`ps_partkey` IN (SELECT `l_partkey` FROM {{ ref('SRC', 'lineitem') }} WHERE `l_orderkey` <= 500)