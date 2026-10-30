@id("71b1e6f4-b35a-4726-bf1e-b72fd00b6717")
@nodeType("SQLWork")
SELECT
     `n_nationkey` AS `n_nationkey`,
     `n_name` AS `n_name`,
     `n_regionkey` AS `n_regionkey`,
     `n_comment` AS `n_comment`
FROM {{ ref('SRC', 'nation') }} `nation`