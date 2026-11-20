@id("961d5625-efbe-50c7-aa14-3156ea2aa878")
@nodeType("SQLWork")
@tests("SELECT `customer_id` FROM {{ ref('SRC', 'rx_customer') }} GROUP BY `customer_id` HAVING count() > 1", false, "Before")  -- runs Before the load, continueOnFailure=false
@tests("SELECT 1 FROM {{ ref('SRC', 'rx_customer') }} HAVING count() = 0", true, "Before")  -- runs Before the load, continueOnFailure=true
@tests("SELECT 1 FROM {{ this }} WHERE `balance` < 0 AND `status` = 'ACTIVE'")  -- runs After the load (default), continueOnFailure=true (default)
@tests("SELECT 1 FROM {{ this }} HAVING count() <> (SELECT count() FROM {{ ref('SRC', 'rx_customer') }})", true, "After")  -- runs After the load, continueOnFailure=true
SELECT
    `customer_id`      AS `customer_id`,
    `balance`          AS `balance`,
    `status`           AS `status`
FROM {{ ref('SRC', 'rx_customer') }}
