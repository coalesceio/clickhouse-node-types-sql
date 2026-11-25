@id("0e1f0a00-0000-4000-8000-000000000147")
@nodeType("SQLWork")
SELECT *, `balance` * 100 AS `balance_cents`
FROM {{ ref('TARGET', 'QA_W_SRC_CUST') }}
