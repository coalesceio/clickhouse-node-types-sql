@id("4e583f6b-eb19-4aeb-9fa7-882b5201a873")
@nodeType("SQLFact")
@description("Employee fact - INSERT + DELETE load, change tracking SCD Type 1, plain MergeTree")
@engine("MergeTree")
@orderBy("id")
@mergeStrategy("changeTracking")
SELECT
    "id"                                           AS "id"                     @id("b71c20") @isBusinessKey @notNull,
    "name"                                         AS "name"                   @id("c40e8a"),
    "department"                                   AS "department"             @id("d9a312"),
    "salary"                                       AS "salary"                 @id("e2f574"),
    "created_at"                                   AS "created_at"             @id("f61b09"),
    now64(6)                                       AS "SYSTEM_CREATE_DATE"     @id("a8d4c3") @isSystemCreateDate,
    now64(6)                                       AS "SYSTEM_UPDATE_DATE"     @id("9b37e1") @isSystemUpdateDate
FROM {{ ref('SRC', 'employee') }} "employee"
