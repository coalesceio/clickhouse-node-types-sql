@id("0e1f0a00-0000-4000-8000-00000000040d")
@nodeType("SQLFact")
@querySettings("transform_null_in = 0")
SELECT
    `f`.`qty`         AS `qty`         @id("cde001") @isBusinessKey,
    `f`.`order_id`    AS `order_id`    @id("cde002"),
    now64(6)            AS `SYSTEM_CREATE_DATE` @id("cde090") @isSystemCreateDate,
    now64(6)            AS `SYSTEM_UPDATE_DATE` @id("cde091") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_FACT') }} `f`
