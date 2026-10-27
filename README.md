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

`@orderBy` and `@primaryKey` are written to ClickHouse as given and are not checked by the
node types. ClickHouse itself rejects invalid keys, for example a `@primaryKey` that is not the
leading terms of `@orderBy`, or a key that names a column the node no longer has. A rejected
create or redeploy leaves the existing table unchanged (a redeploy fails on the clone or on
`CREATE OR REPLACE`, before anything replaces the live table).

## Column type changes

A redeploy changes a column's type with `ALTER TABLE ... MODIFY COLUMN` on the clone, with
`SETTINGS alter_sync = 2` so the deploy waits for ClickHouse to convert the existing values
(ClickHouse Cloud does not wait by default):

| Change | Result |
|---|---|
| Values convert (e.g. `'10'` → `UInt32`) | Converted, deploy succeeds |
| `Nullable` → not null while the column has NULLs and no `@defaultValue` | Deploy fails: *Cannot convert column ... Please specify `DEFAULT`*. Add `@defaultValue` to fill the NULLs |
| A value the new non-`Nullable` type cannot take (e.g. `'n/a'` → `UInt32`) | Deploy fails: *Mutation ... failed to finish ... Cannot parse string*. The live table is not changed |
| A value the new `Nullable` type cannot take (e.g. `'ALGERIA'` → `Nullable(UInt32)`) | **Deploy succeeds and ClickHouse stores NULL for that value** |

The last case is not an error in ClickHouse, so the node types cannot stop it. Check the data
before changing a column to a `Nullable` type, for example:

```sql
SELECT count() FROM <table> WHERE c IS NOT NULL AND toUInt32OrNull(c) IS NULL;
```

A failed conversion leaves an unfinished mutation on the clone table
(`<name>_COALESCE_INTERNAL_TABLE`); the next redeploy replaces the clone.

## Fact merge strategies

ClickHouse has no `MERGE`, so a Fact load is an `INSERT` of the rows a merge would apply,
followed by a clean-up `DELETE` of the copies it replaces (per business key only the row with
the latest `SYSTEM_UPDATE_DATE` is kept).

| `@mergeStrategy` | Matches on | What the load does |
|---|---|---|
| `changeTracking` (default when `@mergeStrategy` is not set) | `@isBusinessKey` columns | New keys are inserted; changed rows are re-inserted with a newer `SYSTEM_UPDATE_DATE` and the older copy is removed |
| `lastModified` | `@isBusinessKey` columns, plus exactly one `@lastModifiedTracking` column | Only rows newer than the target's are loaded, then as `changeTracking` |
| `allColumnMatch` | Every non-system column (`@isBusinessKey` is ignored) | Only rows with no fully matching row in the target are inserted; nothing is updated or deleted |

A Fact with no `@isBusinessKey` column and no `@mergeStrategy` is loaded as a plain insert.

`upsert` is not supported: without `MERGE` there is no separate upsert behaviour in ClickHouse.
Use `changeTracking`.

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

### Array and Map columns show as changed on every deploy

Coalesce marks every column of a SQL node as nullable. ClickHouse cannot make `Array` or `Map`
columns `Nullable`, so the node types create them as plain `Array(...)` / `Map(...)`, and
after a deploy the deployed state records those columns as not nullable.

The next plan compares the workspace (`nullable: true`) with the deployed state
(`nullable: false`), so it lists the node as changed on every deploy, for example:

```
columns > c_array > nullable : false → true
columns > c_map   > nullable : false → true
```

The redeploy finds nothing to alter in ClickHouse and runs only `Metadata Update-Default`, so
the table is not affected. Until Coalesce stops marking these columns as nullable, add
`@notNull` to `Array` and `Map` columns so the workspace matches the deployed state.
