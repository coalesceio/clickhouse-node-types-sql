@id("0e1f0a00-0000-4000-8000-000000000133")
@nodeType("SQLWork")
@orderBy("`n_Nationkey`")
@tests("SELECT 1 FROM {{ this }} HAVING count() <> (SELECT count() FROM {{ ref('SRC', 'Nation_Test') }})", true, "After")
SELECT
    `Nation_Test`.`n_Nationkey`     AS `n_Nationkey`    @not_null @uniqueness,
    `Nation_Test`.`n_Name`          AS `n_Name`         @empty,
    `Nation_Test`.`n_Regionkey`     AS `n_Regionkey`,
    `Nation_Test`.`n_Comment`       AS `n_Comment`      @rejected_values("'NA'"),
    `Nation_Test`.`last_Modified`   AS `last_Modified`  @min_max("'2020-01-01'", "now()")
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
