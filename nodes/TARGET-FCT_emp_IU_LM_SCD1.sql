@id("5842b88f-0188-4110-97a2-4afab43dfe1a")
@nodeType("SQLFact")
@description("Employee fact - INSERT + DELETE load, last modified SCD Type 1, plain MergeTree")
@engine("MergeTree")
@orderBy("id")
@mergeStrategy("lastModified")
SELECT
    "id"                                           AS "id"                     @id("1a6f2d") @isBusinessKey @notNull,
    "name"                                         AS "name"                   @id("2c8b47"),
    "department"                                   AS "department"             @id("3e0d65"),
    "salary"                                       AS "salary"                 @id("4f2a83"),
    "created_at"                                   AS "created_at"             @id("5b4c91") @lastModifiedTracking,
    now64(6)                                       AS "SYSTEM_CREATE_DATE"     @id("6d7e1f") @isSystemCreateDate,
    now64(6)                                       AS "SYSTEM_UPDATE_DATE"     @id("7f9a3b") @isSystemUpdateDate
FROM {{ ref('SRC', 'employee') }} "employee"
