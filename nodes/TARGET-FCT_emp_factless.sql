@id("0f07cddf-3354-4201-8d9e-1bc3eab43eae")
@nodeType("SQLFact")
@description("Factless fact - employee / department / hire date, keys only, allColumnMatch (insert only new combinations)")
@orderBy("id", "department", "created_date")
@mergeStrategy("allColumnMatch")
SELECT
    "id"                                           AS "id"            @id("8a1c4e") @notNull,
    "department"                                   AS "department"    @id("9b2d5f") @notNull,
    toDate("created_at")                           AS "created_date"  @id("ac3e60") @notNull
FROM {{ ref('SRC', 'employee') }} "employee"
