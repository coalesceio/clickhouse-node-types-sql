@id("e124365d-4e7a-45a4-9479-3fc2eb90612c")
@nodeType("SQLDimension")
SELECT
    generateUUIDv4()                                    AS "DIM_Nation_Join_Test_KEY" @id("7f3866") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `n`.`n_Nationkey`                                   AS `n_Nationkey`         @id("2cf31b") @isBusinessKey,
    `n`.`n_Name`                                        AS `n_Name`              @id("9b150d") ,
    `p`.`n_Name`                                        AS `partner_name`        @id("12b463"),   -- right side, source NOT NULL
    `n`.`n_Comment`                                     AS `n_Comment`           @id("8c1515"),
    `p`.`n_Comment`                                     AS `partner_comment`     @id("06997e"),   -- right side, source Nullable
    1                                                   AS "SYSTEM_VERSION"      @id("141393") @isSystemVersion,
    'Y'                                                 AS "SYSTEM_CURRENT_FLAG" @id("35a5ed") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_CREATE_DATE"  @id("fbb0eb") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                AS "SYSTEM_UPDATE_DATE"  @id("8ba280") @isSystemUpdateDate @notNull,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE"     @id("6e3529") @isSystemEndDate
FROM {{ ref('SRC', 'Nation_Test') }} `n`
LEFT JOIN {{ ref('SRC', 'Nation_Test') }} `p` ON `p`.`n_Nationkey` = `n`.`n_Nationkey` + 20
