@id("08c86b5a-43d9-5cbd-a826-944ead1b696e")
@nodeType("SQLDimension")
@engine("MergeTree")
@mergeStrategy("lastModified")
@orderBy("`n_Nationkey`", "`SYSTEM_VERSION`")
SELECT
    generateUUIDv4()                                     AS `DIM_Nation_Test_KEY` @id("f8e055") @isSurrogateKey @defaultValue("generateUUIDv4()"),
    `n_Nationkey`                                        AS `n_Nationkey`         @id("4fdd08") @isBusinessKey,
    `n_Name`                                             AS `n_Name`              @id("1dcbf7"),
    `n_Regionkey`                                        AS `n_Regionkey`         @id("5db1aa"),
    `last_Modified`                                      AS `last_Modified`       @id("15ef53") @lastModifiedTracking(2),
    1                                                    AS `SYSTEM_VERSION`      @id("cdab35") @isSystemVersion,
    'Y'                                                  AS `SYSTEM_CURRENT_FLAG` @id("e5e916") @isSystemCurrentFlag,
    now64(6)                                             AS `SYSTEM_CREATE_DATE`  @id("2538b2") @isSystemCreateDate,
    now64(6)                                             AS `SYSTEM_UPDATE_DATE`  @id("6b90e8") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6))  AS `SYSTEM_END_DATE`     @id("d9a32f") @isSystemEndDate
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
