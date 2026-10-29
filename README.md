# SQL-First NodeTypes for ClickHouse

The [SQL-first nodes](https://docs.coalesce.io/docs/build-your-pipeline/v2-node-types) is a transformation tool within Coalesce that lets developers write custom, hand-coded SQL instead of using the standard graphical column-mapping interface. It is ideal for complex transformations, advanced window functions, or multi-step logic that is difficult to represent with the standard UI, and ships with a built-in library of column- and node-level data quality tests. While it provides maximum flexibility, it shifts the responsibility of column definition and logic maintenance to the SQL author.

# Coalesce Base Node Types - SQL Package (ClickHouse)

The Coalesce Base Node Types - SQL Package for ClickHouse includes:

* [Work](#work)
* [Dimension](#dimension)
* [Fact](#fact)

Concepts shared across every node type — ClickHouse table defaults, sort and partition keys, column types, data quality tests, known limitations, and usage examples — are documented once in [Common Reference](#common-reference) and linked to from each node type below.

## Node Type Comparison

A side-by-side view of which annotations each node type supports, so it's easy to see what a given node type is missing compared to the others.

### Node Annotations Matrix

| Annotation | Work | Dimension | Fact |
|---|---|---|---|
| `@materializationType` | table / view | table / view | table / view |
| `@orderBy` | ✅ | ✅ | ✅ |
| `@primaryKey` | ✅ | ✅ | ✅ |
| `@partitionBy` | ✅ | ✅ | ✅ |
| `@settings` | ✅ | ✅ | ✅ |
| `@writeMode` | ✅ | ✅ | ✅ |
| `@mergeStrategy` | ➖ | ✅<br/>* changeTracking<br/>* lastModified | ✅<br/>* changeTracking<br/>* lastModified<br/>* allColumnMatch |
| `@zeroKey` (node-level) | ➖ | ✅ | ➖ |
| `@disableTests` | ✅ | ✅ | ✅ |
| `@tests` | ✅ | ✅ | ✅ |
| `@preSQL` | ✅ | ✅ | ✅ |
| `@postSQL` | ✅ | ✅ | ✅ |
| Target Load | (TRUNCATE) INSERT | (TRUNCATE) INSERT + clean-up DELETE | (TRUNCATE) INSERT (+ clean-up DELETE) |

### Column Annotations Matrix

| Annotation | Work | Dimension | Fact |
|---|---|---|---|
| `@id` ***(required)*** | ➖ ⁴ | ✅ | ✅ |
| `@isBusinessKey` | ➖ | ✅<br/>***(required)*** | ✅<br/>***(conditional)*** ³ |
| `@isChangeTracking` | ➖ | ✅ | ➖ |
| `@lastModifiedTracking` | ➖ | ✅ | ✅ |
| `@zeroKey` (column-level) | ➖ | ✅ | ➖ |
| `@isSurrogateKey` | ➖ | ✅ | ➖ |
| `@isSystemVersion` | ➖ | ✅ | ➖ |
| `@isSystemCurrentFlag` | ➖ | ✅ | ➖ |
| `@isSystemCreateDate` | ➖ | ✅ | ✅ |
| `@isSystemUpdateDate` | ➖ | ✅ | ✅ |
| `@isSystemEndDate` | ➖ | ✅  | ➖ |
| `@inHash` | ✅ | ✅ | ✅ |
| all column tests | ✅ | ✅ | ✅ |

> See [Column-Level Data Quality Tests](#column-level-data-quality-tests) for the shared quality-test annotations in the last row.
>
> ³ Fact: required for an explicit `@mergeStrategy` of `changeTracking` or `lastModified`; optional otherwise — with neither `@mergeStrategy` nor `@isBusinessKey` the node is a plain insert, and `allColumnMatch` ignores it. See [Fact Load Behaviour](#fact-load-behaviour).
>
> ⁴ Work: optional. A Work column without `@id` is renamed by dropping it and adding a new column — see [Altering the Work Tables](#altering-the-work-tables).

## Work

The Work node is a general-purpose transformation node within Coalesce, used to materialize intermediate or staging-layer tables and views as part of a larger transformation pipeline. It sits between raw source data and downstream modeled objects, giving developers a flexible landing point to shape, clean, and validate data — complete with a built-in library of column- and node-level data quality tests — before it flows further into the pipeline.

### Work Node Configuration

The Work Node type has three configuration groups:

* [General](#work-general-options)
* [Node Annotations](#work-node-annotations)
* [Column Annotations](#work-column-annotations)

#### Work General Options

| **Property** | **Description** |
|----------|-------------|
| **Storage Location** | Storage Location (ClickHouse database) where the Work table or view will be created |
| **Node Type** | Read-only: the node type's name and ID — **Work** (`SQLWork`). Set from `@nodeType` when the node is created; the ID has a copy button. |

### Work Node Annotations

| **Annotation** | **Summary** |
|---|---|
| `@id(id)` ***(reserved)*** | Unique identifier for the node.<br/>Static and auto-generated when the node is created — not meant to be edited. |
| `@nodeType(type)` ***(reserved)*** | Identifies the node's type.<br/>Set automatically based on the node type chosen when the node is created. |
| `@description(text)` ***(reserved)*** | Node-level description, written as the table or view `COMMENT`.<br/>Can be edited via this annotation or in the node description field below the node name in the UI.<br/>Example: `@description("Table description")` |
| [`@materializationType(type)`](#materializationtype) ***(reserved)*** | Table or view |
| `@deployDisabled` ***(reserved)*** | Excludes this node from deployment. |
| [`@orderBy(term, ...)`](#orderby) | The table's `ORDER BY` (sort) key. |
| [`@primaryKey(term, ...)`](#primarykey) | The table's `PRIMARY KEY` — the leading terms of `@orderBy`. |
| [`@partitionBy(term, ...)`](#partitionby) | The table's `PARTITION BY` key. |
| [`@settings(setting, ...)`](#settings) | The table's MergeTree `SETTINGS`. |
| [`@writeMode("truncateInsert \| append")`](#writemode) | How each run writes to the target: truncateInsert or append<br/>*Not specified in the SQL editor → defaults to **truncateInsert**.* |
| [`@disableTests`](#disabletests) **²** | Controls whether configured tests are skipped. |
| [`@tests(querySQL, continueOnFailure?, runOrder?)`](#tests) **²** ***(repeatable)*** | Node-level data quality test. |
| [`@preSQL(querySQL)`](#presql) ***(repeatable)*** | SQL statement to execute `before` the data load operation. |
| [`@postSQL(querySQL)`](#postsql) ***(repeatable)*** | SQL statement to execute `after` the data load operation. |

### Work Column Annotations

| **Annotation** | **Summary** |
|---|---|
| `@notNull` ***(reserved)*** | Creates the column with its plain type instead of `Nullable(<type>)` — see [Column Types](#column-types).<br/>Example: `@notNull` |
| `@description(<text>)` ***(reserved)*** | Adds the column `COMMENT`.<br/>Example: `@description("timestamp column")` |
| [`@defaultValue(<value>)`](#defaultvalue) ***(reserved)*** | Adds a `DEFAULT` expression. |
| [`@inHash("<hashName>", <hashOrder>)`](#inhash) **¹** ***(repeatable)*** | Marks a column as an input to a generated hash key. |

> Details for each annotation are in the [Annotation Reference](#annotation-reference).

>**Note:** Identifier quoting inside `@tests`, `@preSQL`, `@postSQL` and the key annotations — see [Identifier Quoting in Annotations](#identifier-quoting-in-annotations).

🚦 The full set of column-level data quality tests (`@not_null`, `@uniqueness`, `@empty`, `@accepted_values`, `@rejected_values`, `@min_max`, `@min_value`, `@max_value`, `@freshness`, `@relative_time`) applies to Work columns exactly as described in [Column-Level Data Quality Tests](#column-level-data-quality-tests).

---

### Work Deployment

Every deployment of a Work node first runs this check, which stops the deployment before any change in ClickHouse:

| **Stage** | **Description** |
|-----------|----------------|
| **Unsupported Materialization Type: \<node\>** | `@materializationType` is not `table` or `view` — fails with `Validation failed: Unsupported Materialization Type: <node>` |

#### Work Initial Deployment

When deployed for the first time into an Environment, the Work Node executes one of these stages, depending on its materialization type:

| **Stage** | **Description** |
|-----------|----------------|
| **Create table** | Executes a `CREATE OR REPLACE TABLE` statement with the column types, defaults and comments, `PARTITION BY`, `ORDER BY`, `PRIMARY KEY`, `SETTINGS` and the table comment — see [ClickHouse Cloud Defaults](#clickhouse-cloud-defaults) |
| **Create View** | Executes a `CREATE OR REPLACE VIEW` statement with a typed column list, the column comments and the view comment |

#### Work Redeployment

After the Work Node has been deployed for the first time into a target Environment, subsequent deployments either alter the existing object, recreate it, or only record a metadata update when nothing in the object changed (for example tests, `@writeMode`, `@preSQL`/`@postSQL`, or a transform or join on a table):

| **Stage** | **Description** |
|-----------|----------------|
| **Metadata Update-Default** | The node changed, but nothing in ClickHouse needs to change |

#### Altering the Work Tables

Changes to columns, the table description, `@settings`, an `@orderBy` change ClickHouse can alter in place, or the table name or location alter the Work Table, whether made individually or all together. The changes are made on an internal clone of the table, so a failure leaves the live table untouched.

The following stages are executed, in this order (each one only when needed):

| **Stage** | **Description** |
|-----------|----------------|
| **Clone Table** | `CREATE OR REPLACE TABLE <table>_COALESCE_INTERNAL_TABLE CLONE AS <table>` — copies the schema and data. `OR REPLACE` also replaces a clone left behind by a failed deployment. |
| **Alter Column** | One `ALTER TABLE ... MODIFY COLUMN` per changed column: data type and nullability, default (or `REMOVE DEFAULT`) and comment. Runs with `SETTINGS alter_sync = 2` — see [Column Type Changes](#column-type-changes) |
| **Add Column** | Adds new columns with their type, default and comment; when the sort key gains a new column, `MODIFY ORDER BY` is part of the same `ALTER` |
| **Materialize Column Default** | `MATERIALIZE COLUMN` for each new column with a `@defaultValue`, so existing rows get the value written once (`SETTINGS mutations_sync = 2`) |
| **Rename Column** | Renames a column whose `@id` is unchanged, one stage per column |
| **Modify Order By** | `MODIFY ORDER BY` when trailing `@orderBy` terms were removed (before **Drop Column**: ClickHouse cannot drop a column in the same `ALTER` that takes it out of the sort key) |
| **Drop Column** | Drops removed columns |
| **Modify Settings** | `MODIFY SETTING` for each `@settings` value added or changed |
| **Reset Settings** | `RESET SETTING` for each `@settings` value removed |
| **Edit Table Description** | `MODIFY COMMENT` with the new table description |
| **Swap Cloned Table** | `EXCHANGE TABLES` swaps the altered clone with the live table |
| **Drop Cloned Table** | Drops the clone (now holding the old table) after the swap |
| **Rename Table** | Instead of the swap, when the table is renamed or moved: the clone is renamed to the new name/location |
| **Drop Table** | After a rename, drops the table at the old path |

> **Note:** A column is renamed only when its `@id` stays the same. A Work column has no `@id` unless you add one — Coalesce then uses its name as the id, so renaming it drops the column and adds a new one, which loses its data. Give a Work column a stable `@id("<6 hex digits>")` to rename it safely.

> **Note:** Column type changes are converted by ClickHouse on the clone, and some bad conversions do not fail — see [Column Type Changes](#column-type-changes).

#### Recreating the Work Tables

A change ClickHouse cannot `ALTER` — `@partitionBy`, `@primaryKey`, most `@orderBy` changes, or renaming / retyping a column used in a key — recreates the table instead. **Its existing data is lost**; it stays empty until the next run reloads it. See [Sort Key and Partition Key Changes](#sort-key-and-partition-key-changes).

| **Stage** | **Description** |
|-----------|----------------|
| **Warning: Table Recreated (\<reason\>)** | Non-failing message naming why the table cannot be altered, e.g. `PARTITION BY changed`, `ORDER BY changed without @primaryKey`, `PRIMARY KEY changed`, `key column <col> renamed`, `key column <col> type changed` |
| **Recreate Table** | `CREATE OR REPLACE TABLE` with the new definition |
| **Drop Table** | When the table was also renamed or moved: drops the table at the old path |

If the materialization type changes (table ↔ view), the existing object is dropped and recreated:

| **Stage** | **Description** |
|-----------|----------------|
| **Drop Table \| Drop View** | Drops the existing object |
| **Create table \| Create View** | Recreates the node with the new materialization type |

#### Altering and Recreating the Work Views

| **Stage** | **Description** |
|-----------|----------------|
| **Create View** | The view definition changed (columns, types, transforms, joins, column descriptions), or a storage location the view reads from was mapped to another database: `CREATE OR REPLACE VIEW` with the new definition |
| **Drop View** + **Create View** | The view is renamed or moved **and** its definition changed: the old view is dropped and the new one created |
| **Rename View** | The view is only renamed or moved: `RENAME TABLE` to the new name/location |
| **Set View Comment** | The view description changed (on its own or with a rename): `ALTER TABLE ... MODIFY COMMENT` — the view is not recreated |
| **Metadata Update-Default** | Only tests changed (`@tests`, column tests such as `@not_null`, or `@disableTests`), or annotations views ignore — the view is not recreated or altered; only the node metadata is updated |

### Removing a Work Node

If a Work Node of materialization type table is deleted from a SQL Workspace, that SQL Workspace is committed to Git and that commit deployed to a higher-level Environment, then the Work Table in the target Environment will be dropped.

This is executed in two stages:

| **Stage** | **Description** |
|-----------|----------------|
| **Drop Cloned Table** | Drops the internal clone, if one was left behind by a failed deployment |
| **Drop Table** | Drops the target table in ClickHouse |

If a Work Node of materialization type view is deleted from a Workspace, that Workspace is committed to Git and that commit deployed to a higher-level Environment, then the Work View in the target Environment will be dropped.

The stage executed:

| **Stage** | **Description** |
|-----------|----------------|
| **Drop View** | Drops the existing Work view from the target Environment |

### Work Load

Every run of a Work Node of materialization type table executes these stages:

| **Stage** | **Description** |
|-----------|----------------|
| **Unsupported Materialization Type: \<node\>** | Only when `@materializationType` is not `table` or `view` — stops the run |
| **Pre Load Test `<n>`** | Node-level `@tests(..., "Before")` tests, in the order they appear. |
| **Pre-SQL `<n>`** | Each `@preSQL` statement, in the order they appear. |
| **Truncate table** | Executed only for `@writeMode("truncateInsert")` (the Work default) — `TRUNCATE TABLE IF EXISTS`. ClickHouse has no `INSERT OVERWRITE`, so this is a separate stage. |
| **Load table using Insert** | `INSERT INTO … SELECT` with the node's CTEs, `DISTINCT` and joins. |
| **Post-SQL `<n>`** | Each `@postSQL` statement, in the order they appear. |
| **`<column>: <test>` \| Post Load Test `<n>`** | Column-level data quality tests and node-level `@tests(..., "After")` tests, run after the load. |

A Work view has no load: the run shows **Load Skipped for View**, and the tests still run.

---

## Dimension

The Dimension node is a specialized transformation node within Coalesce, used to materialize dimension tables that track descriptive attributes over time. It loads incoming source data into the target using a configurable change-detection strategy — column-based change tracking or a last-modified timestamp — and, depending on that strategy and the columns marked on the node, produces either an SCD Type 1 (overwrite-in-place) or SCD Type 2 (versioned history) dimension, complete with a built-in library of column- and node-level data quality tests.

ClickHouse has no `MERGE`, so a Dimension load inserts the rows a merge would apply and then deletes the copies they replace — see [How a Load Replaces Rows](#how-a-load-replaces-rows-dimension-and-fact).

### Dimension Node Configuration

The Dimension Node type has three configuration groups:

* [General](#dimension-general-options)
* [Node Annotations](#dimension-node-annotations)
* [Column Annotations](#dimension-column-annotations)

#### Dimension General Options

| **Property** | **Description** |
|----------|-------------|
| **Storage Location** | Storage Location (ClickHouse database) where the Dimension table or view will be created |
| **Node Type** | Read-only: the node type's name and ID — **Dimension** (`SQLDimension`). Set from `@nodeType` when the node is created; the ID has a copy button. |

### Dimension Node Annotations

| **Annotation** | **Summary** |
|---|---|
| `@id(id)` ***(reserved)*** | Unique identifier for the node.<br/>Static and auto-generated when the node is created — not meant to be edited. |
| `@nodeType(type)` ***(reserved)*** | Identifies the node's type.<br/>Set automatically based on the node type chosen when the node is created. |
| `@description(text)` ***(reserved)*** | Node-level description, written as the table or view `COMMENT`.<br/>Example: `@description("Table description")` |
| [`@materializationType(type)`](#materializationtype) ***(reserved)*** | Table or view |
| `@deployDisabled` ***(reserved)*** | Excludes this node from deployment. |
| [`@orderBy(term, ...)`](#orderby) | The table's `ORDER BY` (sort) key. |
| [`@primaryKey(term, ...)`](#primarykey) | The table's `PRIMARY KEY` — the leading terms of `@orderBy`. |
| [`@partitionBy(term, ...)`](#partitionby) | The table's `PARTITION BY` key. |
| [`@settings(setting, ...)`](#settings) | The table's MergeTree `SETTINGS`. |
| [`@writeMode("truncateInsert \| append")`](#writemode) | How each run writes to the target: truncateInsert or append<br/>*Not specified in the SQL editor → defaults to **append**.* |
| [`@mergeStrategy("changeTracking \| lastModified")`](#mergestrategy-dimension) | Chooses how this dimension decides a row has changed, and therefore which column annotations it requires. |
| [`@zeroKey(surrogateKeyValue, stringValue?, timestampValue?, booleanValue?)`](#zerokey-dimension-node) | Inserts a default "zero key" record into the target — a placeholder row used to catch unresolved foreign key lookups. |
| [`@disableTests`](#disabletests) **²** | Controls whether configured tests are skipped. |
| [`@tests(querySQL, continueOnFailure?, runOrder?)`](#tests) **²** ***(repeatable)*** | Node-level data quality test. |
| [`@preSQL(querySQL)`](#presql) ***(repeatable)*** | SQL statement to execute `before` the data load operation. |
| [`@postSQL(querySQL)`](#postsql) ***(repeatable)*** | SQL statement to execute `after` the data load operation. |

### Dimension Column Annotations

**Column annotations shared with Work and Fact**

| **Annotation** | **Summary** |
|---|---|
| [`@id("<value>")`](#id-column) | Stable column ID for lineage tracking. |
| `@notNull` ***(reserved)*** | Creates the column with its plain type instead of `Nullable(<type>)` — see [Column Types](#column-types).<br/>Example: `@notNull` |
| `@description(<text>)` ***(reserved)*** | Adds the column `COMMENT`.<br/>Example: `@description("timestamp column")` |
| [`@defaultValue(<value>)`](#defaultvalue) ***(reserved)*** | Adds a `DEFAULT` expression. On the surrogate key it is the value new rows get. |
| [`@inHash("<hashName>", <hashOrder>)`](#inhash) **¹** ***(repeatable)*** | Marks a column as an input to a generated hash key. |

**Dimension-specific column annotations**

| **Annotation** | **Summary** |
|---|---|
| `@isBusinessKey` ***(required)*** | Marks a column as part of the business key used to match existing rows during the load.<br/>**Note:** Ignored on Views.<br/>Example: `@isBusinessKey` |
| [`@lastModifiedTracking(scdType?)`](#lastmodifiedtracking) | Marks the column used to detect newer source rows for an incremental load. |
| [`@isChangeTracking`](#ischangetracking-dimension) | Marks a column to be watched for changes that decide SCD type. |
| [`@zeroKey(value)`](#zerokey-dimension-column) | Adds a custom zero key value (ghost record) to this column, overriding the node-level `@zeroKey` defaults for it. |
| [`@isSurrogateKey`](#issurrogatekey-dimension) | Marks this column as the node's surrogate key. |
| [`@isSystemVersion`](#issystemversion-dimension) | Marks this column as the SCD version number, incremented each time a business key gets a new version. |
| [`@isSystemCurrentFlag`](#issystemcurrentflag-dimension) | Marks this column as the SCD "is current" flag — `'Y'` on the active version of a row, `'N'` once it's expired. |
| [`@isSystemCreateDate`](#issystemcreatedate) | Marks this column as the timestamp a row (or, under SCD Type 2, a specific row version) was first created. |
| [`@isSystemUpdateDate`](#issystemupdatedate) | Marks this column as the timestamp a row was last updated. |
| [`@isSystemEndDate`](#issystemenddate-dimension) | Marks this column as the SCD Type 2 expiration timestamp — a far-future value while the row is current, set to the actual expiry time once superseded. |

> Shared annotations link to the [Annotation Reference](#annotation-reference); the Dimension-specific ones are described in [Dimension Annotation Details](#dimension-annotation-details).

>**Note:** Identifier quoting inside `@tests`, `@preSQL`, `@postSQL` and the key annotations — see [Identifier Quoting in Annotations](#identifier-quoting-in-annotations).

🚦 The full set of column-level data quality tests (`@not_null`, `@uniqueness`, `@empty`, `@accepted_values`, `@rejected_values`, `@min_max`, `@min_value`, `@max_value`, `@freshness`, `@relative_time`) applies to Dimension columns exactly as described in [Column-Level Data Quality Tests](#column-level-data-quality-tests).

### Dimension Annotation Details

##### `@mergeStrategy` (Dimension)

`@mergeStrategy("changeTracking | lastModified")`

Chooses how this dimension decides a row has changed, and therefore which column annotations it requires.

| **Value** | **Description** |
|---|---|
| `changeTracking` | Compares columns marked `@isChangeTracking` (or, if none are marked, every plain attribute column) to detect a change. SCD Type 2 if any column is marked `@isChangeTracking`, otherwise SCD Type 1. Doesn't use `@lastModifiedTracking` — if present, a warning is raised and it's ignored. |
| `lastModified` | Compares a single `@lastModifiedTracking` column against the target's stored value. Requires exactly one column marked `@lastModifiedTracking` — a validation check flags it if none (or more than one) is present. SCD Type 1 or 2 comes from that column's own `scdType` parameter. Doesn't use `@isChangeTracking` — if present, a warning is raised and it's ignored. |

* *Not specified in the SQL editor → defaults to **changeTracking** - SCD Type 1.*
* The value is not case-sensitive; any other value is flagged by the **Invalid configuration: mergeStrategy** check and stops the deploy and the run.
* Every strategy matches on the business key, so the SELECT/CTE must return exactly one row per business key, with no NULL business key — see [Unique Business Keys](#unique-business-keys-fact-and-dimension).
* The load writes fixed system column values — see [System column values](#system-column-values).
* Change detection is NULL-safe (`isDistinctFrom`): a value changing to or from NULL counts as a change; NULL on both sides does not.
* **Note:** Ignored on Views.

**Example:**

```sql
@mergeStrategy("lastModified")
```

##### `@zeroKey` (Dimension node)

`@zeroKey(surrogateKeyValue, stringValue?, timestampValue?, booleanValue?)`

Inserts a default "zero key" record into the target — a placeholder row used to catch unresolved foreign key lookups.

| **Parameter** | **Description** |
|---|---|
| **surrogateKeyValue** | **(required)** Value used for the zero record's surrogate key column only. A `UUID` surrogate key takes it when it is a UUID (e.g. `"11111111-1111-1111-1111-111111111111"`, with or without single quotes), and otherwise gets the nil UUID `00000000-0000-0000-0000-000000000000`. A numeric surrogate key takes the number as written (e.g. `0` or `-1`). |
| **stringValue** | **(optional)** Value for `String` / `FixedString` columns, pasted into the SQL verbatim — include your own quotes. Default `"'UNKNOWN'"`. |
| **timestampValue** | **(optional)** Value for `Date` / `Date32` / `DateTime` / `DateTime64` columns, converted to the column's type. Default `"1900-01-01 00:00:00"`. |
| **booleanValue** | **(optional)** Value for `Bool` columns. Default `true`. |

Zero record value by column type (`Nullable(...)` and `LowCardinality(...)` are looked through):

| **Column type** | **Zero record value** |
|---|---|
| `Int*`, `UInt*`, `Float*`, `BFloat16`, `Decimal*` | `0` |
| `String`, `FixedString(n)` | **stringValue** |
| `Bool` | **booleanValue** |
| `Date32`, `DateTime64` | **timestampValue** |
| `Date`, `DateTime` | **timestampValue**, raised to `1970-01-01` when earlier — these types start at 1970, so the `1900-01-01` default is stored as `1970-01-01` |
| `UUID` (not the surrogate key) | The nil UUID `00000000-0000-0000-0000-000000000000` |
| Anything else | `NULL` |
| System columns | Version `1`, current flag `'Y'`, end date the [open end date](#scd-type-2-end-date), create/update date the load time |

* Override any column with a column-level `@zeroKey(value)`.
* The zero record is written by its own stage, **Load table Using Merge - Zero Key Record**, on every run: it is re-inserted with the current values and the previous one is removed by the clean-up, keeping its first `SYSTEM_CREATE_DATE`.
* The zero record is left out of change detection, so a real source row whose business key equals the zero record's (e.g. `0`) is loaded as its own row and never overwrites it.
* `String` has no length limit in ClickHouse. A value longer than a `FixedString(n)` column raises a non-failing **Warning: Zero Key Value Too Long** stage that lists each such column: in a `Nullable(FixedString(n))` column ClickHouse stores the zero record's value as **NULL without an error**; in a non-Nullable one the **Zero Key Record** stage fails. Set a shorter value on the column with `@zeroKey("'<value>'")`, or widen the column.
* Requires a column marked `@isSurrogateKey` — without one, the **Missing Required System Columns** check stops the deploy and the run.
* *Not specified in the SQL editor → the zero record is not inserted.*
* **Note:** Ignored on Views.

**Example:**

```sql
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'", "1900-01-01 00:00:00", true)
```

##### `@isChangeTracking` (Dimension)

`@isChangeTracking`

Marks a column to be watched for changes that decide SCD type.

* Marked on any column → SCD Type 2 — a change expires the existing row and inserts a new version.
* Not marked on any column → SCD Type 1 — a change updates the row in place.
* Under SCD Type 2, a change in a column **not** marked `@isChangeTracking` updates the current row in place — no new version is created.
* **Note:** Ignored on Views.

**Example:**

```sql
@isChangeTracking
```

##### `@zeroKey` (Dimension column)

`@zeroKey(value)`

Adds a custom zero key value (ghost record) to this column, overriding the node-level `@zeroKey` defaults for it.

| **Parameter** | **Description** |
|---|---|
| **value** | Zero key value for this column, pasted into the SQL verbatim. |

* The value is pasted into the SQL exactly as written, so quote it or write the full expression to match the column's data type.
* A string value longer than a `FixedString(n)` column raises the non-failing **Warning: Zero Key Value Too Long** stage (see [`@zeroKey` (Dimension node)](#zerokey-dimension-node)).
* **Note:** Ignored unless `@zeroKey` is enabled at the node level, and ignored on Views.

**Example:**

```sql
@zeroKey("'N/A'")                                    -- String: quotes inside the annotation
@zeroKey("-1")                                       -- number
@zeroKey("0.00")                                     -- Decimal
@zeroKey("toDate('1970-01-01')")                     -- Date
@zeroKey("toDateTime64('1900-01-01 00:00:00', 6)")   -- DateTime64
@zeroKey(false)                                      -- Bool (unquoted)
@zeroKey("[]")                                       -- Array
```

##### `@isSurrogateKey` (Dimension)

`@isSurrogateKey`

Marks this column as the node's surrogate key.

* Optional for SCD Type 1 — the load joins and detects changes entirely off the business key.
* Recommended for SCD Type 2 — a stable surrogate key per version is the standard way to identify a versioned row, though it isn't enforced by the load itself. Without one, the non-failing **Surrogate Key Not Set/Using Custom Surrogate Key Logic** stage is shown.
* Required only when the node-level `@zeroKey` is set, since the zero/ghost record is matched against the target by surrogate key value.
* Always created **not null** (e.g. `UUID`, never `Nullable(UUID)`), with or without `@notNull`, because every row must have a key.
* New rows and new SCD Type 2 versions get their key from `@defaultValue`; rows the load re-inserts (an expired version, an in-place update) keep the key they already have. See [Surrogate Keys](#surrogate-keys-dimension).
* **Note:** Ignored on Views. Agentic creation only — manual creation adds this column automatically.
* Expected expression: `generateUUIDv4() AS "<NODE_NAME>_KEY" @isSurrogateKey @notNull @defaultValue("generateUUIDv4()")` — type the node name yourself, e.g. `generateUUIDv4() AS "DIM_CUSTOMER_KEY" @isSurrogateKey @notNull @defaultValue("generateUUIDv4()")`.

##### `@isSystemVersion` (Dimension)

`@isSystemVersion`

Marks this column as the SCD version number, incremented each time a business key gets a new version.

* Required for SCD Type 2 — shows which version of a row this is; each time a business key's row changes, the expired row is kept and a new row is inserted with this value incremented by 1.
* Optional for SCD Type 1 — new-vs-existing is detected off the business key alone, so this column can be dropped entirely; if kept, it is always written as 1 and never incremented.
* **Note:** Ignored on Views. Agentic creation only — manual creation adds this column automatically.
* Expected expression: `1 AS "SYSTEM_VERSION" @isSystemVersion`

##### `@isSystemCurrentFlag` (Dimension)

`@isSystemCurrentFlag`

Marks this column as the SCD "is current" flag — `'Y'` on the active version of a row, `'N'` once it's expired.

* Required for SCD Type 2 — used to filter the target down to each business key's one current row before comparing it against the incoming source row.
* Optional for SCD Type 1 — safe to omit; if kept, it is always written as `'Y'`.
* **Note:** Ignored on Views. Agentic creation only — manual creation adds this column automatically.
* Expected expression: `'Y' AS "SYSTEM_CURRENT_FLAG" @isSystemCurrentFlag`

##### `@isSystemEndDate` (Dimension)

`@isSystemEndDate`

Marks this column as the SCD Type 2 expiration timestamp — a far-future value while the row is current, set to the actual expiry time once superseded.

* Required for SCD Type 2 — this is what makes a version's active window queryable; omitting it leaves expired versions with no expiry marker.
* Optional for SCD Type 1 (no versioning, so nothing ever expires) — safe to omit entirely.
* The open value is the highest value the column's type can hold, not `2999-12-31` — see [SCD Type 2 End Date](#scd-type-2-end-date).
* **Note:** Ignored on Views. Agentic creation only — manual creation adds this column automatically.
* Expected expression: `CAST('2299-12-31 23:59:59.999999' AS DateTime64(6)) AS "SYSTEM_END_DATE" @isSystemEndDate` — only its type is used; the load writes the value.

---

### Dimension SCD Type & System Column Requirements

`@mergeStrategy` picks the change-detection strategy; which SCD type it resolves to (and therefore which system columns are required) depends on that strategy and on which columns are marked:

| `@mergeStrategy` | Resolves to | Driven by |
|---|---|---|
| `lastModified` | SCD1 or SCD2, from that column's own `scdType` parameter | `@lastModifiedTracking(scdType)` |
| `changeTracking` (default) | SCD2 if any column is marked, otherwise SCD1 | `@isChangeTracking` |

Requirement level of each column annotation, by SCD type:

| Annotation | Category | SCD1 | SCD2 |
|---|---|:---:|:---:|
| `@isBusinessKey` | Key | 🔴 | 🔴 |
| `@isSurrogateKey` | Key | ⚪¹ | 🟡¹ |
| `@defaultValue` on the surrogate key | Key | 🔴 for a `UUID` key · 🟡 otherwise ² | 🔴 for a `UUID` key · 🟡 otherwise ² |
| `@isSystemCreateDate` | System column | 🔴 | 🔴 |
| `@isSystemUpdateDate` | System column | 🔴 | 🔴 |
| `@isSystemVersion` | System column | ⚪ | 🔴 |
| `@isSystemCurrentFlag` | System column | ⚪  | 🔴 |
| `@isSystemEndDate` | System column | ⚪ | 🔴 |

**Legend:** 🔴 Required · 🟡 Recommended · ⚪ Optional

* ¹ Required (🔴) whenever the node-level `@zeroKey` is set.
* ² Without `@defaultValue`, new rows take the value the SELECT computes for the key, so the SELECT must give every new row (and every new SCD Type 2 version) a unique key — a non-failing warning is shown.
* Marking `@isChangeTracking` on any column is itself what makes the node SCD2 under `changeTracking`.
* Missing items are reported together in one stage: **Missing Required System Columns** when anything required is missing (stops the deploy and the run), **Missing Recommended System Columns** when only recommendations are listed (non-failing), or **Surrogate Key Not Set/Using Custom Surrogate Key Logic** when the only item is the recommended surrogate key.

#### System column values

The load writes fixed values into the system columns. The expression the SELECT gives a system column is only used to derive the column's datatype — its value is ignored:

| Column | Value written |
|---|---|
| `@isSurrogateKey` | `@defaultValue` (e.g. `generateUUIDv4()`) on a new key and a new SCD2 version; kept on re-inserted rows |
| `@isSystemVersion` | `1` on a new key; previous version + 1 on a new SCD2 version |
| `@isSystemCurrentFlag` | `'Y'` on the current row; `'N'` on an expired SCD2 row |
| `@isSystemCreateDate` | The load time on first insert and on each new SCD2 version, then kept |
| `@isSystemUpdateDate` | The load time whenever the row is inserted, changed, or expired as an old SCD2 version |
| `@isSystemEndDate` | The [open end date](#scd-type-2-end-date) on the current row; the expiry time (one millisecond before the load time) on an expired SCD2 row |

The load time is `now64(6)`, evaluated once per load statement, so every row of one load gets the same value (stored at the column's own precision).

#### SCD Type 2 End Date

ClickHouse's date types cannot hold a far-future date such as `2999-12-31`, so the current version (and the zero key record) gets the highest value the `@isSystemEndDate` column's type can hold:

| Column type | Open end date |
|---|---|
| `DateTime64` (generated SELECT: `DateTime64(6)`) | `2299-12-31 23:59:59.999999` |
| `DateTime` | `2106-02-07 06:28:15` |
| `Date32` | `2299-12-31` |
| `Date` | `2149-06-06` |

An expired version gets the expiry time: one millisecond before the load.

The SELECT expression only sets the column's type; the load writes the value. Use `CAST('2299-12-31 23:59:59.999999' AS DateTime64(6))`: `CAST(... AS TIMESTAMP)` is a `DateTime` in ClickHouse (seconds only, ending in 2106), so `CAST('2999-12-31 00:00:00' AS TIMESTAMP)` shows as `2106-02-07 06:28:15` in Preview.

To find current versions, filter on `SYSTEM_CURRENT_FLAG = 'Y'` rather than on a fixed end date.

---

### Dimension Deployment

#### Dimension Initial Deployment

Every deployment of a Dimension Node first runs these checks before any change in ClickHouse:

| **Stage** | **Description** |
|-----------|----------------|
| **Unsupported Materialization Type: \<node\>** | `@materializationType` is not `table` or `view` — stops the deployment and the run |
| **Duplicate Column Names \| Duplicate Column IDs \| Missing Column IDs \| Missing Business Key \| Invalid configuration: … \| Warning: mergeStrategy \| Missing Required System Columns \| Missing Recommended System Columns \| Surrogate Key Not Set/Using Custom Surrogate Key Logic \| Warning: Zero Key Value Too Long** | Dimension validation checks (table only), rendered only when the annotations have a problem — see [Dimension Load](#dimension-load). A required problem stops the deployment with `Validation failed: <stage>`; a recommendation or warning does not. |

When deployed for the first time into an Environment, the Dimension Node executes one of these stages, depending on its materialization type:

| **Stage** | **Description** |
|-----------|----------------|
| **Create table** | Executes a `CREATE OR REPLACE TABLE` statement with the column types (the surrogate key never `Nullable`), defaults and comments, `PARTITION BY`, `ORDER BY`, `PRIMARY KEY`, `SETTINGS` and the table comment |
| **Create View** | Executes a `CREATE OR REPLACE VIEW` statement with a typed column list, the column comments and the view comment — see [Dimension View](#dimension-view) |

#### Dimension View

A Dimension Node of materialization type view is a plain `CREATE OR REPLACE VIEW` over the node's SELECT:

* None of the Dimension validation checks run — `@isBusinessKey`, system columns, `@id` and `@mergeStrategy` aren't required or checked.
* There is no load; the run shows **Load Skipped for View**. `@mergeStrategy`, `@writeMode`, `@zeroKey`, `@preSQL`, `@postSQL`, the key annotations and the tracking annotations are ignored.
* Any system column (surrogate key, version, current flag, create/update/end date) is selected as a typed `NULL`, keeping the column's datatype. A column that cannot be `Nullable` — the surrogate key, or one marked `@notNull` — gets its type's default value instead (e.g. the nil UUID, `0`), because ClickHouse cannot cast `NULL` to a non-Nullable type.
* Column-level data quality tests and node-level `@tests` still run.

#### Dimension Load

Every run of a Dimension Node of materialization type table runs its configured data quality tests, then loads data into the target using the stages below, depending on the resolved `@mergeStrategy` and SCD type:

| **Stage** | **Description** |
|-----------|----------------|
| **Pre Load Test `<n>`** | Node-level `@tests(..., "Before")` tests, in the order they appear. |
| **Duplicate Column Names \| Duplicate Column IDs \| Missing Column IDs \| Missing Business Key \| Invalid configuration: … \| Warning: mergeStrategy \| Missing Required System Columns \| Missing Recommended System Columns \| Surrogate Key Not Set/Using Custom Surrogate Key Logic \| Warning: Zero Key Value Too Long** | Validation checks — rendered only when the node's annotations have a problem (the SELECT returns the same column name twice, two columns share an `@id` value, a column without `@id`, no `@isBusinessKey`, an unrecognised `@mergeStrategy`, a missing or repeated `@lastModifiedTracking` column, an `scdType` other than 1 or 2, a tracking annotation the strategy ignores (non-failing), a missing system column, a missing `@defaultValue` on the surrogate key, a surrogate key that is only recommended (non-failing), or a zero key string longer than its `FixedString` column (non-failing)). |
| **Check NULL values for `<column>` column** | Pre-load check for `@mergeStrategy("lastModified")` — fails the run on a NULL `@lastModifiedTracking` value in the source. |
| **Pre-SQL `<n>`** | Each `@preSQL` statement, in the order they appear. |
| **Truncate table** | Executed only when `@writeMode("truncateInsert")` is set — clears the target before the load. |
| **Load table Using Merge - Zero Key Record** | Executed only when node-level `@zeroKey` is set and a surrogate key column exists — inserts the placeholder "zero key" row. |
| **Load table Using Merge - Last Modified Comparison - SCD1 \| SCD2** | Executed for `@mergeStrategy("lastModified")` — compares the `@lastModifiedTracking` column against the current target row, then inserts new keys and the changed rows (SCD1: the new values; SCD2: the new version plus the expired old version). |
| **Load table Using Merge - Change Tracking - SCD1 \| SCD2** | Executed for `@mergeStrategy("changeTracking")` (the default) — compares `@isChangeTracking` columns (or, absent any, every plain attribute column) against the current target row, then inserts new keys and the changed rows. Under SCD2, a change only in a plain attribute column re-inserts the current version with the new values. |
| **Load table Using Merge - Clean Up Data** | Deletes the copies the insert replaced — see [How a Load Replaces Rows](#how-a-load-replaces-rows-dimension-and-fact). Runs when the node has `@isBusinessKey` and `@isSystemUpdateDate` columns. |
| **Post-SQL `<n>`** | Each `@postSQL` statement, in the order they appear. |
| **`<column>: <test>` \| Post Load Test `<n>`** | Column-level data quality tests and node-level `@tests(..., "After")` tests, run after the load. |

> **Note:** ClickHouse has no `MERGE` statement; the "Using Merge" stages insert the rows a merge would apply and clean up the replaced copies — see [How a Load Replaces Rows](#how-a-load-replaces-rows-dimension-and-fact).

#### Dimension Redeployment

After the Dimension Node has been deployed for the first time into a target Environment, subsequent deployments either alter the existing object, recreate it, or only record a metadata update when nothing in the object changed (for example tests, `@writeMode`, `@mergeStrategy`, `@zeroKey`, `@preSQL`/`@postSQL`, or a transform or join on a table):

| **Stage** | **Description** |
|-----------|----------------|
| **Metadata Update-Default** | The node changed, but nothing in ClickHouse needs to change |

#### Altering the Dimension Tables

Dimension tables are altered on an internal clone exactly like Work tables — the same stages, in the same order. See [Altering the Work Tables](#altering-the-work-tables).

> **Note:** Every Dimension column carries a required `@id`, so renaming a column (same `@id`) is a true `RENAME COLUMN` that keeps its data.

> **Note:** Adding a surrogate key to a Dimension that already holds rows works: **Add Column** adds it with its `@defaultValue` and **Materialize Column Default** writes a value into every existing row once — see [Surrogate Keys](#surrogate-keys-dimension).

#### Recreating the Dimension Tables

A change ClickHouse cannot `ALTER` (`@partitionBy`, `@primaryKey`, most `@orderBy` changes, or renaming / retyping a key column) recreates the table — **Warning: Table Recreated (\<reason\>)**, **Recreate Table**, and **Drop Table** when it was also renamed or moved. **The existing data, including all SCD Type 2 history, is lost.** See [Sort Key and Partition Key Changes](#sort-key-and-partition-key-changes).

If the materialization type changes (table ↔ view), the existing object is dropped (**Drop Table \| Drop View**) and recreated (**Create table \| Create View**).

#### Altering and Recreating the Dimension Views

Dimension views follow the same stages as Work views — **Create View**, **Drop View** + **Create View**, **Rename View**, **Set View Comment**, **Metadata Update-Default**. See [Altering and Recreating the Work Views](#altering-and-recreating-the-work-views).

### Removing a Dimension Node

If a Dimension Node of materialization type table is deleted from a SQL Workspace, that SQL Workspace is committed to Git and that commit deployed to a higher-level Environment, then the Dimension Table in the target Environment will be dropped.

| **Stage** | **Description** |
|-----------|----------------|
| **Drop Cloned Table** | Drops the internal clone, if one was left behind by a failed deployment |
| **Drop Table** | Drops the target table in ClickHouse |

A deleted Dimension view runs **Drop View**.

---

## Fact

The Fact node is a specialized transformation node within Coalesce, used to materialize fact tables that hold measurable business events. It loads incoming source data into the target in one of three ways: a plain insert when neither `@mergeStrategy` nor a business key is set, an SCD Type 1 load on the business key (`changeTracking` or `lastModified`), or `allColumnMatch`, which inserts only rows that don't already exist. Facts never keep versioned (SCD Type 2) history and have no surrogate key or zero key record. Like the other node types, it comes with a built-in library of column- and node-level data quality tests.

### Fact Node Configuration

The Fact Node type has three configuration groups:

* [General](#fact-general-options)
* [Node Annotations](#fact-node-annotations)
* [Column Annotations](#fact-column-annotations)

#### Fact General Options

| **Property** | **Description** |
|----------|-------------|
| **Storage Location** | Storage Location (ClickHouse database) where the Fact table or view will be created |
| **Node Type** | Read-only: the node type's name and ID — **Fact** (`SQLFact`). Set from `@nodeType` when the node is created; the ID has a copy button. |

### Fact Node Annotations

| **Annotation** | **Summary** |
|---|---|
| `@id(id)` ***(reserved)*** | Unique identifier for the node.<br/>Static and auto-generated when the node is created — not meant to be edited. |
| `@nodeType(type)` ***(reserved)*** | Identifies the node's type.<br/>Set automatically based on the node type chosen when the node is created. |
| `@description(text)` ***(reserved)*** | Node-level description, written as the table or view `COMMENT`.<br/>Example: `@description("Table description")` |
| [`@materializationType(type)`](#materializationtype) ***(reserved)*** | Table or view |
| `@deployDisabled` ***(reserved)*** | Excludes this node from deployment. |
| [`@orderBy(term, ...)`](#orderby) | The table's `ORDER BY` (sort) key. |
| [`@primaryKey(term, ...)`](#primarykey) | The table's `PRIMARY KEY` — the leading terms of `@orderBy`. |
| [`@partitionBy(term, ...)`](#partitionby) | The table's `PARTITION BY` key. |
| [`@settings(setting, ...)`](#settings) | The table's MergeTree `SETTINGS`. |
| [`@writeMode("truncateInsert \| append")`](#writemode) | How each run writes to the target: truncateInsert or append<br/>*Not specified in the SQL editor → defaults to **append**.* |
| [`@mergeStrategy("changeTracking \| lastModified \| allColumnMatch")`](#mergestrategy-fact) | Chooses how rows are matched against the target, and therefore which column annotations are required. |
| [`@disableTests`](#disabletests) **²** | Controls whether configured tests are skipped. |
| [`@tests(querySQL, continueOnFailure?, runOrder?)`](#tests) **²** ***(repeatable)*** | Node-level data quality test. |
| [`@preSQL(querySQL)`](#presql) ***(repeatable)*** | SQL statement to execute `before` the data load operation. |
| [`@postSQL(querySQL)`](#postsql) ***(repeatable)*** | SQL statement to execute `after` the data load operation. |

### Fact Column Annotations

| **Annotation** | **Summary** |
|---|---|
| [`@id("<value>")`](#id-column) | Stable column ID for lineage tracking. |
| `@notNull` ***(reserved)*** | Creates the column with its plain type instead of `Nullable(<type>)` — see [Column Types](#column-types).<br/>Example: `@notNull` |
| `@description(<text>)` ***(reserved)*** | Adds the column `COMMENT`.<br/>Example: `@description("timestamp column")` |
| [`@defaultValue(<value>)`](#defaultvalue) ***(reserved)*** | Adds a `DEFAULT` expression. |
| [`@inHash("<hashName>", <hashOrder>)`](#inhash) **¹** ***(repeatable)*** | Marks a column as an input to a generated hash key. |
| [`@isBusinessKey`](#isbusinesskey-fact) | Marks a column as part of the business key used to match existing rows during the load. |
| [`@lastModifiedTracking`](#lastmodifiedtracking) | Marks the column used to detect newer source rows for an incremental load (SCD Type 1). |
| [`@isSystemCreateDate`](#issystemcreatedate) | Marks this column as the timestamp a row was first created. |
| [`@isSystemUpdateDate`](#issystemupdatedate) | Marks this column as the timestamp a row was last updated. |

> Shared annotations link to the [Annotation Reference](#annotation-reference); the Fact-specific ones are described in [Fact Annotation Details](#fact-annotation-details).

>**Note:** Identifier quoting inside `@tests`, `@preSQL`, `@postSQL` and the key annotations — see [Identifier Quoting in Annotations](#identifier-quoting-in-annotations).

🚦 The full set of column-level data quality tests (`@not_null`, `@uniqueness`, `@empty`, `@accepted_values`, `@rejected_values`, `@min_max`, `@min_value`, `@max_value`, `@freshness`, `@relative_time`) applies to Fact columns exactly as described in [Column-Level Data Quality Tests](#column-level-data-quality-tests).

### Fact Annotation Details

##### `@mergeStrategy` (Fact)

`@mergeStrategy("changeTracking | lastModified | allColumnMatch")`

Chooses how rows are matched against the target, and therefore which column annotations are required.

| **Value** | **Description** |
|---|---|
| `changeTracking` | SCD Type 1. Compares every plain attribute column against the target; a changed row is re-inserted with the new values and the old copy removed, a new key is inserted. Doesn't use `@lastModifiedTracking` — if present, a warning is raised and it's ignored. |
| `lastModified` | SCD Type 1. Compares a single `@lastModifiedTracking` column against the target's stored value; only rows with a newer value are loaded, then as `changeTracking`. Requires exactly one column marked `@lastModifiedTracking` — a validation check flags it if none (or more than one) is present. |
| `allColumnMatch` | Treats every non-system column as the business key: a source row is inserted only if no target row matches it on all of those columns, and an existing matching row is never updated or deleted. `@isBusinessKey` isn't needed — if present, a warning is raised, it's ignored and all columns are used for the comparison. `@lastModifiedTracking` isn't used either — a warning is raised and it's ignored. System columns are optional, are left out of the comparison, and are written exactly as the SELECT/CTE computes them. |

* *Not specified in the SQL editor → defaults to **changeTracking** - SCD Type 1 when a column is marked `@isBusinessKey`, otherwise the node is loaded as a [plain insert](#fact-load-behaviour).*
* The value is not case-sensitive; any other value is flagged by the **Invalid configuration: mergeStrategy** check and stops the deploy and the run.
* When set, `@mergeStrategy` always takes priority: `changeTracking` and `lastModified` match on the business key, so without an `@isBusinessKey` column the **Invalid configuration: No Business Key** check fails and the load stops. `allColumnMatch` needs no `@isBusinessKey`.
* **Note:** Ignored on Views.

**Example:**

```sql
@mergeStrategy("allColumnMatch")
```

##### `@isBusinessKey` (Fact)

`@isBusinessKey`

Marks a column as part of the business key used to match existing rows during the load.

* Optional when `@mergeStrategy` isn't set — if no column is marked, there is no matching and every source row is simply inserted.
* Required for an explicit `changeTracking` or `lastModified` — without it the load stops with a validation error.
* Ignored under `@mergeStrategy("allColumnMatch")`, which uses every non-system column as the key (a warning is raised).
* **Note:** Ignored on Views.

**Example:**

```sql
@isBusinessKey
```

---

### Fact Load Behaviour

How a Fact table is loaded depends on `@mergeStrategy` and on whether any column is marked `@isBusinessKey`:

| `@isBusinessKey` | `@mergeStrategy` | Load |
|---|---|---|
| none | not set | Plain insert (default without a business key) |
| none | `changeTracking` / `lastModified` | ❌ **Invalid configuration: No Business Key** — the load stops |
| marked | not set, or `changeTracking` | SCD1 on the business key (default with a business key) |
| marked | `lastModified` | SCD1 on the business key, newer rows only |
| any (ignored, warning if marked) | `allColumnMatch` | Insert rows that don't match on every non-system column |

Requirement level of each column annotation, by load:

| Annotation | `changeTracking` / `lastModified` | `allColumnMatch` | Plain insert |
|---|:---:|:---:|:---:|
| `@isBusinessKey` | 🔴 | ⚪¹ | — |
| `@lastModifiedTracking` | 🔴<br/>for `lastModified` only | — | —² |
| `@isSystemCreateDate` | 🔴 | ⚪ | ⚪ |
| `@isSystemUpdateDate` | 🔴 | ⚪ | ⚪ |

**Legend:** 🔴 Required · ⚪ Optional · — Not used

* ¹ Ignored if present — every non-system column is used as the business key and a warning is raised.
* ² A `@lastModifiedTracking` column on a plain insert is ignored, with a non-failing **Warning: No Business Key**.
* `allColumnMatch` is meant for **factless fact tables** (no measures — the row itself is the fact), used for event tracking and coverage/relationship tracking. See [Fact All Column Match](#fact-all-column-match).
* Under `changeTracking` / `lastModified` the load writes fixed values into the system columns: `@isSystemCreateDate` gets the load time on first insert and is then kept; `@isSystemUpdateDate` gets the load time whenever the row is inserted or changed. The expression the SELECT gives them is only used to derive the column's datatype.
* Under `allColumnMatch` and plain insert, system columns are written exactly as the SELECT/CTE computes them.
* Business key matching (including every column under `allColumnMatch`) uses plain equality, so a NULL never matches — see [NULL Business Keys](#known-limitations).

---

### Fact Deployment

#### Fact Initial Deployment

Every deployment of a Fact Node first runs these checks before any change in ClickHouse:

| **Stage** | **Description** |
|-----------|----------------|
| **Unsupported Materialization Type: \<node\>** | `@materializationType` is not `table` or `view` — stops the deployment and the run |
| **Duplicate Column Names \| Duplicate Column IDs \| Missing Column IDs \| Invalid configuration: No Business Key \| Invalid configuration: … \| Warning: mergeStrategy \| Warning: No Business Key \| Missing Required System Columns** | Fact validation checks (table only), rendered only when the annotations have a problem — see [Fact Load](#fact-load). A required problem stops the deployment with `Validation failed: <stage>`; a warning does not. |

When deployed for the first time into an Environment, the Fact Node executes one of these stages, depending on its materialization type:

| **Stage** | **Description** |
|-----------|----------------|
| **Create table** | Executes a `CREATE OR REPLACE TABLE` statement with the column types, defaults and comments, `PARTITION BY`, `ORDER BY`, `PRIMARY KEY`, `SETTINGS` and the table comment |
| **Create View** | Executes a `CREATE OR REPLACE VIEW` statement with a typed column list, the column comments and the view comment — see [Fact View](#fact-view) |

#### Fact View

A Fact Node of materialization type view is a plain `CREATE OR REPLACE VIEW` over the node's SELECT:

* None of the Fact validation checks run — `@isBusinessKey`, system columns, `@id` and `@mergeStrategy` aren't required or checked.
* There is no load; the run shows **Load Skipped for View**. `@mergeStrategy`, `@writeMode`, `@preSQL`, `@postSQL`, the key annotations and `@lastModifiedTracking` are ignored.
* `@isSystemCreateDate` / `@isSystemUpdateDate` columns are selected as a typed `NULL` (or the type's default value when the column is `@notNull`), keeping the column's datatype.
* Column-level data quality tests and node-level `@tests` still run.

#### Fact Load

Every run of a Fact Node of materialization type table runs its configured data quality tests, then loads data into the target using the stages below:

| **Stage** | **Description** |
|-----------|----------------|
| **Pre Load Test `<n>`** | Node-level `@tests(..., "Before")` tests, in the order they appear. |
| **Duplicate Column Names \| Duplicate Column IDs \| Missing Column IDs \| Invalid configuration: … \| Warning: mergeStrategy \| Warning: No Business Key \| Missing Required System Columns** | Validation checks — rendered only when the node's annotations have a problem (the SELECT returns the same column name twice, two columns share an `@id` value, a column without `@id`, an unrecognised `@mergeStrategy`, an explicit strategy without a business key, a missing or repeated `@lastModifiedTracking` column, a tracking/key annotation the strategy ignores (non-failing), or a missing system column). |
| **Check NULL values for `<column>` column** | Pre-load check for `@mergeStrategy("lastModified")` — fails the run on a NULL `@lastModifiedTracking` value in the source. |
| **Pre-SQL `<n>`** | Each `@preSQL` statement, in the order they appear. |
| **Truncate table** | Executed only when `@writeMode("truncateInsert")` is set — clears the target before the load. |
| **Load table using Insert** | Executed when no `@mergeStrategy` is set and no column is marked `@isBusinessKey` — inserts every source row with `INSERT INTO … SELECT`. |
| **Load table Using Merge - Change Tracking - SCD1** | Executed for `@mergeStrategy("changeTracking")`, and by default when no `@mergeStrategy` is set and a column is marked `@isBusinessKey` — compares every plain attribute column against the target, then inserts new keys and changed rows. |
| **Load table Using Merge - Last Modified Comparison - SCD1** | Executed for `@mergeStrategy("lastModified")` — compares the `@lastModifiedTracking` column against the target, then inserts new keys and newer rows. |
| **Load table Using Merge - All Column Match** | Executed for `@mergeStrategy("allColumnMatch")` — matches on every non-system column and inserts only rows that don't already exist; nothing is updated or deleted. |
| **Load table Using Merge - Clean Up Data** | Deletes the copies the insert replaced — see [How a Load Replaces Rows](#how-a-load-replaces-rows-dimension-and-fact). Runs for `changeTracking` / `lastModified` when the node has an `@isSystemUpdateDate` column. |
| **Post-SQL `<n>`** | Each `@postSQL` statement, in the order they appear. |
| **`<column>: <test>` \| Post Load Test `<n>`** | Column-level data quality tests and node-level `@tests(..., "After")` tests, run after the load. |

#### Fact Redeployment

After the Fact Node has been deployed for the first time into a target Environment, subsequent deployments either alter the existing object, recreate it, or only record a metadata update when nothing in the object changed (for example tests, `@writeMode`, `@mergeStrategy`, `@preSQL`/`@postSQL`, or a transform or join on a table):

| **Stage** | **Description** |
|-----------|----------------|
| **Metadata Update-Default** | The node changed, but nothing in ClickHouse needs to change |

#### Altering the Fact Tables

Fact tables are altered on an internal clone exactly like Work tables — the same stages, in the same order. See [Altering the Work Tables](#altering-the-work-tables).

> **Note:** Every Fact column carries a required `@id`, so renaming a column (same `@id`) is a true `RENAME COLUMN` that keeps its data.

#### Recreating the Fact Tables

A change ClickHouse cannot `ALTER` (`@partitionBy`, `@primaryKey`, most `@orderBy` changes, or renaming / retyping a key column) recreates the table — **Warning: Table Recreated (\<reason\>)**, **Recreate Table**, and **Drop Table** when it was also renamed or moved. **The existing data is lost.** See [Sort Key and Partition Key Changes](#sort-key-and-partition-key-changes).

If the materialization type changes (table ↔ view), the existing object is dropped (**Drop Table \| Drop View**) and recreated (**Create table \| Create View**).

#### Altering and Recreating the Fact Views

Fact views follow the same stages as Work views — **Create View**, **Drop View** + **Create View**, **Rename View**, **Set View Comment**, **Metadata Update-Default**. See [Altering and Recreating the Work Views](#altering-and-recreating-the-work-views).

### Removing a Fact Node

If a Fact Node of materialization type table is deleted from a SQL Workspace, that SQL Workspace is committed to Git and that commit deployed to a higher-level Environment, then the Fact Table in the target Environment will be dropped.

| **Stage** | **Description** |
|-----------|----------------|
| **Drop Cloned Table** | Drops the internal clone, if one was left behind by a failed deployment |
| **Drop Table** | Drops the target table in ClickHouse |

A deleted Fact view runs **Drop View**.

---

## Common Reference

Concepts and reusable building blocks that apply across every node type in this package.

### ClickHouse Cloud Defaults

Tables are always MergeTree (there is no `@engine`) and are created without the clauses ClickHouse Cloud adds by itself:

- `ENGINE = MergeTree` is not written; Cloud creates `ENGINE = SharedMergeTree('/clickhouse/tables/{uuid}/{shard}', '{replica}')`.
- `ORDER BY tuple()` is not written when the node has no `@orderBy` / `@primaryKey`; Cloud adds it.
- `SETTINGS index_granularity = 8192` is never written unless `@settings` sets it; Cloud adds it.

These rely on Cloud's `default_table_engine` and `create_table_empty_primary_key_by_default` settings.

`SETTINGS allow_nullable_key = 1` is added automatically when the table has an `@orderBy`, `@primaryKey` or `@partitionBy`, so `Nullable` columns can be key terms. Set `allow_nullable_key` in `@settings` to override it.

### Column Types

Each column is created with the type Coalesce infers for it, with its nullability folded into the type:

| **Column** | **Created as** |
|---|---|
| Default (Coalesce infers SQL node columns as nullable) | `Nullable(<type>)` |
| Marked `@notNull` | `<type>` |
| `@isSurrogateKey` (Dimension) | `<type>`, with or without `@notNull` — every row gets a key |
| `LowCardinality(<type>)`, nullable | `LowCardinality(Nullable(<type>))` |
| `Array`, `Map`, `Tuple`, `Nested`, `JSON` / `Object`, `Dynamic`, `Variant`, `AggregateFunction`, `SimpleAggregateFunction`, geo types (`Point`, `Ring`, `LineString`, `MultiLineString`, `Polygon`, `MultiPolygon`) | `<type>` — ClickHouse cannot make these `Nullable` |

The same type is used by the `CREATE`, **Add Column**, **Alter Column** and the view's column list, so they always agree. See [Array and Map Columns](#known-limitations) and [`Variant` Columns](#known-limitations) for the related limitations.

`TIMESTAMP` is an alias of `DateTime` in ClickHouse: whole seconds, up to `2106-02-07 06:28:15`. Use `DateTime64(<precision>)` for sub-second values or later dates.

#### NULLs in non-nullable columns

ClickHouse does not reject a NULL inserted into a non-nullable column. With its default `insert_null_as_default = 1`, an `INSERT ... SELECT` silently stores the column's default instead: `0`, `''`, zero bytes for `FixedString`, or the column's `DEFAULT` expression.

To make such an insert fail instead, set:

```sql
SETTINGS insert_null_as_default = 0
```

The run templates do not add this setting to their `INSERT` statements, so it has to be set at the user (or settings profile) level for the user Coalesce connects as, for example:

```sql
ALTER USER <coalesce_user> SETTINGS insert_null_as_default = 0;
```

ClickHouse writes an `INSERT ... SELECT` in blocks, so an insert that fails part way can leave earlier blocks in the table. A `@not_null` column test only runs after the load; to catch NULLs before anything is written, add a node-level `@tests(..., "Before")` that reads the source.

### Column Type Changes

A redeploy changes a column's type with `ALTER TABLE ... MODIFY COLUMN` on the clone, with `SETTINGS alter_sync = 2` so the deploy waits for ClickHouse to convert the existing values (ClickHouse Cloud does not wait by default):

| Change | Result |
|---|---|
| Values convert (e.g. `'10'` → `UInt32`) | Converted, deploy succeeds |
| `Nullable` → not null while the column has NULLs and no `@defaultValue` | Deploy fails: *Cannot convert column ... Please specify `DEFAULT`*. Add `@defaultValue` to fill the NULLs |
| A value the new non-`Nullable` type cannot take (e.g. `'n/a'` → `UInt32`) | Deploy fails: *Mutation ... failed to finish ... Cannot parse string*. The live table is not changed |
| A value the new `Nullable` type cannot take (e.g. `'ALGERIA'` → `Nullable(UInt32)`) | **Deploy succeeds and ClickHouse stores NULL for that value** |

The last case is not an error in ClickHouse, so the node types cannot stop it. Check the data before changing a column to a `Nullable` type, for example:

```sql
SELECT count() FROM <table> WHERE c IS NOT NULL AND toUInt32OrNull(c) IS NULL;
```

A failed conversion leaves an unfinished mutation on the clone table (`<name>_COALESCE_INTERNAL_TABLE`); the next redeploy replaces the clone.

ClickHouse allows narrowing a type and changing a `DEFAULT` to any expression — the conversion rules above are the only limits.

### Sort Key and Partition Key Changes

ClickHouse cannot change a table's `PRIMARY KEY` or `PARTITION BY` in place. Without `@primaryKey`, the primary key is the whole `@orderBy`, so **any** change to `@orderBy` is a primary key change.

On redeploy:

| Change | Result |
|---|---|
| `@orderBy` changed, no `@primaryKey` | Table recreated |
| `@primaryKey` changed | Table recreated |
| `@partitionBy` changed | Table recreated |
| Key column renamed or its type changed (nullability included) | Table recreated |
| `@primaryKey` unchanged, trailing `@orderBy` terms removed | Altered in place (**Modify Order By**) |
| `@primaryKey` unchanged, new columns (without a `@defaultValue`) added at the end of `@orderBy` | Altered in place (**Add Column** with `MODIFY ORDER BY`) |
| `@settings` changed | Altered in place (**Modify Settings** / **Reset Settings**) |
| A column dropped after it is removed from `@orderBy` | Altered in place (**Modify Order By** runs before **Drop Column**) |

Terms are compared ignoring spaces, backticks and case.

A recreated table is created with `CREATE OR REPLACE` and its existing data is **not kept**: it is empty until the next run reloads it. The deploy shows a `Warning: Table Recreated (<reason>)` stage when this happens.

To keep later sort-key changes cheap, set `@primaryKey` to the leading column(s) of `@orderBy` when the node is first created.

`@orderBy` and `@primaryKey` are written to ClickHouse as given and are not checked by the node types. ClickHouse itself rejects invalid keys, for example a `@primaryKey` that is not the leading terms of `@orderBy`, or a key that names a column the node no longer has. What a rejected key leaves behind:

- **Table redeploy, altered in place:** the error happens on the clone, so the live table is unchanged.
- **Table redeploy, recreated:** `CREATE OR REPLACE` fails, so the existing table and its data are kept. The `Warning: Table Recreated` stage still shows, because it runs before the recreate.
- **View changed to a table:** the view is dropped first, so after a failed `CREATE` the node has no object until the key is fixed and redeployed.

### Storage Location Changes

A redeploy compares the node's deployed path with its desired path. The deployed path is built from the mapping the node was deployed with (`currentState.storageLocations`), so both a node moved to another location and a location whose mapping changed (same location, new database) count as a move:

| Node | Stages |
|---|---|
| Table | **Clone Table** (from the old database) → alters, if any → **Rename Table** (into the new one) → **Drop Table** at the old path. Data is kept. |
| View | **Rename View**, or **Drop View** + **Create View** when its definition also changed |

A view is also recreated (**Create View**) when the mapping of a location it **reads from** changed, because its `SELECT` names the old database. Only the view's own source locations are compared: a change to any other location (for example the view's source is in `SRC` and only `TARGET2` changed) leaves the view as it is. Tables need nothing here: the load resolves the source with the current mapping when it runs.

`ref_no_link()` always resolves a location with the environment's **current** mapping, so it is used for where an object should be now (the desired path, the run templates' load target, `ref()` in the node's SQL) but not for the deployed path: after a mapping change it would give the new database for both, and the move would never be detected.

### How a Load Replaces Rows (Dimension and Fact)

ClickHouse has no `MERGE`, and the tables are plain MergeTree. A Dimension or Fact load therefore runs in two stages:

1. **INSERT** the row set a `MERGE` would have applied: new keys, plus a new copy of every changed row. An "update" re-inserts the same business key with a newer `SYSTEM_UPDATE_DATE`; an SCD Type 2 expiry re-inserts the old version with `SYSTEM_CURRENT_FLAG = 'N'` and its end date.
2. **Load table Using Merge - Clean Up Data** — a `DELETE` of the copies the insert replaced: per business key (plus `SYSTEM_VERSION` for SCD Type 2, plus the surrogate key on a Dimension) only the row with the latest `SYSTEM_UPDATE_DATE` is kept. Only keys that now have more than one row are read, and only the target is read — never the source.

A plain `SELECT` on the table is correct right after the run; no `FINAL` or de-duplicating view is needed.

| `@mergeStrategy` | Matches on | What the load does |
|---|---|---|
| `changeTracking` (default when `@mergeStrategy` is not set) | `@isBusinessKey` columns | New keys are inserted; changed rows are re-inserted with a newer `SYSTEM_UPDATE_DATE` and the older copy is removed |
| `lastModified` | `@isBusinessKey` columns, plus exactly one `@lastModifiedTracking` column | Only rows newer than the target's are loaded, then as `changeTracking` |
| `allColumnMatch` (Fact) | Every non-system column (`@isBusinessKey` is ignored) | Only rows with no fully matching row in the target are inserted; nothing is updated or deleted |

A Fact with no `@isBusinessKey` column and no `@mergeStrategy` is loaded as a plain insert, with no clean-up.

* Between the two stages a reader can briefly see both copies of a changed row. If the clean-up stage fails, the extra copies stay until the next successful run's clean-up removes them.
* The clean-up tells the copies apart only by `SYSTEM_UPDATE_DATE`, so it needs that column; without `@isSystemUpdateDate` the clean-up stage does not run (the validation checks require it under `changeTracking` / `lastModified`).
* The load reads its own SELECT with the user's settings, as in Preview — it does not set `join_use_nulls`.

### Unique Business Keys (Fact and Dimension)

The `@isBusinessKey` column(s) must be unique in the node's source: one row per business key per load. Making sure of this is the user's responsibility; the node types do not check it.

If the source returns the same business key more than once, ClickHouse does not fail the load. Both rows are inserted with the same `SYSTEM_UPDATE_DATE`, the clean-up keeps the row(s) with the latest `SYSTEM_UPDATE_DATE` per key, and so **both copies stay in the target**.

De-duplicate the data before it is loaded, for example:

- In the node's SELECT, with `QUALIFY` or `LIMIT 1 BY`:

  ```sql
  SELECT ...
  FROM {{ ref('SRC', 'ORDERS') }} `ORDERS`
  QUALIFY row_number() OVER (PARTITION BY `order_id` ORDER BY `last_modified` DESC) = 1
  ```

  ```sql
  SELECT ...
  FROM {{ ref('SRC', 'ORDERS') }} `ORDERS`
  ORDER BY `order_id`, `last_modified` DESC
  LIMIT 1 BY `order_id`
  ```

- With a node-level `@tests(..., false, "Before")` on the business key, so the run fails instead of loading duplicates — see [Duplicate or NULL Business Key Check](#duplicate-or-null-business-key-check).
- With a duplicate check or clean-up in `@preSQL`.

### Surrogate Keys (Dimension)

ClickHouse has no identity columns. The surrogate key is a plain column, and the Dimension load gives a **new row or a new SCD Type 2 version** its key from the column's `@defaultValue`. Rows that are re-inserted by the load (an expired version, an in-place update) keep the key they already have.

The `@isSurrogateKey` column is always created **not null** (never `Nullable`), with or without `@notNull`, because every row must have a key. This applies to Dimensions only: Facts have no surrogate key.

The recommended key is a UUID, which is what a new Dimension's generated SELECT uses:

```sql
generateUUIDv4() AS `DIM_CUSTOMER_KEY` @isSurrogateKey @notNull @defaultValue("generateUUIDv4()")
```

- A `UUID` surrogate key **must** have `@defaultValue("generateUUIDv4()")`; the deploy and run fail validation without it.
- Any other surrogate key without `@defaultValue` takes the value the SELECT computes for it, so the SELECT must give every new row (and every new SCD Type 2 version) a unique key. A validation warning is shown.
- **Zero key record:** the surrogate key gets `surrogateKeyValue` (the first `@zeroKey` value). A `UUID` surrogate key takes it when it is a UUID, e.g. `@zeroKey("11111111-1111-1111-1111-111111111111", ...)`, and otherwise gets the nil UUID `00000000-0000-0000-0000-000000000000`. A numeric surrogate key takes the number as written.
- **Adding the column to an existing table:** ClickHouse computes a new column's `DEFAULT` on read for rows already in the table, so `generateUUIDv4()` would give those rows a different value on every query. The redeploy runs **Materialize Column Default** (`MATERIALIZE COLUMN`) after **Add Column** for every new column with a default, so the values are written once.
- A Fact that looks up a Dimension's key can fall back to the zero record's key for unmatched members, e.g. ``coalesce(`dc`.`customer_key`, toUUID('00000000-0000-0000-0000-000000000000'))`` — see [Fact with Dimension Key Lookups](#fact-with-dimension-key-lookups).

### Annotation Reference

Annotations shared by Work, Dimension and Fact, described once. Where a node type behaves differently, its variant is shown under its own label. Node-type-specific annotations (for example `@mergeStrategy` or the system columns) are described in each node type's section. Annotations shared only by Dimension and Fact (for example `@lastModifiedTracking` and the create/update date system columns) are here too, with each node type's differences labelled.

#### Node Annotations

##### `@materializationType`

`@materializationType(type)` ***(reserved)***

table/view.

| **Value** | **Description** |
|---|---|
| `table` | MergeTree table (default). |
| `view` | View. |

* Use lowercase `table` or `view` — case and extra spaces are ignored (`"Table "` reads as `table`); any other value stops the deploy and the run with an **Unsupported Materialization Type** check.
* *Not specified in the SQL editor → defaults to **table**.*

**Example:**

```sql
@materializationType("view")
```

##### `@orderBy`

`@orderBy(term, ...)`

The table's `ORDER BY` (sort) key. Each argument is one term — a column or an expression, written as it should appear in the SQL.

| **Parameter** | **Description** |
|---|---|
| **term** | A column or expression, e.g. ``"`n_Nationkey`"`` or ``"toYYYYMM(`last_Modified`)"``. Repeat the argument for each term, in sort order. |

* Without `@orderBy` (and `@primaryKey`) the table uses `ORDER BY tuple()` — see [ClickHouse Cloud Defaults](#clickhouse-cloud-defaults).
* Written to ClickHouse as given; ClickHouse rejects an invalid key itself.
* ⚠️ On redeploy, removing trailing terms or adding new columns (without a default) is altered in place when `@primaryKey` is set; any other `@orderBy` change (or renaming / retyping a column used in it) recreates the table — existing data is lost. See [Sort Key and Partition Key Changes](#sort-key-and-partition-key-changes).
* **Note:** Ignored on Views.

**Example:**

```sql
@orderBy("`n_Nationkey`", "`n_Name`", "toYYYYMM(`last_Modified`)")
```

##### `@primaryKey`

`@primaryKey(term, ...)`

The table's `PRIMARY KEY`. Each argument is one term, as in `@orderBy`.

* ClickHouse requires the primary key to be the leading terms of `ORDER BY`, in the same order — the create fails otherwise.
* Without `@orderBy`, the primary key is also the sort key: ``@primaryKey("`n_Nationkey`")`` → ``ORDER BY (`n_Nationkey`)``.
* When it is the same as `@orderBy`, it is not written separately.
* ⚠️ Changing `@primaryKey` (or renaming / retyping a column used in it) on redeploy recreates the table — existing data is lost.
* **Note:** Ignored on Views.

**Example:**

```sql
@orderBy("`n_Nationkey`", "`n_Name`", "toYYYYMM(`last_Modified`)")
@primaryKey("`n_Nationkey`", "`n_Name`")
```

##### `@partitionBy`

`@partitionBy(term, ...)`

The table's `PARTITION BY` key. Each argument is one term — a column or an expression; several terms are partitioned together.

* Keep it coarse (e.g. one partition per month): each partition is stored separately, and too many partitions slow inserts down and eventually make them fail.
* Without `@partitionBy` the table is not partitioned.
* ⚠️ Changing `@partitionBy` (or renaming / retyping a column used in it) on redeploy recreates the table — existing data is lost.
* **Note:** Ignored on Views.

**Example:**

```sql
@partitionBy("toYYYYMM(`order_Date`)")
@partitionBy("toYYYYMM(`order_Date`)", "`region`")
```

##### `@settings`

`@settings(setting, ...)`

The table's MergeTree `SETTINGS`. Each argument is one setting, written as `name = value`.

* `allow_nullable_key = 1` is added automatically when the table has an `@orderBy`, `@primaryKey` or `@partitionBy`, so `Nullable` columns can be key terms — set it here to override it.
* On redeploy, changes are applied in place: **Modify Settings** (`MODIFY SETTING`) for added or changed values, **Reset Settings** (`RESET SETTING`) for removed ones. Settings are compared by name (case-insensitive) and value (ignoring spaces).
* **Note:** Ignored on Views.

**Example:**

```sql
@settings("index_granularity = 8192", "min_bytes_for_wide_part = 0")
```

##### `@writeMode`

`@writeMode("truncateInsert | append")`

| **Value** | **Description** |
|---|---|
| `truncateInsert` | **Truncate table** (`TRUNCATE`) clears the table, then the load runs, replacing its contents entirely. |
| `append` | **Work:** Inserts the new rows via `INSERT INTO`, alongside whatever is already there.<br/>**Dimension / Fact:** Loads the new rows alongside whatever is already there. |

* **Work:** *Not specified in the SQL editor → defaults to **truncateInsert**.* ClickHouse has no `INSERT OVERWRITE`, so truncate and insert are two separate stages, not one atomic statement — see [Known Limitations](#known-limitations).
* **Dimension / Fact:** *Not specified in the SQL editor → defaults to **append**.*
* **Note:** Ignored on Views.

**Example:**

```sql
@writeMode("append")
```

##### `@disableTests`

`@disableTests`**²**

Controls whether configured tests are skipped.

* *Specified in the SQL editor → all node- and column-level tests are skipped.*
* *Not specified in the SQL editor → tests run normally.*
* To turn tests back on, remove the annotation. Useful while developing a node — iterate on the SQL first, then re-enable once the logic is settled.

**Example:**

```sql
@disableTests
```

##### `@tests`

`@tests(querySQL, continueOnFailure?, runOrder?)`**²**

***(repeatable)*** Node-level data quality test.

**²** Node level tests are performed only when `disableTests` is OFF.
```text
@tests("<querySQL>", <continueOnFailure>, "<runOrder>")
```
| Parameter | Description |
|-----------|-------------|
| querySQL | SQL statement to execute as a validation test. The test fails if the query returns any records. |
| continueOnFailure |**(optional)** `true`(default) or `false`. Marks whether the run is meant to continue when the test fails. |
| runOrder |**(optional)** `Before` or `After`(default). Determines whether the test is executed before or after the load operation. |

* Runs `querySQL`; fails if it returns any records. Stages are named **Pre Load Test `<n>`** / **Post Load Test `<n>`**.
* Skipped entirely when **@disableTests** is set.

**Example:**

```sql
@tests("SELECT 1 FROM {{ this }} GROUP BY `n_Nationkey` HAVING count() > 1", false, "After")  -- runs After the load, continueOnFailure=false
```

**More examples:**

```text
@tests("SELECT 1 FROM {{ this }} GROUP BY `n_Comment` HAVING count() > 1", true, "Before")  -- runs Before the load, continueOnFailure=true
@tests("SELECT 1 FROM {{ this }} GROUP BY `n_Comment` HAVING count() > 1", false)  -- runs After the load (default), continueOnFailure=false
@tests("SELECT 1 FROM {{ this }} GROUP BY `n_Comment` HAVING count() > 1")  -- runs After the load (default), continueOnFailure=true (default)
```

##### `@preSQL`

`@preSQL(querySQL)`

***(repeatable)*** SQL statement to execute `before` the data load operation.

| **Parameter** | **Description** |
|---|---|
| **querySQL** | SQL statement to execute before the data load operation. |

* Repeat the annotation to run multiple statements, in the order they appear (**Pre-SQL `<n>`**).
* **Note:** Ignored on Views.

**Example:**

```sql
@preSQL("DELETE FROM {{ this }} WHERE `load_date` < today() - 90")
```

##### `@postSQL`

`@postSQL(querySQL)`

***(repeatable)*** SQL statement to execute `after` the data load operation.

| **Parameter** | **Description** |
|---|---|
| **querySQL** | SQL statement to execute after the data load operation. |

* Repeat the annotation to run multiple statements, in the order they appear (**Post-SQL `<n>`**).
* **Note:** Ignored on Views.

**Example:**

```sql
@postSQL("INSERT INTO {{ ref('AUDIT', 'LOAD_LOG') }} (`table_name`, `load_ts`) VALUES ('WRK_NATION', now())")
```

#### Column Annotations

##### `@id` (column)

`@id("<value>")`

Stable column ID for lineage tracking.

| **Parameter** | **Description** |
|---|---|
| **value** | Six hexadecimal digits, unique within the node, e.g. `110e75`. |

* **Dimension / Fact:** required on every column — the SQL editor generates a fresh `@id("<value>")` for each column it creates, and the **Missing Column IDs** check flags any column that is missing one. This is deliberate: the `@id` keeps a column's identity separate from its name, so a rename is an in-place `RENAME COLUMN` rather than a drop and re-add.
* **Work:** optional. Without it Coalesce uses the column's name as its id, so a rename drops the column and adds a new one.
* Not for manual editing — value is a stable identifier generated once at creation time.
* **Column added later:** make sure it gets its own `@id` too. If you're editing by hand, add a new, unique 6-hex-digit `@id("<value>")` along with the column; an agent can generate one for you. Don't reuse a value already on the node — a repeated value fails the **Duplicate Column IDs** check.
* **Duplicate column names:** if the SELECT returns the same column name twice, Coalesce renames the extra copy (`SYSTEM_CREATE_DATE` → `SYSTEM_CREATE_DATE1`) and drops its `@id`; this is reported by the **Duplicate Column Names** check rather than as a missing ID.

**Example:**

```sql
@id("110e75")
```

##### `@defaultValue`

`@defaultValue(<value>)` ***(reserved)***

Adds a `DEFAULT` expression to the column.

| **Parameter** | **Description** |
|---|---|
| **value** | Default value or ClickHouse expression — quoted to match the column's data type (see below). |

* Quote to match the column's data type —
* number: `@defaultValue("<num>")`
* string: `@defaultValue("'<string>'")`
* expression: `@defaultValue("generateUUIDv4()")`, `@defaultValue("now()")`
* A column added on redeploy with a `@defaultValue` is materialized for the existing rows (**Materialize Column Default**), so a non-deterministic default such as `generateUUIDv4()` or `now64()` is written once instead of being recomputed on every read.
* Changing or removing it on redeploy runs **Alter Column** (`MODIFY COLUMN ... DEFAULT` / `REMOVE DEFAULT`).
* On a Dimension surrogate key it is the value new rows and new versions get — see [Surrogate Keys](#surrogate-keys-dimension).
* **Note:** Ignored on Views.

**Example:**

```sql
@defaultValue("20")
@defaultValue("'NA'")
@defaultValue("generateUUIDv4()")
```

##### `@inHash`

`@inHash("<hashName>", <hashOrder>)`**¹**

***(repeatable)*** Marks a column as an input to a generated hash key.

| **Parameter** | **Description** |
|---|---|
| **hashName** | Columns sharing the same value are grouped together into the same hash. |
| **hashOrder** | This column's position within that group. |

* Call `get_hash("<hashName>")` elsewhere in the SELECT to produce the hash column from the marked columns.

**Example:**

```sql
`n_Name` AS `n_Name` @inHash("GH_COL", 1),
{{ get_hash('GH_COL') }} AS `GH_COL`
```

**`get_hash()` macro**

**¹** The hash transformation uses the reusable `get_hash()` macro:

```SQL
{{ get_hash("<hash_name>", "<algo>", "<delimiter>") }}
```

| Parameter | Description |
|-----------|-------------|
| `hash_name` | Hash name used across columns to identify the columns included in the hash. |
| `algo` | **(optional)** Hashing function. `MD5`, `SHA1`, `SHA224`, `SHA256`, `SHA384` and `SHA512` (any case) return a lowercase hex `String`. Any other ClickHouse hash function (e.g. `cityHash64`, `xxHash64`, `sipHash64`) is called as written and returns its own type (usually `UInt64`). Defaults to `SHA1`. |
| `delimiter` | **(optional)** Delimiter used to separate column values when generating the hash. Defaults to `\|\|` and can be customized; `''` concatenates without one. |

* Each value is converted with `toString()`, and NULL is hashed as the text `'null'`.
* Columns are combined in `hashOrder` order.
* With no column in the group, `get_hash()` returns `NULL`.

**`get_hash()` examples:**

Using hash macro (default — SHA1)
```sql
<col_name> AS <col_name> @inHash("GH_COL", 1),
{{ get_hash('GH_COL') }} AS `GH_COL`
```
Using hash macro (MD5)
```sql
<col_name> AS <col_name> @inHash("GH_COL", 1),
{{ get_hash('GH_COL', 'MD5') }} AS `GH_COL`
```
Using hash macro (algo=SHA256, delimiter='~')
```sql
<col_name> AS <col_name> @inHash("GH_COL", 1),
{{ get_hash('GH_COL', algo='SHA256', delimiter='~') }} AS `GH_COL`
```
Using a ClickHouse hash function (UInt64 result)
```sql
<col_name> AS <col_name> @inHash("GH_COL", 1),
{{ get_hash('GH_COL', 'cityHash64') }} AS `GH_COL`
```
Using multiple keys hash macro
```sql
<col_name1> AS <col_name1> @inHash("GH_COL", 1),
<col_name2> AS <col_name2> @inHash("GH_COL", 2),
{{ get_hash('GH_COL') }} AS `GH_COL_COMBINED`
```
Using multiple hash macros
```sql
<col_name1> AS <col_name1> @inHash("GH_COL1", 1) @inHash("GH_COL2", 2),
<col_name2> AS <col_name2> @inHash("GH_COL1", 2),
<col_name3> AS <col_name3> @inHash("GH_COL2", 1),
{{ get_hash('GH_COL1') }} AS `GH_COL_COMBINED1`,
{{ get_hash('GH_COL2', delimiter='~') }} AS `GH_COL_COMBINED2`
```
What the default renders to:
```sql
lower(hex(SHA1(ifNull(toString(<col_name1>), 'null') || '||' || ifNull(toString(<col_name2>), 'null'))))
```

##### `@lastModifiedTracking`

Dimension: `@lastModifiedTracking(scdType?)` · Fact: `@lastModifiedTracking`

Marks the column used to detect newer source rows for an incremental load.

* Datatype — `Date` / `DateTime` types or any incrementing numeric type.
* Can only be applied to one column.
* Must not be NULL in the source — the **Check NULL values for `<column>` column** stage fails the run, since a NULL value can never compare as newer: a row loaded with a NULL tracking value is never updated again.
* **Note:** Ignored on Views.

**Dimension:**

* Only this column decides a change — other columns that change without a newer tracking value are never applied, even under SCD Type 1.

| **Parameter** | **Description** |
|---|---|
| **scdType** | **(optional)** `1` overwrites the row in place, `2` expires the row and inserts a new version. *Not specified → defaults to 1.* Any other value fails the **Invalid configuration: lastModifiedTracking scdType** check. |

**Fact:**

Marks the column used to detect newer source rows for an incremental load (SCD Type 1).
* Only this column decides a change — other columns that change without a newer tracking value are never applied.
* Used only by `@mergeStrategy("lastModified")`.

**Example:**

```sql
-- Dimension
@lastModifiedTracking(2)
-- Fact
@lastModifiedTracking
```

##### `@isSystemCreateDate`

`@isSystemCreateDate`

Marks this column as the timestamp a row was first created.

* **Note:** Ignored on Views. Agentic creation only — manual creation adds this column automatically.
* Expected expression: `CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS "SYSTEM_CREATE_DATE" @isSystemCreateDate` (a `DateTime`, whole seconds).

**Dimension:**

Marks this column as the timestamp a row (or, under SCD Type 2, a specific row version) was first created.
* Required — read back from the target and preserved unchanged on every row after its initial insert.

**Fact:**

* Required for `changeTracking`/`lastModified` — read back from the target and preserved unchanged on every row after its initial insert.
* Optional for `allColumnMatch` and plain insert — rows are only ever inserted, so it's the record of when each row was loaded; it is written exactly as the SELECT/CTE computes it.

##### `@isSystemUpdateDate`

`@isSystemUpdateDate`

Marks this column as the timestamp a row was last updated.

* The clean-up after each load keeps, per key, only the row with the latest value of this column — see [How a Load Replaces Rows](#how-a-load-replaces-rows-dimension-and-fact).
* **Note:** Ignored on Views. Agentic creation only — manual creation adds this column automatically.
* Expected expression: `CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS "SYSTEM_UPDATE_DATE" @isSystemUpdateDate` (a `DateTime`, whole seconds — see [Loads Within the Same Second](#known-limitations)).

**Dimension:**

* Required for SCD Type 2 — read back from the target and refreshed to the load time whenever a row is inserted as a new version or its prior current version is expired.
* Required for SCD Type 1 — set to the load time on every inserted or changed row.

**Fact:**

* Required for `changeTracking`/`lastModified` — set to the load time on every inserted or changed row.
* Optional for `allColumnMatch` and plain insert — if kept, it is written exactly as the SELECT/CTE computes it.

### Identifier Quoting in Annotations

ClickHouse identifiers are always case-sensitive, quoted or not: `n_Name` and `N_NAME` are different columns. Quote an identifier only when it contains special characters or is a keyword — with backticks (`` `n_Name` ``) or double quotes (`"n_Name"`).

Annotation arguments are written in double quotes, so backticks are the easiest way to quote an identifier inside them:

```
@tests("SELECT 1 FROM {{ this }} GROUP BY `n_Name` HAVING count() > 1")
@orderBy("`n_Nationkey`", "toYYYYMM(`last_Modified`)")
```

To use double-quoted identifiers instead, double each inner quote — `""` inside the annotation string becomes a single `"` in the SQL — or swap the outer quotes to single quotes:

```
@tests("SELECT ""Nation_Key"" FROM {{ ref('SRC', 'NATION') }} GROUP BY ""Nation_Key"" HAVING count() > 1", false, "Before")
@preSQL(' SELECT 1 FROM {{ this }} GROUP BY "n_Name" HAVING count() > 1 ')
```

A backslash (`\"`) does not escape a quote inside an annotation string and fails with a syntax error.

Key annotation terms (`@orderBy`, `@primaryKey`, `@partitionBy`) are written into the `CREATE` as given, so a term must use the column's exact name.

### Column-Level Data Quality Tests

🚦 Applicable only when `@disableTests` is not set. Each runs **After** the load and continues the run on failure. Each stage is named **`<column>: <test>`**. *Not specified in the SQL editor → test is off.*

| **Property** | **Description** |
|---------|-------------|
| `@not_null` | Fails on rows where the column is NULL.<br/>Example: `@not_null` |
| `@uniqueness` | Fails when a value appears on more than one row.<br/>Example: `@uniqueness` |
| `@empty` | Fails on rows where the column trims to the empty string.<br/>NULL values pass this test — they're caught by `@not_null` instead.<br/>Example: `@empty` |
| `@accepted_values("<value>", ...)` | Fails on rows whose value is outside the allow list. NULL values pass.<br/>Repeatable — every occurrence on the column is merged into one list. Each call takes a comma-separated list or separate arguments —<br/>`accepted_values("1, 3, 5")`<br/>`accepted_values("1", "3", "5")`<br/>`accepted_values("1") accepted_values("3, 5")`<br/>Each value is pasted into the SQL verbatim, so write it as a valid SQL value for the column's data type —<br/>numeric: with or without double quotes<br/>string: single quotes inside double quotes, `"'<string>'"`<br/>boolean: `true`/`false`, with or without double quotes<br/>date/time: a literal in single quotes inside double quotes, or a function, e.g. `"'2026-01-01'"` or `"toDate('2026-01-01')"`<br/>Example: `@accepted_values("'ALGERIA', 'ARGENTINA'")` |
| `@rejected_values("<value>", ...)` | Fails on rows whose value is in the deny list. NULL values pass.<br/>Same syntax and quoting rules as `accepted_values`.<br/>Example: `@rejected_values("'NA'")` |
| `@min_max("<min>", "<max>")` | Fails on rows outside the inclusive range. NULL values pass.<br/>Applies to numeric and date/time columns only.<br/>Each bound is pasted into the SQL verbatim, so write it as a valid SQL value for the column's data type —<br/>positive numeric (integer, decimal or float): with or without double quotes<br/>negative numeric (integer, decimal or float): double quotes required<br/>date/time: a literal or expression in double quotes, e.g. `"'2026-01-01'"`, `"toDate('2026-01-01')"` or `"now()"`<br/>Example: `@min_max("0", "4")` |
| `@min_value("<min>")` | Fails on rows below the bound. NULL values pass.<br/>Value formatting — see `min_max`.<br/>Example: `@min_value("0")` |
| `@max_value("<max>")` | Fails on rows above the bound. NULL values pass.<br/>Value formatting — see `min_max`.<br/>Example: `@max_value("100")` |
| `@freshness(<interval>, "<unit>")` | Fails when the newest value in the column is older than the given interval, or the table is empty.<br/>**interval** — how far back from now the newest value is allowed to be, expressed in the unit given by **unit**.<br/>**unit** — SECOND, MINUTE, HOUR, DAY, WEEK, MONTH, or YEAR (defaults to DAY).<br/>The column is compared as `toDateTime64(<column>, 3)` against `now64(3) - INTERVAL <interval> <unit>`.<br/>**Note:** on a `Date` column the value is truncated to midnight.<br/>Example: `@freshness(7, "DAY")` |
| `@relative_time("<operator>", "<other_column>")` | Compares this column against another date/time column on the same node.<br/>e.g. `@relative_time("<=", "END_DATE")` fails rows where this column's value is not `<=` END_DATE.<br/>Either side NULL → row is skipped (passes).<br/>Both columns should have the same datatype.<br/>Example: `@relative_time("<", "L_M_2")` |

---

### Notes & Supported SQL Functionality

- Verify that all **column datatypes** are successfully resolved before creating the object. Columns with an unknown or invalid datatype may cause stage generation or runtime failures. Nodes downstream of a wrongly typed column inherit it, so fix it at the first node — for example with an explicit `CAST(... AS <type>)` in the final SELECT. See [`Variant` Columns](#known-limitations).

- Any keyword that is valid immediately after **SELECT** is accepted in the final **SELECT** clause (right after any CTEs) — for example **DISTINCT**.

    ```sql
    SELECT DISTINCT
         `n_Regionkey` AS `n_Regionkey`,
         `n_Name` AS `n_Name`
    FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
    ```

- **Multi-Source Joins & Enrichment:** Reference and join multiple upstream nodes (e.g., joining `orders` and `lineitem`) within a single node to flatten data or create enriched wide tables while maintaining full lineage for every source.

- **Conditional Logic via CASE Statements and ClickHouse functions:** Standard `CASE WHEN`, plus ClickHouse functions such as `if()`, `multiIf()`, `coalesce()`, `toStartOfMonth()` and `replaceAll()`.

- **Flexible Projection (SELECT * with Expressions):** Select all columns from a source (`SELECT *`) while appending new calculated expressions in the same statement.<br/>**Note:** Column-level annotations (e.g. `@not_null`, `@inHash`) can only be attached to columns that are explicitly listed in the `SELECT` clause — they cannot be applied to columns pulled in via `SELECT *`.

- **Nested Subqueries:** Subqueries within SELECT, FROM, or WHERE clauses, enabling granular filtering and lookups that don't require separate nodes.

- **Common Table Expressions (CTEs)**: Standard `WITH` clauses to break down multi-step transformation logic into readable, modular blocks. Coalesce tracks lineage through each CTE and back to the source tables. A Dimension or Fact load continues the node's own `WITH` clause with its internal CTEs, so the node's CTE names must not clash with `SOURCE_DATA`, `TARGET_CURRENT`, `CHANGE_DETECTION` or `MERGE_ROWS`.

- **ClickHouse de-duplication clauses:** `QUALIFY` and `LIMIT n BY` are supported in the node's SELECT — see [Unique Business Keys](#unique-business-keys-fact-and-dimension).

- If a CTE is referenced in templates that may include joins, always use a **table alias** and qualify all column references with that alias. This prevents ambiguous column errors and ensures the template remains extensible as additional joins are introduced.

---

### Known Limitations

Users should be aware of the following technical constraints when using SQL-first nodes on ClickHouse:

* **Parsable SQL Only**:
 The node only supports SQL that can be fully parsed by the platform's engine. Non-standard SQL that bypasses standard parsing will not work.

* **SELECT Statements Only**:  
This node only supports data retrieval and transformation logic. DML or DDL commands such as `CREATE`, `INSERT`, `DELETE`, `ALTER`, or `TRUNCATE` are not supported in the node's SQL and will cause execution failures (use `@preSQL` / `@postSQL` for them).

* **Support for `UNION` and `UNION ALL`**:  
`UNION` and `UNION ALL` are fully supported when used within **Common Table Expressions (CTEs)**. While these keywords can also be used in standard `SELECT` statements without generating an error, they may not be parsed correctly by the platform, so subsequent clauses (such as `JOIN`s) may be interpreted as part of a standard join structure. Always implement these operations inside a CTE.

* **Reserved Keywords as Annotation Names**:  
Avoid naming custom annotations after words that are reserved keywords in the platform's SQL grammar — e.g. `UNIQUE`, `AS`, `PRIMARY`. The parser may fail to parse such annotations and throw a validation error.

* **Switching Between YAML and SQL Node Types**:  
Converting an existing YAML (`.yml`) node to a SQL (`.sql`) node, or vice versa, is not supported.

* **Recreated Tables Lose Their Data**:  
A redeploy that changes `@partitionBy`, `@primaryKey`, an `@orderBy` change ClickHouse cannot alter, or a key column's name or type recreates the table empty — including a Dimension's whole SCD Type 2 history. The **Warning: Table Recreated (\<reason\>)** stage shows when this happens. See [Sort Key and Partition Key Changes](#sort-key-and-partition-key-changes).

* **Bad Type Conversions to a `Nullable` Type Store NULL**:  
Changing a column to a `Nullable` type its values cannot convert to (e.g. `'ALGERIA'` → `Nullable(UInt32)`) succeeds and silently replaces those values with NULL. See [Column Type Changes](#column-type-changes).

* **NULLs Inserted into Non-Nullable Columns**:  
They are stored as the column's default (`0`, `''`, ...) instead of failing, unless the Coalesce user has `insert_null_as_default = 0`. See [NULLs in non-nullable columns](#nulls-in-non-nullable-columns).

* **`truncateInsert` Is Not Atomic**:  
**Truncate table** and the load are separate statements. If the load fails after the truncate, the table is left empty, or holding the blocks written before the failure (ClickHouse writes an `INSERT ... SELECT` in blocks). Re-run the node to reload it.

* **Two-Step Dimension / Fact Loads**:  
The load inserts the new copies first and deletes the replaced ones in **Clean Up Data**, so between the two stages (or after a failed clean-up, until the next run) a changed key can have two rows. See [How a Load Replaces Rows](#how-a-load-replaces-rows-dimension-and-fact).

* **Loads Within the Same Second**:  
The default system column expression `CAST(CURRENT_TIMESTAMP AS TIMESTAMP)` gives a `DateTime` column, which stores whole seconds. The clean-up tells a row's copies apart by `SYSTEM_UPDATE_DATE`, so if two loads change the same key within one second both copies have the same value and both are kept. Use a `DateTime64` type for `SYSTEM_UPDATE_DATE` (e.g. `CAST(now64(6) AS DateTime64(6))`) if a node can run more than once a second.

* **Duplicate Business Keys**:  
Duplicates in the source are not rejected: both copies are inserted and kept. De-duplicate upstream — see [Unique Business Keys](#unique-business-keys-fact-and-dimension).

* **NULL Business Keys**:  
Dimension and Fact expect every business key to be non-NULL. Matching uses plain equality and NULL never equals NULL, so a source row with a NULL business key never matches its target row: instead of updating it, every run **inserts it again as a new row** (and an SCD2 Dimension never expires the old one). Under `allColumnMatch` the same applies to a NULL in any compared column. Filter or default NULL keys upstream, e.g. `WHERE <business key> IS NOT NULL` or `coalesce(<business key>, '<placeholder>')`, or check it with a `Before` test — see [Duplicate or NULL Business Key Check](#duplicate-or-null-business-key-check).

* **`truncateInsert` with SCD Type 2**:  
`@writeMode("truncateInsert")` empties the table before every load, so an SCD Type 2 dimension (`changeTracking` with an `@isChangeTracking` column, or `lastModified` with `@lastModifiedTracking(2)`) loses all its history on each run — every row is reloaded as version 1. The combination runs without error, but it defeats the purpose of SCD Type 2; use the default `append` for versioned dimensions.

* **Keys Deleted from the Source**:  
A business key that disappears from the source is left as it is in the target — under SCD Type 2 its current row stays current (`SYSTEM_CURRENT_FLAG` = `'Y'`, open `SYSTEM_END_DATE`), and under SCD Type 1 the row is kept unchanged. Deletes are never detected, expired or flagged; handle them separately (e.g. with `@postSQL`) if the dimension needs to reflect removed keys.

* **Adding a Not-Null Column Without a Default**:  
ClickHouse adds a `@notNull` column without `@defaultValue` to a table that already holds rows: the existing rows get the type's default value (`0`, `''`, ...), not an error. Add a `@defaultValue` if those rows need a specific value.

* **System Columns Added to a Loaded Table**:  
Adding `@isSystemCreateDate` / `@isSystemUpdateDate` to a table that already holds rows adds the columns with NULL (or the type's default when not `Nullable`) in every existing row. `@isSystemCreateDate` is carried over from the target on every later update, so it keeps that value for those rows. Backfill them once (e.g. with `@postSQL`) or reload with `@writeMode("truncateInsert")` if they need values.

* **`Variant` Columns in SQL Nodes**:  
Coalesce does not infer the `Variant` data type correctly when it reads a SQL node's `SELECT`. A source column of type `Variant(Array(UInt64), String, UInt64)` is inferred on the downstream SQL node as `String(Array(UInt64), String, UInt64)`, which is not a valid ClickHouse type, so the node's create fails with:

  ```
  String data type family mustn't have more than one argument - size in characters
  ```

  The node types do not try to repair the inferred type. Until Coalesce infers `Variant` correctly, convert the column in the `SELECT` to a type Coalesce understands, for example ``toString(`c_Variant`) AS `c_Variant` ``, or leave the column out of the node.

* **Array and Map Columns Show as Changed on Every Deploy**:  
Coalesce marks every column of a SQL node as nullable. ClickHouse cannot make `Array` or `Map` columns `Nullable`, so the node types create them as plain `Array(...)` / `Map(...)`, and after a deploy the deployed state records those columns as not nullable. The next plan compares the workspace (`nullable: true`) with the deployed state (`nullable: false`), so it lists the node as changed on every deploy, for example:

  ```
  columns > c_array > nullable : false → true
  columns > c_map   > nullable : false → true
  ```

  The redeploy finds nothing to alter in ClickHouse and runs only **Metadata Update-Default**, so the table is not affected. Until Coalesce stops marking these columns as nullable, add `@notNull` to `Array` and `Map` columns so the workspace matches the deployed state.

* **Storage Mapping Changes Depend on the Platform**:  
A location whose mapping changed (same location, new database) is only detected when the platform passes the deployed mapping in `currentState.storageLocations` — see [Storage Location Changes](#storage-location-changes).

* **`CLONE AS` in a Replicated Database**:  
Table redeploys copy the table with `CREATE TABLE ... CLONE AS`, which ClickHouse does not support in a `Replicated` database engine. Use an `Atomic` database (the default) or ClickHouse Cloud's `Shared` database, where `EXCHANGE TABLES` is also atomic.

* **Large or High-Precision Numbers in Test Values**:  
An unquoted number in an annotation is read as a floating-point value, so integers beyond roughly 15–16 digits and decimals with more than about 16 significant digits are rounded before the test runs. Wrap such values in double quotes — `@accepted_values("12345678901234567890")` — to pass them through exactly.

* **Commas Inside Values in `accepted_values`/`rejected_values`**:  
Values are split on every comma, trimmed, and re-joined with `", "`. A string written with exactly one space after each comma, like `"'4, 5'"`, is tested as written; any other spacing is normalised, so `"'A,B'"` is tested as `'A, B'`. A function call with several arguments (e.g. `"toDateTime('2026-06-15 00:00:00', 'UTC')"`) keeps working, because the pieces are re-joined in the same order.

---

### Usage Examples

Common ways to use the SQL nodes. The SQL patterns under Work Examples (CTEs, window functions, DISTINCT) work the same way in a Dimension or Fact node.

**Work Examples**
* [Sample Node with Annotations](#sample-node-with-annotations)
* [Sample Node with DISTINCT](#sample-node-with-distinct)
* [Basic Transformation and Cleaning](#basic-transformation-and-cleaning)
* [Aggregate Functions inside a CTE](#aggregate-functions-inside-a-cte)
* [Multi-CTE Transformation with Window Functions](#multi-cte-transformation-with-window-functions)
* [CTE for Multi-Source Combine](#cte-for-multi-source-combine)
* [Work View](#work-view)

**Data Quality Test Examples**
* [Column Tests by Datatype](#column-tests-by-datatype)
* [Node-Level Tests](#node-level-tests)

**Dimension Examples**
* [Change Tracking SCD1](#change-tracking-scd1)
* [Change Tracking SCD2](#change-tracking-scd2)
* [Last Modified SCD1](#last-modified-scd1)
* [Last Modified SCD2](#last-modified-scd2)
* [Zero Key Record](#zero-key-record)
* [Dimension as a View](#dimension-as-a-view)
* [Duplicate or NULL Business Key Check](#duplicate-or-null-business-key-check)

**Fact Examples**
* [Fact Plain Insert](#fact-plain-insert)
* [Fact Change Tracking SCD1](#fact-change-tracking-scd1)
* [Fact Last Modified SCD1](#fact-last-modified-scd1)
* [Fact All Column Match](#fact-all-column-match)
* [Fact with Dimension Key Lookups](#fact-with-dimension-key-lookups)

**Table Layout**
* [Sort Key, Partition Key and Settings](#sort-key-partition-key-and-settings)

#### Work Examples

##### Sample Node with Annotations

```sql
@orderBy("intHash32(`n_Nationkey`)", "`n_Name`", "toYYYYMM(`last_Modified`)")
@primaryKey("intHash32(`n_Nationkey`)", "`n_Name`")
@partitionBy("toYYYYMM(`last_Modified`)")
@writeMode("append")
@tests("SELECT 1 FROM {{ this }} GROUP BY `n_Nationkey` HAVING count() > 1")  -- runs After the load (default), continueOnFailure=true (default)
@tests("SELECT 1 FROM {{ ref('SRC', 'Nation_Test') }} WHERE `n_Regionkey` IS NULL", true, "Before")  -- runs Before the load, continueOnFailure=true
@description("Table description")
@preSQL("DELETE FROM {{ this }} WHERE `L_M_1` < now() - INTERVAL 90 DAY")
@postSQL("INSERT INTO {{ ref('AUDIT', 'LOAD_LOG') }} (`table_name`, `load_ts`) VALUES ('WRK_NATION', now())")
SELECT
    `n_Nationkey`                      AS `n_Nationkey`    @notNull @not_null @uniqueness @min_value(0) @max_value(100) @accepted_values("1, 2, 3") @inHash("GH_COL1", 2),
    `n_Name`                           AS `n_Name`         @notNull @empty @accepted_values("'ALGERIA', 'ARGENTINA'") @inHash("GH_COL1", 1),
    `n_Regionkey`                      AS `n_Regionkey`    @min_max(0, 4) @notNull @defaultValue("20"),
    `n_Comment`                        AS `n_Comment`      @rejected_values("'NA'"),
    `last_Modified`                    AS `L_M_1`          @freshness(7, "DAY") @relative_time("<=", "L_M_2") @description("timestamp column"),
    `last_Modified`                    AS `L_M_2`,
    {{ get_hash('GH_COL1') }}          AS `GH_COL1`        @description("Hash Column")
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
```

##### Sample Node with DISTINCT

```sql
@writeMode("append")
@description("Table description")
SELECT DISTINCT
    `n_Nationkey`                      AS `n_Nationkey`,
    `n_Name`                           AS `n_Name`,
    `n_Regionkey`                      AS `n_Regionkey`,
    `last_Modified`                    AS `L_M`            @freshness(7, "DAY")
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
```

##### Basic Transformation and Cleaning

Standard pattern for renaming columns, handling nulls and cleaning values.

```sql
@orderBy("`o_orderkey`")
SELECT
    `o_orderkey`                                           AS `o_orderkey`      @notNull,
    `o_custkey`                                            AS `o_custkey`,
    upper(`o_orderstatus`)                                 AS `o_orderstatus`,
    coalesce(`o_totalprice`, 0)                            AS `o_totalprice`,
    CAST(replaceAll(toString(`o_comment`), '\0', '') AS String) AS `o_comment`,
    `o_orderdate`                                          AS `o_orderdate`
FROM {{ ref('SRC', 'orders') }} `orders`
WHERE `o_orderstatus` != 'F'
```

##### Aggregate Functions inside a CTE

```sql
WITH `order_counts` AS (
    SELECT
        `o_custkey`                  AS `o_custkey`,
        count()                      AS `order_count`,
        sum(`o_totalprice`)          AS `total_price`
    FROM {{ ref('SRC', 'orders') }}
    GROUP BY `o_custkey`
)
SELECT
    `oc`.`o_custkey`                 AS `o_custkey`,
    `oc`.`order_count`               AS `order_count`,
    `oc`.`total_price`               AS `total_price`
FROM `order_counts` `oc`
```

##### Multi-CTE Transformation with Window Functions

Complex transformations that would otherwise require multiple nodes can be written as a single SQL statement. Coalesce tracks lineage through each CTE and down to the source tables.

```sql
WITH `ordered_orders` AS (
    -- CTE 1: Rank every order for each customer by date
    SELECT
        `o_custkey`, `o_orderkey`, `o_orderdate`, `o_totalprice`, `o_orderstatus`,
        row_number() OVER (PARTITION BY `o_custkey` ORDER BY `o_orderdate` ASC, `o_orderkey` ASC) AS `order_rank`
    FROM {{ ref('SRC', 'orders') }}
),
`first_orders` AS (
    -- CTE 2: Keep only the first order for each customer
    SELECT
        `o_custkey`,
        `o_orderkey`   AS `first_order_id`,
        `o_orderdate`  AS `first_purchase_date`,
        `o_totalprice` AS `first_order_value`,
        `o_orderstatus`
    FROM `ordered_orders`
    WHERE `order_rank` = 1
)
-- Final Select: add metadata and return the results
SELECT
    `f`.`o_custkey`                  AS `o_custkey`,
    `f`.`first_order_id`             AS `first_order_id`,
    `f`.`first_purchase_date`        AS `first_purchase_date`,
    `f`.`first_order_value`          AS `first_order_value`,
    `f`.`o_orderstatus`              AS `o_orderstatus`       @notNull,
    now()                            AS `refreshed_at`,
    'Initial Customer Purchase'      AS `record_type`
FROM `first_orders` `f`
```

##### CTE for Multi-Source Combine

```sql
WITH `all_nations` AS (
    SELECT * FROM {{ ref('SRC', 'Nation_Copy1') }}
    UNION ALL
    SELECT * FROM {{ ref('SRC', 'Nation_Copy2') }}
)
SELECT * FROM `all_nations`
```

##### Work View

A view has no load and ignores the key and write annotations; the column comments and the view comment are part of its `CREATE OR REPLACE VIEW`.

```sql
@materializationType("view")
@description("Monthly net sales by customer region and market segment")
SELECT
    `dc`.`region_name`                AS `region_name`,
    `dc`.`c_mktsegment`               AS `c_mktsegment`,
    toStartOfMonth(`f`.`o_orderdate`) AS `order_month`,
    count()                           AS `line_count`,
    sum(`f`.`net_amount`)             AS `net_sales`
FROM {{ ref('TARGET', 'FCT_ORDER_LINE') }} `f`
INNER JOIN {{ ref('TARGET', 'DIM_CUSTOMER') }} `dc` ON `dc`.`customer_key` = `f`.`customer_key`
GROUP BY `dc`.`region_name`, `dc`.`c_mktsegment`, toStartOfMonth(`f`.`o_orderdate`)
```

#### Data Quality Test Examples

##### Column Tests by Datatype

Each column test runs **After** the load, continues the run on failure, and lets NULL values pass (except `@not_null`). Values are pasted into the SQL as written, so quote them to match the column's datatype.

```sql
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
FROM {{ ref('SRC', 'customer') }}
```
* **Number** — `@min_value("1")`, a negative bound in double quotes `"-1000"`, a decimal `"0.5"`.
* **String** — single quotes inside double quotes; `@accepted_values` can repeat and the lists are merged.
* **Bool** — `true`/`false`. **Date/time** — a literal or ClickHouse expression, e.g. `"toDate('2000-01-01')"`, `"today()"`, `"now()"`.
* `@relative_time` compares two columns of the same datatype.
* The same annotations work on a Dimension or Fact node — add an `@id("<value>")` to each column there.

##### Node-Level Tests

A node-level test fails when its query returns any rows. `Before` tests usually read the source; `After` tests read the loaded target through `{{ this }}`.

```sql
@tests("SELECT `customer_id` FROM {{ ref('SRC', 'customer') }} GROUP BY `customer_id` HAVING count() > 1", false, "Before")  -- runs Before the load, continueOnFailure=false
@tests("SELECT 1 FROM {{ ref('SRC', 'customer') }} HAVING count() = 0", true, "Before")  -- runs Before the load, continueOnFailure=true
@tests("SELECT 1 FROM {{ this }} WHERE `balance` < 0 AND `status` = 'ACTIVE'")  -- runs After the load (default), continueOnFailure=true (default)
@tests("SELECT 1 FROM {{ this }} HAVING count() <> (SELECT count() FROM {{ ref('SRC', 'customer') }})", true, "After")  -- runs After the load, continueOnFailure=true
SELECT
    `customer_id`      AS `customer_id`,
    `balance`          AS `balance`,
    `status`           AS `status`
FROM {{ ref('SRC', 'customer') }}
```
* Line 1 — duplicate keys in the source, before the load. Line 2 — an empty source. Line 3 — a business rule on the loaded rows (`After` by default). Line 4 — the target row count matches the source.
* `continueOnFailure` is the second argument.
* `@disableTests` on the node skips every node-level and column-level test.

#### Dimension Examples

##### Change Tracking SCD1

The default strategy. Any change in a non-key column overwrites the row.

```sql
@orderBy("`c_custkey`")
SELECT
    generateUUIDv4()                         AS `customer_key`       @id("a10000") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `c_custkey`                              AS `c_custkey`          @id("a10001") @isBusinessKey @notNull,
    `c_name`                                 AS `c_name`             @id("a10002"),
    `c_address`                              AS `c_address`          @id("a10003"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE` @id("a10008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE` @id("a10009") @isSystemUpdateDate
FROM {{ ref('SRC', 'customer') }} `customer`
```

##### Change Tracking SCD2

A change in a column marked `@isChangeTracking` keeps the old row and adds a new version. Other columns are updated in place on the current version.

```sql
@mergeStrategy("changeTracking")
@orderBy("`c_custkey`", "`SYSTEM_VERSION`")
SELECT
    generateUUIDv4()                                     AS `customer_key`        @id("b10000") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `c_custkey`                                          AS `c_custkey`           @id("b10001") @isBusinessKey @notNull,
    `c_name`                                             AS `c_name`              @id("b10002"),
    `c_address`                                          AS `c_address`           @id("b10003") @isChangeTracking,
    1                                                    AS `SYSTEM_VERSION`      @id("b10005") @isSystemVersion,
    'Y'                                                  AS `SYSTEM_CURRENT_FLAG` @id("b10006") @isSystemCurrentFlag,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6))  AS `SYSTEM_END_DATE`     @id("b10007") @isSystemEndDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                 AS `SYSTEM_CREATE_DATE`  @id("b10008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                 AS `SYSTEM_UPDATE_DATE`  @id("b10009") @isSystemUpdateDate
FROM {{ ref('SRC', 'customer') }} `customer`
```

* Put `SYSTEM_VERSION` in `@orderBy` after the business key: each version is its own row, and the sort key then matches how the clean-up groups rows.

##### Last Modified SCD1

A row is overwritten only when its `@lastModifiedTracking` value is newer than the stored one.

```sql
@mergeStrategy("lastModified")
@orderBy("`c_custkey`")
SELECT
    generateUUIDv4()                         AS `customer_key`       @id("c10000") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `c_custkey`                              AS `c_custkey`          @id("c10001") @isBusinessKey @notNull,
    `c_name`                                 AS `c_name`             @id("c10002"),
    `updated_at`                             AS `updated_at`         @id("c10003") @lastModifiedTracking(1),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE` @id("c10008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE` @id("c10009") @isSystemUpdateDate
FROM {{ ref('SRC', 'customer') }} `customer`
```

##### Last Modified SCD2

Same as above, but a newer value keeps the old row and adds a new version.

```sql
@mergeStrategy("lastModified")
@orderBy("`n_Nationkey`", "`SYSTEM_VERSION`")
SELECT
    generateUUIDv4()                                     AS `DIM_Nation_Test_KEY` @id("f8e055") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `n_Nationkey`                                        AS `n_Nationkey`         @id("4fdd08") @isBusinessKey,
    `n_Name`                                             AS `n_Name`              @id("1dcbf7"),
    `n_Regionkey`                                        AS `n_Regionkey`         @id("5db1aa"),
    `last_Modified`                                      AS `last_Modified`       @id("15ef53") @lastModifiedTracking(2),
    1                                                    AS `SYSTEM_VERSION`      @id("cdab35") @isSystemVersion,
    'Y'                                                  AS `SYSTEM_CURRENT_FLAG` @id("e5e916") @isSystemCurrentFlag,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                 AS `SYSTEM_CREATE_DATE`  @id("2538b2") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)                 AS `SYSTEM_UPDATE_DATE`  @id("6b90e8") @isSystemUpdateDate,
    CAST('2299-12-31 23:59:59.999999' AS DateTime64(6))  AS `SYSTEM_END_DATE`     @id("d9a32f") @isSystemEndDate
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
```

##### Zero Key Record

Adds a placeholder row for unmatched lookups. Needs a surrogate key column.

```sql
@zeroKey("00000000-0000-0000-0000-000000000000", "'UNKNOWN'", "1900-01-01 00:00:00", true)
@orderBy("`c_custkey`")
SELECT
    generateUUIDv4()                         AS `customer_key`       @id("f10000") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `c_custkey`                              AS `c_custkey`          @id("f10001") @isBusinessKey,
    `c_name`                                 AS `c_name`             @id("f10002") @zeroKey("'N/A'"),
    `c_mktsegment`                           AS `c_mktsegment`       @id("f10003"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE` @id("f10008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE` @id("f10009") @isSystemUpdateDate
FROM {{ ref('SRC', 'customer') }} `customer`
```

* The zero record gets the nil UUID as its key, `0` for `c_custkey` (numeric), `'N/A'` for `c_name` (column override) and `'UNKNOWN'` for `c_mktsegment`.

##### Dimension as a View

No business key or system columns needed; nothing is loaded.

```sql
@materializationType("view")
SELECT
    `c_custkey`                              AS `c_custkey`          @id("0a0001"),
    `c_name`                                 AS `c_name`             @id("0a0002")
FROM {{ ref('SRC', 'customer') }} `customer`
```

##### Duplicate or NULL Business Key Check

Every merge strategy matches rows on the business key, so the source must return exactly one row per key, with no NULL key — on ClickHouse a duplicate is loaded twice instead of failing. A `Before` test runs ahead of the load and fails if the source returns a duplicated or NULL key.

```sql
@mergeStrategy("changeTracking")
@tests("SELECT `n_Nationkey`, `n_Name` FROM {{ ref('SRC', 'Nation_Test') }} GROUP BY `n_Nationkey`, `n_Name` HAVING count() > 1 OR `n_Nationkey` IS NULL OR `n_Name` IS NULL", false, "Before")  -- runs Before the load, continueOnFailure=false
SELECT
    generateUUIDv4()                         AS `DIM_NATION_KEY`     @id("a1b2c3") @isSurrogateKey @notNull @defaultValue("generateUUIDv4()"),
    `n_Nationkey`                            AS `n_Nationkey`        @id("b2c3d4") @isBusinessKey,
    `n_Name`                                 AS `n_Name`             @id("c3d4e5") @isBusinessKey,
    `n_Regionkey`                            AS `n_Regionkey`        @id("d4e5f6"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE` @id("e5f6a7") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE` @id("f6a7b8") @isSystemUpdateDate
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
```
* The test query must read the same source, CTE and filters as the node's SELECT, so it checks the rows that are actually loaded. List every `@isBusinessKey` column in the `GROUP BY` and the `IS NULL` checks.
* Or de-duplicate in the SELECT itself with `QUALIFY` or `LIMIT 1 BY` — see [Unique Business Keys](#unique-business-keys-fact-and-dimension).

#### Fact Examples

##### Fact Plain Insert

No `@mergeStrategy` and no `@isBusinessKey` column, so every source row is inserted with no matching. System columns are optional and written as the SELECT computes them. Adding `@mergeStrategy("changeTracking")` or `"lastModified"` here without a business key would stop the load with a validation error.

```sql
@orderBy("`o_orderkey`")
SELECT
    `o_orderkey`                             AS `o_orderkey`         @id("1a0001"),
    `o_custkey`                              AS `o_custkey`          @id("1a0002"),
    `o_totalprice`                           AS `o_totalprice`       @id("1a0003"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE` @id("1a0008") @isSystemCreateDate
FROM {{ ref('SRC', 'orders') }} `orders`
```

##### Fact Change Tracking SCD1

The default strategy. Any change in a non-key column replaces the row; new keys are inserted.

```sql
@orderBy("`o_orderkey`")
SELECT
    `o_orderkey`                             AS `o_orderkey`         @id("1b0001") @isBusinessKey @notNull,
    `o_orderstatus`                          AS `o_orderstatus`      @id("1b0002"),
    `o_totalprice`                           AS `o_totalprice`       @id("1b0003"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE` @id("1b0008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE` @id("1b0009") @isSystemUpdateDate
FROM {{ ref('SRC', 'orders') }} `orders`
```

##### Fact Last Modified SCD1

A row is replaced only when its `@lastModifiedTracking` value is newer than the stored one.

```sql
@mergeStrategy("lastModified")
@orderBy("`o_orderkey`")
SELECT
    `o_orderkey`                             AS `o_orderkey`         @id("1c0001") @isBusinessKey @notNull,
    `o_orderstatus`                          AS `o_orderstatus`      @id("1c0002"),
    `updated_at`                             AS `updated_at`         @id("1c0003") @lastModifiedTracking,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE` @id("1c0008") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_UPDATE_DATE` @id("1c0009") @isSystemUpdateDate
FROM {{ ref('SRC', 'orders') }} `orders`
```

##### Fact All Column Match

Every non-system column is compared; a row is inserted only if an identical row doesn't already exist. Nothing is ever updated or deleted, and no `@isBusinessKey` is needed.

`allColumnMatch` is how you build a **factless fact table** — a table with no measures, where the existence of a row is the fact itself. Typical uses:

* **Event tracking** — records that something happened, e.g. a student attended a class or a customer visited a page on a date.
* **Coverage / relationship tracking** — records which combinations are valid or in effect, e.g. which parts each supplier supplies, so you can also find what *didn't* happen.

```sql
@mergeStrategy("allColumnMatch")
@orderBy("`ps_partkey`", "`ps_suppkey`")
SELECT
    `ps_partkey`                             AS `ps_partkey`         @id("1e0001") @notNull,
    `ps_suppkey`                             AS `ps_suppkey`         @id("1e0002") @notNull,
    `ps_availqty`                            AS `ps_availqty`        @id("1e0003"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP)     AS `SYSTEM_CREATE_DATE` @id("1e0008") @isSystemCreateDate
FROM {{ ref('SRC', 'partsupp') }} `partsupp`
```
* `SYSTEM_CREATE_DATE` is left out of the comparison, so re-running the load doesn't insert the same row again.
* Matching uses plain equality — a row with a NULL in any compared column never matches and is inserted on every run.
* Two identical source rows that aren't in the target yet are both inserted — add `DISTINCT` to the SELECT if that's not wanted.

##### Fact with Dimension Key Lookups

A fact that looks up each dimension's surrogate key, pointing unmatched members at the zero key record, partitioned by month.

```sql
@description("Order line fact with customer and part keys; unmatched members point at the zero-key record")
@orderBy("`l_orderkey`", "`l_linenumber`")
@partitionBy("toYYYYMM(`o_orderdate`)")
SELECT
    `ol`.`l_orderkey`        AS `l_orderkey`         @id("fo0001") @isBusinessKey @notNull,
    `ol`.`l_linenumber`      AS `l_linenumber`       @id("fo0002") @isBusinessKey @notNull,
    coalesce(`dc`.`customer_key`, toUUID('00000000-0000-0000-0000-000000000000')) AS `customer_key` @id("fo0003") @notNull,
    coalesce(`dp`.`part_key`, toUUID('00000000-0000-0000-0000-000000000000'))     AS `part_key`     @id("fo0004") @notNull,
    `ol`.`o_orderdate`       AS `o_orderdate`        @id("fo0006") @notNull,
    `ol`.`net_amount`        AS `net_amount`         @id("fo0011"),
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_CREATE_DATE` @id("fo0013") @isSystemCreateDate,
    CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS `SYSTEM_UPDATE_DATE` @id("fo0014") @isSystemUpdateDate
FROM {{ ref('TARGET', 'WRK_ORDER_LINE') }} `ol`
LEFT JOIN {{ ref('TARGET', 'DIM_CUSTOMER') }} `dc` ON `dc`.`c_custkey` = `ol`.`o_custkey` AND `dc`.`SYSTEM_CURRENT_FLAG` = 'Y'
LEFT JOIN {{ ref('TARGET', 'DIM_PART') }} `dp` ON `dp`.`p_partkey` = `ol`.`l_partkey`
```

* On ClickHouse an unmatched `LEFT JOIN` column is the type's default (e.g. the nil UUID) unless `join_use_nulls = 1` is set; the `coalesce()` gives the same result either way.

#### Sort Key, Partition Key and Settings

```sql
@orderBy("`n_Nationkey`", "`n_Name`")
@primaryKey("`n_Nationkey`")
@partitionBy("toYYYYMM(`last_Modified`)")
@settings("index_granularity = 8192")
@description("Nation work table")
SELECT
    `n_Nationkey`    AS `n_Nationkey`    @notNull,
    `n_Name`         AS `n_Name`         @description("Nation name"),
    `last_Modified`  AS `last_Modified`
FROM {{ ref('SRC', 'Nation_Test') }} `Nation_Test`
```

On the first deployment this creates (`<DB>` is the database the node's storage location is mapped to; the column types are the ones Coalesce infers):

```sql
CREATE OR REPLACE TABLE `<DB>`.`WRK_NATION`
(
    `n_Nationkey` Int32,
    `n_Name` Nullable(String) COMMENT 'Nation name',
    `last_Modified` Nullable(DateTime)
)
PARTITION BY toYYYYMM(`last_Modified`)
ORDER BY (`n_Nationkey`, `n_Name`)
PRIMARY KEY (`n_Nationkey`)
SETTINGS allow_nullable_key = 1, index_granularity = 8192
COMMENT 'Nation work table'
```

* No `ENGINE` is written; ClickHouse Cloud creates a `SharedMergeTree` table.
* `allow_nullable_key = 1` is added because the table has sort and partition keys, which here use `Nullable` columns (`n_Name`, `last_Modified`).
* On a later deployment, adding a new column at the end of `@orderBy` or removing `` `n_Name` `` from it is altered in place; changing `@primaryKey` or `@partitionBy` recreates the table empty — see [Sort Key and Partition Key Changes](#sort-key-and-partition-key-changes).

---

### Code

#### Work

* [Node definition](https://github.com/coalesceio/clickhouse-node-types-sql/blob/main/nodeTypes/Work-SQLWork/definition.yml)
* [Create Template](https://github.com/coalesceio/clickhouse-node-types-sql/blob/main/nodeTypes/Work-SQLWork/create.sql.j2)
* [Run Template](https://github.com/coalesceio/clickhouse-node-types-sql/blob/main/nodeTypes/Work-SQLWork/run.sql.j2)

#### Dimension

* [Node definition](https://github.com/coalesceio/clickhouse-node-types-sql/blob/main/nodeTypes/Dimension-SQLDimension/definition.yml)
* [Create Template](https://github.com/coalesceio/clickhouse-node-types-sql/blob/main/nodeTypes/Dimension-SQLDimension/create.sql.j2)
* [Run Template](https://github.com/coalesceio/clickhouse-node-types-sql/blob/main/nodeTypes/Dimension-SQLDimension/run.sql.j2)

#### Fact

* [Node definition](https://github.com/coalesceio/clickhouse-node-types-sql/blob/main/nodeTypes/Fact-SQLFact/definition.yml)
* [Create Template](https://github.com/coalesceio/clickhouse-node-types-sql/blob/main/nodeTypes/Fact-SQLFact/create.sql.j2)
* [Run Template](https://github.com/coalesceio/clickhouse-node-types-sql/blob/main/nodeTypes/Fact-SQLFact/run.sql.j2)

#### Macro

* [Macro](https://github.com/coalesceio/clickhouse-node-types-sql/blob/main/macros/macro-1.yml)

----
