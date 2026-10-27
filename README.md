# clickhouse-node-types-sql
Base node types sql-Clickhouse

## ClickHouse Cloud defaults (Work, Fact, Dimension)

Tables are always MergeTree (there is no `@engine`) and are created without the clauses
ClickHouse Cloud adds by itself:

- `ENGINE = MergeTree` is not written; Cloud creates
  `ENGINE = SharedMergeTree('/clickhouse/tables/{uuid}/{shard}', '{replica}')`.
- `ORDER BY tuple()` is not written when the node has no `@orderBy` / `@primaryKey`; Cloud adds it.
- `SETTINGS index_granularity = 8192` is never written unless `@settings` sets it; Cloud adds it.

These rely on Cloud's `default_table_engine` and `create_table_empty_primary_key_by_default`
settings.

## NULLs in non-nullable columns

Columns are created as `Nullable(<type>)` unless the column is marked not-null in Coalesce,
in which case the plain `<type>` is written.

ClickHouse does not reject a NULL inserted into a non-nullable column. With its default
`insert_null_as_default = 1`, an `INSERT ... SELECT` silently stores the column's default
instead: `0`, `''`, zero bytes for `FixedString`, or the column's `DEFAULT` expression.

To make such an insert fail instead, set:

```sql
SETTINGS insert_null_as_default = 0
```

The run templates do not add this setting to their `INSERT` statements, so it has to be set
at the user (or settings profile) level for the user Coalesce connects as, for example:

```sql
ALTER USER <coalesce_user> SETTINGS insert_null_as_default = 0;
```

ClickHouse writes an `INSERT ... SELECT` in blocks, so an insert that fails part way can leave
earlier blocks in the table. A `not_null` test run before the load catches NULLs before
anything is written.

## UUID surrogate keys

A UUID surrogate key is a `UUID` column with a default value of `generateUUIDv4()`; the
Dimension load leaves the surrogate key out of its inserts, so each new row gets a new UUID.

- **Zero key record:** a `UUID` surrogate key gets the nil UUID
  `00000000-0000-0000-0000-000000000000`; other surrogate keys get `surrogateKeyValue`.
- **Adding the column to an existing table:** ClickHouse computes a new column's `DEFAULT` on
  read for rows already in the table, so `generateUUIDv4()` would give those rows a different
  value on every query. The redeploy runs `MATERIALIZE COLUMN` after `ADD COLUMN` for every new
  column with a default, so the values are written once.

## Sort key changes and `@primaryKey`

ClickHouse cannot change a table's `PRIMARY KEY` or `PARTITION BY` in place. Without
`@primaryKey`, the primary key is the whole `@orderBy`, so **any** change to `@orderBy` is a
primary key change.

On redeploy:

| Change | Result |
|---|---|
| `@orderBy` changed, no `@primaryKey` | Table recreated |
| `@primaryKey` changed | Table recreated |
| `@partitionBy` changed | Table recreated |
| Key column renamed or its type changed | Table recreated |
| `@primaryKey` unchanged, trailing `@orderBy` terms removed | Altered in place (`MODIFY ORDER BY`) |
| `@primaryKey` unchanged, new columns added at the end of `@orderBy` | Altered in place (`ADD COLUMN` + `MODIFY ORDER BY`) |

A recreated table is created with `CREATE OR REPLACE` and its existing data is **not kept**:
it is empty until the next run reloads it. The deploy shows a
`Warning: Table Recreated (<reason>)` stage when this happens.

To keep later sort-key changes cheap, set `@primaryKey` to the leading column(s) of
`@orderBy` when the node is first created.

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
