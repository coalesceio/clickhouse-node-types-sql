# clickhouse-node-types-sql
Base node types sql-Clickhouse

## ClickHouse Cloud defaults (Work)

Work tables are created without the clauses ClickHouse Cloud adds by itself:

- `ENGINE = MergeTree` is not written (Work has no `@engine`); Cloud creates
  `ENGINE = SharedMergeTree('/clickhouse/tables/{uuid}/{shard}', '{replica}')`.
- `ORDER BY tuple()` is not written when the node has no `@orderBy` / `@primaryKey`; Cloud adds it.
- `SETTINGS index_granularity = 8192` is never written unless `@settings` sets it; Cloud adds it.

These rely on Cloud's `default_table_engine` and `create_table_empty_primary_key_by_default`
settings. Fact and Dimension still write `ENGINE` (MergeTree, or `@engine`) and `ORDER BY tuple()`.

## Known limitations

### `Variant` columns in SQL nodes

Coalesce does not infer the `Variant` data type correctly when it reads a SQL node's `SELECT`.
A source column of type `Variant(Array(UInt64), String, UInt64)` is inferred on the downstream
SQL node as `String(Array(UInt64), String, UInt64)`, which is not a valid ClickHouse type, so
the node's create fails with:

```
String data type family mustn't have more than one argument - size in characters
```

The node types do not try to repair the inferred type. Until Coalesce infers `Variant`
correctly, convert the column in the `SELECT` to a type Coalesce understands, for example:

```sql
toString(`c_Variant`) AS `c_Variant`,
```

or leave the column out of the node.
