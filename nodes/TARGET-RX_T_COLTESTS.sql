@id("7b4c7ae9-8f67-52ef-a7a4-e2c293dfbed2")
@nodeType("SQLWork")
SELECT
    `customer_id`      AS `customer_id`      @not_null @uniqueness @min_value("1"),
    `name`             AS `name`             @not_null @empty,
    `segment`          AS `segment`          @accepted_values("'RETAIL', 'CORPORATE'") @accepted_values("'SMB'"),
    `status`           AS `status`           @rejected_values("'DELETED'", "'TEST'"),
    `balance`          AS `balance`          @min_max("-1000", "100000"),
    `discount`         AS `discount`         @min_value("0") @max_value("0.5"),
    `is_active`        AS `is_active`        @accepted_values(true),
    `signup_date`      AS `signup_date`      @min_max("toDate('2000-01-01')", "today()"),
    `created_at`       AS `created_at`       @max_value("now()"),
    `updated_at`       AS `updated_at`       @freshness(1, "DAY") @relative_time(">=", "created_at")
FROM {{ ref('SRC', 'rx_customer') }}
