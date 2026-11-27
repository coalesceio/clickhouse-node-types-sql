@id("0e1f0a00-0000-4000-8000-0000000003b1")
@nodeType("SQLDimension")
@engine("MergeTree")
@writeMode("truncate")
@mergeStrategy("changeTracking")
SELECT
    CAST(`c1` AS UInt32) AS `id`   @id("b6a001") @isBusinessKey,
    CAST(`c2` AS String) AS `name` @id("b6a002"),
    now64(6) AS `SYSTEM_CREATE_DATE` @id("b6a090") @isSystemCreateDate,
    now64(6) AS `SYSTEM_UPDATE_DATE` @id("b6a091") @isSystemUpdateDate
FROM values('c1 UInt32, c2 String', (1, 'a'), (2, 'b'))
