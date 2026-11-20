@id("9d203130-99f9-5243-a2e4-1c484c53a560")
@nodeType("SQLWork")
@description("Time dimension: one row per minute of the day")
SELECT
    toUInt16(number)                                          AS `time_key` @notNull @uniqueness,
    toUInt8(intDiv(number, 60))                               AS `hour_24`,
    toUInt8(number % 60)                                      AS `minute`,
    toUInt8(if(intDiv(number, 60) % 12 = 0, 12, intDiv(number, 60) % 12)) AS `hour_12`,
    if(number < 720, 'AM', 'PM')                              AS `am_pm`,
    concat(leftPad(toString(intDiv(number, 60)), 2, '0'), ':', leftPad(toString(number % 60), 2, '0')) AS `hh_mm`,
    multiIf(number < 360, 'Night', number < 720, 'Morning', number < 1080, 'Afternoon', 'Evening') AS `day_part`
FROM numbers(1440)
