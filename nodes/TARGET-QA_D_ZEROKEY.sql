@id("0e1f0a00-0000-4000-8000-000000000308")
@nodeType("SQLDimension")
@zeroKey("22222222-2222-2222-2222-222222222222", "'UNK'", "1900-01-01 00:00:00", false)
@engine("mergetree")
@orderBy("`cust_id`")
SELECT
    generateUUIDv4() AS `QA_D_ZEROKEY_KEY` @id("a8d000") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `s`.`cust_id`                                  AS `cust_id`     @id("a8d001") @isBusinessKey @zeroKey("999999"),
    `s`.`cust_name`                                AS `cust_name`   @id("a8d002"),
    `s`.`city`                                     AS `city`        @id("a8d003") @zeroKey("'N/A'"),
    CAST(`s`.`code` AS Nullable(FixedString(2)))   AS `code`        @id("a8d004"),
    toDate(`s`.`updated_at`)                       AS `upd_date`    @id("a8d005"),
    toDateTime(`s`.`updated_at`)                   AS `upd_dt`      @id("a8d006"),
    CAST(`s`.`updated_at` AS DateTime64(3))        AS `upd_dt64`    @id("a8d007"),
    `s`.`tier` = 'GOLD'                            AS `is_gold`     @id("a8d008"),
    generateUUIDv4()                                  AS `ext_uuid`    @id("a8d009"),
    CAST(10.5 AS Decimal(10, 2))                      AS `amt`         @id("a8d010"),
    
    now64(6)                                            AS `SYSTEM_CREATE_DATE`  @id("a8d093") @isSystemCreateDate,
    now64(6)                                            AS `SYSTEM_UPDATE_DATE`  @id("a8d094") @isSystemUpdateDate
FROM {{ ref('TARGET', 'QA_W_SRC_DIM') }} `s`
