@id("0e1f0a00-0000-4000-8000-000000000161")
@nodeType("SQLWork")
@description("B1 demo: downstream table reading the @joinUseNulls Nullable view")
SELECT * FROM {{ ref('TARGET', 'QA_W_VIEW_JUN_NULLABLE') }}
