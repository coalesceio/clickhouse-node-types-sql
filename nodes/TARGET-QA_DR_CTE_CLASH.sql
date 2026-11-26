@id("0e1f0a00-0000-4000-8000-000000000361")
@nodeType("SQLDimension")
WITH `SOURCE_DATA` AS (
    SELECT `cust_id`, `city` FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }}
)
SELECT
    `cust_id` AS `cust_id` @id("f61001") @isBusinessKey,
    `city` AS `city` @id("f61002"),
    now64(6) AS `SYSTEM_CREATE_DATE` @id("f61004") @isSystemCreateDate,
    now64(6) AS `SYSTEM_UPDATE_DATE` @id("f61005") @isSystemUpdateDate
FROM `SOURCE_DATA`
