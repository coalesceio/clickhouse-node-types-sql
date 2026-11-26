@id("e99490fe-691e-5d1e-9481-2d525dbf086a")
@nodeType("SQLDimension")
@engine("MergeTree")
@mergeStrategy("lastModified")
@orderBy("`c_custkey`")
SELECT
    generateUUIDv4()                         AS `customer_key`       @id("c10000") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `c_custkey`                              AS `c_custkey`          @id("c10001") @isBusinessKey @notNull,
    `c_name`                                 AS `c_name`             @id("c10002"),
    `updated_at`                             AS `updated_at`         @id("c10003") @lastModifiedTracking(1),
    now64(6)                                 AS `SYSTEM_CREATE_DATE` @id("c10008") @isSystemCreateDate,
    now64(6)                                 AS `SYSTEM_UPDATE_DATE` @id("c10009") @isSystemUpdateDate
FROM {{ ref('SRC', 'rx_customer') }} `customer`
