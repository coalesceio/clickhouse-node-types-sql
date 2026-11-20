@id("9e6627ce-bcf2-510c-8294-638d1f8eeb7c")
@nodeType("SQLWork")
@writeMode("append")
SELECT CAST('init' AS String) AS `table_name`, CAST(now() AS DateTime) AS `load_ts` FROM numbers(1)
