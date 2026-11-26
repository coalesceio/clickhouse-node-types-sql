@id("0e1f0a00-0000-4000-8000-00000000030c")
@nodeType("SQLDimension")
@materializationType("view")
@tests("SELECT `alt_key` FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} GROUP BY `alt_key` HAVING count() > 1 OR `alt_key` IS NULL", true, "Before")
SELECT
    `s`.`alt_key`     AS `alt_key`     @id("b3d001") @isBusinessKey,
    `s`.`cust_id`     AS `cust_id`     @id("b3d002"),
    `s`.`city`        AS `city`        @id("b3d003"),
    
    now64(6)                                            AS `SYSTEM_CREATE_DATE`  @id("b3d093") @isSystemCreateDate,
    now64(6)                                            AS `SYSTEM_UPDATE_DATE`  @id("b3d094") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
