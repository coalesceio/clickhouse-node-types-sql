@id("b6d2a4e1-3c5f-4e7a-9b1d-0f8c2e6a4d71")
@nodeType("SQLWork")
@description("Pipeline - cleaned nation list, materialized as a view")
@materializationType("view")
SELECT
    "n_nationkey"                                  AS "n_nationkey"    @id("1a2b3c") @description("Nation key") @notNull @not_null @uniqueness @min_max("0", "24"),
    replaceAll(toString("n_name"), '\0', '')       AS "nation_name"    @id("2b3c4d") @description("Nation name without FixedString padding") @not_null @empty,
    "n_regionkey"                                  AS "n_regionkey"    @id("3c4d5e") @description("Region key") @accepted_values("0, 1, 2") @accepted_values("3", "4"),
    "n_comment"                                    AS "n_comment"      @id("4d5e6f") @description("Free-text comment")
FROM {{ ref('SRC', 'nation') }} "nation"
