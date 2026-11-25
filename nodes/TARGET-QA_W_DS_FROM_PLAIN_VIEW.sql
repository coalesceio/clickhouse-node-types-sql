@id("0e1f0a00-0000-4000-8000-000000000162")
@nodeType("SQLWork")
@description("B1 demo: downstream table reading the plain LEFT JOIN view")
SELECT * FROM {{ ref('TARGET', 'QA_W_VIEW_PLAIN') }}
