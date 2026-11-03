@id("12b01526-409f-4b0b-b046-a7e0edfee2f8")
@nodeType("SQLWork")
SELECT
     `id` AS `id`,
     `name` AS `name`,
     `department` AS `department`,
     `salary` AS `salary`,
     `created_at` AS `created_at`
FROM {{ ref('SRC', 'employee') }} `employee`