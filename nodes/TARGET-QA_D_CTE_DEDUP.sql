@id("0e1f0a00-0000-4000-8000-000000000313")
@nodeType("SQLDimension")
WITH `src` AS (
    SELECT `cust_id`, `city`, `updated_at` FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }}
    QUALIFY row_number() OVER (PARTITION BY `cust_id` ORDER BY `updated_at` DESC) = 1
)
SELECT
    `cust_id`     AS `cust_id`     @id("c1d001") @isBusinessKey,
    `city`        AS `city`        @id("c1d003"),
    
    now64(6)                                            AS `SYSTEM_CREATE_DATE`  @id("c1d093") @isSystemCreateDate,
    now64(6)                                            AS `SYSTEM_UPDATE_DATE`  @id("c1d094") @isSystemUpdateDate
FROM `src`
