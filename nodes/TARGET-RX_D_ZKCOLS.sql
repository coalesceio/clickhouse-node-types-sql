@id("9b48c53e-0daa-5bb0-b613-f2bac70ccc69")
@nodeType("SQLDimension")
@engine("MergeTree")
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'", "1900-01-01 00:00:00", true)
SELECT
    generateUUIDv4() AS `k` @id("e00001") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `c_custkey` AS `c_custkey` @id("e00002") @isBusinessKey @notNull,
    `c_name` AS `c_name` @id("e00003") @zeroKey("'N/A'"),
    CAST(`customer_id` AS Int32) AS `num` @id("e00004") @zeroKey("-1"),
    `balance` AS `dec` @id("e00005") @zeroKey("0.00"),
    `signup_date` AS `dt` @id("e00006") @zeroKey("toDate('1970-01-01')"),
    CAST(`created_at` AS DateTime64(6)) AS `dt64` @id("e00007") @zeroKey("toDateTime64('1900-01-01 00:00:00', 6)"),
    `is_active` AS `flag` @id("e00008") @zeroKey(false),
    [`c_name`] AS `arr` @id("e00009") @zeroKey("[]"),
    CAST(now() AS DateTime) AS `SYSTEM_CREATE_DATE` @id("e00010") @isSystemCreateDate,
    CAST(now() AS DateTime) AS `SYSTEM_UPDATE_DATE` @id("e00011") @isSystemUpdateDate @notNull
FROM {{ ref('SRC', 'rx_customer') }} `customer`
