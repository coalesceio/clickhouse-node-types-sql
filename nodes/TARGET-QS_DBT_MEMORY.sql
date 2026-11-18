@id("174468c5-d603-4129-9f9d-82371178a160")
@nodeType("SQLWork")
@preSQL("ALTER USER `tanvi.kamat.contractor` MODIFY SETTINGS max_query_size = 10485760;")
@postSQL("INSERT INTO {{ this }} (`probe_stage`, `max_query_size`) SELECT 'post_sql', toString(getSetting('max_query_size'))")
@querySettings("max_bytes_ratio_before_external_group_by = 0.5", "max_bytes_ratio_before_external_sort = 0.5", "join_algorithm = 'grace_hash'", "max_threads = 8", "max_block_size = 8192", "preferred_block_size_bytes = 2097152", "max_streams_to_max_threads_ratio = 1", "max_insert_threads = 4", "enable_parallel_replicas = 0", "cluster_for_parallel_replicas = 'default'", "max_parallel_replicas = 100", "parallel_replicas_min_number_of_rows_per_replica = 10000000")
@tests("SELECT 1 WHERE getSetting('max_query_size') != 10485760", true, "After")
SELECT
    CAST('load'                                                                   AS String) AS `probe_stage`,
    CAST(toString(getSetting('max_bytes_ratio_before_external_group_by'))         AS String) AS `ratio_ext_group_by`,
    CAST(toString(getSetting('max_bytes_ratio_before_external_sort'))             AS String) AS `ratio_ext_sort`,
    CAST(toString(getSetting('max_memory_usage'))                                 AS String) AS `max_memory_usage`,
    CAST(toString(getSetting('join_algorithm'))                                   AS String) AS `join_algorithm`,
    CAST(toString(getSetting('max_threads'))                                      AS String) AS `max_threads`,
    CAST(toString(getSetting('max_block_size'))                                   AS String) AS `max_block_size`,
    CAST(toString(getSetting('preferred_block_size_bytes'))                       AS String) AS `preferred_block_size_bytes`,
    CAST(toString(getSetting('max_streams_to_max_threads_ratio'))                 AS String) AS `max_streams_to_max_threads_ratio`,
    CAST(toString(getSetting('max_insert_threads'))                               AS String) AS `max_insert_threads`,
    CAST(toString(getSetting('enable_parallel_replicas'))                         AS String) AS `enable_parallel_replicas`,
    CAST(toString(getSetting('cluster_for_parallel_replicas'))                    AS String) AS `cluster_for_parallel_replicas`,
    CAST(toString(getSetting('max_parallel_replicas'))                            AS String) AS `max_parallel_replicas`,
    CAST(toString(getSetting('parallel_replicas_min_number_of_rows_per_replica')) AS String) AS `parallel_replicas_min_rows_per_replica`,
    CAST(toString(getSetting('max_query_size'))                                   AS String) AS `max_query_size`
FROM numbers(1)
