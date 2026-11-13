# SQL-First NodeTypes for ClickHouse

The [SQL-first nodes](https://docs.coalesce.io/docs/build-your-pipeline/v2-node-types) is a transformation tool within Coalesce that lets developers write custom, hand-coded SQL instead of using the standard graphical column-mapping interface. It is ideal for complex transformations, advanced window functions, or multi-step logic that is difficult to represent with the standard UI, and ships with a built-in library of column- and node-level data quality tests. While it provides maximum flexibility, it shifts the responsibility of column definition and logic maintenance to the SQL author.

# Coalesce Base Node Types - SQL Package (ClickHouse)

The Coalesce Base Node Types - SQL Package for ClickHouse includes:

* [Work](#work)
* [Dimension](#dimension)
* [Fact](#fact)

Concepts shared across every node type — ClickHouse table defaults, sort and partition keys, column types, data quality tests, known limitations, and usage examples — are documented once in [Common Reference](#common-reference) and linked to from each node type below.

> **After installing:** read [Before You Start](#before-you-start) — set the package `engine` parameter and the `readWithFinal` and `joinUseNulls` runtime parameters before the first deployment.

## Before You Start

Three decisions to make after installing the package and **before the first deployment**. The first one is hard to change later.

### 1. Package parameter `engine` — choose the table engine

Sets the `ENGINE` of every Dimension and Fact table that has no [`@engine`](#engine) of its own (Work tables are always MergeTree). Set it in the package's parameters:

```
{%- set packageParameter = namespace(engine = "ReplacingMergeTree") -%}
```

Use `"MergeTree"` (or `""` for the default) in place of `"ReplacingMergeTree"`.

| `engine` | Use it when | What it means |
|---|---|---|
| not set / `"MergeTree"` (default) | You want every table to be correct to a plain `SELECT` | Each load inserts, then deletes the replaced copies (**Clean Up Previous Data**). Slower loads; no `FINAL` needed anywhere. |
| `"ReplacingMergeTree"` | Large tables where load speed matters | Each load only inserts; ClickHouse removes the replaced copies at a background merge. Readers need `FINAL` — steps 2 and 3. |

* Both engines give the same result: a MergeTree holds what a ReplacingMergeTree returns with `FINAL` — see [How a Load Replaces Rows](#how-a-load-replaces-rows-dimension-and-fact).
* ⚠️ **Decide before the first deployment.** Changing the parameter later does not recreate tables already deployed — see [Changing the Package `engine` Parameter](#known-limitations). A single node can always use `@engine` instead.
* Details: [Package Parameters](#package-parameters).

### 2. Runtime parameter `readWithFinal` — set it in every environment

**Required when any table is a ReplacingMergeTree** (from the package parameter or `@engine`). Set it in each environment's parameters (**Environment → Parameters**), or on a job run:

```json
{
  "readWithFinal": true
}
```

When the environment already has parameters, add `"readWithFinal": true` to the same JSON object.

* With `true`, the package's own SQL reads every ReplacingMergeTree with `FINAL`: the loads (their sources **and the node's own target** — e.g. the current SCD Type 2 rows used for change detection), the zero key record, the column-level tests, and views without [`@final`](#final).
* Without it (or `false`), those reads see the copies a ReplacingMergeTree has not merged yet. Writing `FINAL` in the node's SQL is **not enough**: it covers only the tables it follows, not the node's own target, which the load reads in its own CTEs. Results can then contain duplicates, and an SCD Type 2 Dimension can end up with two current versions of a key.
* With only MergeTree tables it makes no difference.
* Details: [Runtime Parameters](#runtime-parameters).

### 3. Runtime parameter `joinUseNulls` — set it once, the same in every environment

**Recommended whenever nodes use `LEFT JOIN`.** Controls what a column from a `LEFT JOIN` holds when no row matches, so every environment loads the same data:

```json
{
  "readWithFinal": true,
  "joinUseNulls": true
}
```

* `true` (recommended): no match gives `NULL`, as in standard SQL, and `coalesce(<col>, <default>)` works as expected.
* `false` or not set: the package adds nothing, and the `join_use_nulls` configured in ClickHouse (server, settings profile, user or session) applies. ClickHouse's default gives the type's default value (`''`, `0`, nil UUID).
* ⚠️ **Choose once, before the first load**, and use the same value in every environment — see [Changing `joinUseNulls`](#known-limitations).
* Details: [Runtime Parameters](#runtime-parameters).

### 4. ClickHouse `final = 1` for the people and tools that read the tables

**Recommended when any table is a ReplacingMergeTree.** `readWithFinal` only covers the package's own SQL. Everyone else who queries the tables — BI tools, analysts, exports — sees the unmerged copies unless they read with `FINAL`. Set it once on their ClickHouse user or settings profile:

```sql
ALTER USER <user> SETTINGS final = 1;
-- or for every user on a profile:
ALTER SETTINGS PROFILE <profile> SETTINGS final = 1;
```

Other ways to get clean output (views with `@final`, `@optimize`, MergeTree) are listed in [Querying a ReplacingMergeTree](#querying-a-replacingmergetree).

### Checklist

| | MergeTree only | Any ReplacingMergeTree |
|---|---|---|
| Package `engine` set before the first deployment | ✅ (or leave unset) | ✅ `"ReplacingMergeTree"` (or `@engine` per node) |
| `{ "readWithFinal": true }` in every environment | optional | **required** |
| `joinUseNulls` set, the same in every environment | recommended | recommended |
| `final = 1` on the readers' ClickHouse users / profiles | not needed | recommended |

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
| `@engine` | ➖ | ✅ | ✅ |
| `@final` | view only | view only | view only |
| `@optimize` | ➖ | table only | table only |
| `@writeMode` | ✅ | ✅ | ✅ |
| `@mergeStrategy` | ➖ | ✅<br/>* changeTracking<br/>* lastModified | ✅<br/>* changeTracking<br/>* lastModified<br/>* allColumnMatch |
| `@zeroKey` (node-level) | ➖ | ✅ | ➖ |
| `@disableTests` | ✅ | ✅ | ✅ |
| `@tests` | ✅ | ✅ | ✅ |
| `@preSQL` | ✅ | ✅ | ✅ |
| `@postSQL` | ✅ | ✅ | ✅ |
| Target Load | (TRUNCATE) INSERT | (TRUNCATE) INSERT + clean-up DELETE (MergeTree, the default), or INSERT only into a ReplacingMergeTree | (TRUNCATE) INSERT + clean-up DELETE (MergeTree, the default), or INSERT only into a ReplacingMergeTree |

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
| [`@final`](#final) | Views only: the view reads its sources with `FINAL` (`SETTINGS final = 1`). |
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
| **Load table - Insert** | `INSERT INTO … SELECT` with the node's CTEs, `DISTINCT` and joins. |
| **Post-SQL `<n>`** | Each `@postSQL` statement, in the order they appear. |
| **`<column>: <test>` \| Post Load Test `<n>`** | Column-level data quality tests and node-level `@tests(..., "After")` tests, run after the load. |

A Work view has no load: the run shows **Load Skipped for View**, and the tests still run.

---

## Dimension

The Dimension node is a specialized transformation node within Coalesce, used to materialize dimension tables that track descriptive attributes over time. It loads incoming source data into the target using a configurable change-detection strategy — column-based change tracking or a last-modified timestamp — and, depending on that strategy and the columns marked on the node, produces either an SCD Type 1 (overwrite-in-place) or SCD Type 2 (versioned history) dimension, complete with a built-in library of column- and node-level data quality tests.

ClickHouse has no `MERGE`, so a Dimension load only inserts the rows a merge would apply; the older copies are then deleted (MergeTree, the default) or replaced by a `ReplacingMergeTree` — see [How a Load Replaces Rows](#how-a-load-replaces-rows-dimension-and-fact).

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
| [`@final`](#final) | Views only: the view reads its sources with `FINAL` (`SETTINGS final = 1`). |
| [`@optimize`](#optimize) | Tables only: runs `OPTIMIZE TABLE … FINAL` after the load, before Post-SQL. |
| [`@engine(engine)`](#engine) | The table's `ENGINE`.<br/>*Not specified in the SQL editor → the package's `engine` parameter, else **MergeTree** (no `ENGINE` written).* |
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
* Every strategy matches on the business key. A key the SELECT/CTE returns more than once is loaded once (`lastModified`: the newest row), and a NULL business key is one key value — see [Unique Business Keys](#unique-business-keys-fact-and-dimension).
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
| `Point`, `Geometry` | The point `(0, 0)` |
| `Ring`, `LineString`, `MultiLineString`, `Polygon`, `MultiPolygon` | An empty shape `[]` |
| Anything else | `NULL` |
| System columns | Version `1`, current flag `'Y'`, end date the [open end date](#scd-type-2-end-date), create date `1970-01-01 00:00:00` (the zero-record marker), update date the load time |

* Override any column with a column-level `@zeroKey(value)`.
* The zero record is written by its own stage, **Load table - Zero Key Record**, on every run, independent of the main data load. It looks up the zero record by the current surrogate value: when there is none (first run, after a `truncateInsert`, or a new surrogate value) it inserts one; when its stored values differ from the `@zeroKey` values it inserts a refreshed copy (the previous copy is removed by the clean-up on MergeTree, or replaced on a ReplacingMergeTree); otherwise it writes nothing.
* **Every zero record gets `SYSTEM_CREATE_DATE` = 1970-01-01 00:00:00 UTC** (epoch 0, in the column's type). Real rows are stamped with the load time, so this marks a row as a zero record for good: the main load leaves every such row out of change detection.
* **⚠️ The zero record's business key must be unique.** Its business key values must differ from every business key in the data: numeric key columns get `0` and string ones `'UNKNOWN'` by default, so if the data can contain that value (e.g. a nation with key `0`), override it on the business key column with a column-level `@zeroKey`, e.g. `@zeroKey("-1")` or `@zeroKey("'N/A'")`. Pick a value the column's type can hold: on an unsigned column (`UInt8` … `UInt64`) ClickHouse wraps `-1` to the type's largest value (`UInt32`: `4294967295`) without an error — it is still unique, but write that value (or another unused one) explicitly so it reads clearly. The table key is the business key + `SYSTEM_VERSION` (the zero record is version 1, like a real row; the MergeTree clean-up uses the same key), so a zero record that shares a real row's business key is the same key: a ReplacingMergeTree keeps only one of the two (the other is hidden by `FINAL` and removed at a merge), and the MergeTree clean-up deletes one. The load itself never matches the zero record to a source row (see its `SYSTEM_CREATE_DATE` below), but it cannot stop the engine from treating the two as one key.
* **Changing the surrogate value** (e.g. `…000` → `…001`) inserts the new zero record, which **replaces** the earlier one — same business key and version — on both engines (ReplacingMergeTree at a merge / with `FINAL`, MergeTree in the clean-up). Facts that still point at the old surrogate value no longer find it. **Removing `@zeroKey`** leaves the stored zero record in place, still left out of the load; delete it yourself if it is not wanted.
* The zero record is left out of change detection, so the load never updates it from a source row. A real source row with the same business key is still the same table key, though — keep the zero business key unique (see above).
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
* **Note:** Ignored unless `@zeroKey` is enabled at the node level — without it a non-failing **Warning: Column @zeroKey without node-level @zeroKey** stage lists the columns at deploy and on every run. Ignored on Views.

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
* **Requires `@notNull`**, because every row must have a key. Without it the column is `Nullable` and the **Missing Required System Columns** check stops the deploy and the run.
* New rows and new SCD Type 2 versions get their key from `@defaultValue`; rows the load re-inserts (an expired version, an in-place update) keep the key they already have. See [Surrogate Keys](#surrogate-keys-dimension).
* **Note:** Ignored on Views. Agentic creation only — manual creation adds this column automatically.
* Expected expression: `generateUUIDv4() AS "<NODE_NAME>_KEY" @isSurrogateKey @notNull @defaultValue("generateUUIDv4()")` — type the node name yourself, e.g. `generateUUIDv4() AS "DIM_CUSTOMER_KEY" @isSurrogateKey @notNull @defaultValue("generateUUIDv4()")`.

##### `@isSystemVersion` (Dimension)

`@isSystemVersion`

Marks this column as the SCD version number, incremented each time a business key gets a new version.

* Required for SCD Type 2 — shows which version of a row this is; each time a business key's row changes, the expired row is kept and a new row is inserted with this value incremented by 1.
* Optional for SCD Type 1 — new-vs-existing is detected off the business key alone, so this column can be dropped entirely; if kept, it is always written as 1 and never incremented. This holds on a ReplacingMergeTree too — see [`SYSTEM_VERSION` on a ReplacingMergeTree](#system_version-on-a-replacingmergetree-dimension).
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
| **Duplicate Column Names \| Duplicate Column IDs \| Missing Column IDs \| Missing Business Key \| Invalid configuration: … \| Warning: mergeStrategy \| Missing Required System Columns \| Missing Recommended System Columns \| Surrogate Key Not Set/Using Custom Surrogate Key Logic \| Warning: Zero Key Value Too Long \| Warning: Column @zeroKey without node-level @zeroKey** | Dimension validation checks (table only), rendered only when the annotations have a problem — see [Dimension Load](#dimension-load). A required problem stops the deployment with `Validation failed: <stage>`; a recommendation or warning does not. |

When deployed for the first time into an Environment, the Dimension Node executes one of these stages, depending on its materialization type:

| **Stage** | **Description** |
|-----------|----------------|
| **Create table** | Executes a `CREATE OR REPLACE TABLE` statement with the column types (the surrogate key never `Nullable`), defaults and comments, `ENGINE`, `PARTITION BY`, `ORDER BY`, `PRIMARY KEY`, `SETTINGS` and the table comment |
| **Note: Query with FINAL** | On a ReplacingMergeTree, after **Create table** / **Recreate Table** — a passing stage reminding whoever deploys that readers need `FINAL`. See [Querying a ReplacingMergeTree](#querying-a-replacingmergetree). |
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
| **Duplicate Column Names \| Duplicate Column IDs \| Missing Column IDs \| Missing Business Key \| Invalid configuration: … \| Warning: mergeStrategy \| Missing Required System Columns \| Missing Recommended System Columns \| Surrogate Key Not Set/Using Custom Surrogate Key Logic \| Warning: Zero Key Value Too Long \| Warning: Column @zeroKey without node-level @zeroKey** | Validation checks — rendered only when the node's annotations have a problem (the SELECT returns the same column name twice, two columns share an `@id` value, a column without `@id`, no `@isBusinessKey`, an unrecognised `@mergeStrategy`, a missing or repeated `@lastModifiedTracking` column, a `@lastModifiedTracking` column that cannot detect newer rows, an `scdType` other than 1 or 2, a tracking annotation the strategy ignores (non-failing), a missing system column, a missing `@defaultValue` on the surrogate key, a surrogate key that is only recommended (non-failing), an `@engine` that is not a MergeTree-family engine, `@orderBy` / `@primaryKey` on a ReplacingMergeTree, a ReplacingMergeTree without a business key, `SYSTEM_VERSION` (Dimension) or `@isSystemUpdateDate` column, or a zero key string longer than its `FixedString` column (non-failing)). |
| **Check Last Modified Column - NULL Values (`<column>`)** | Pre-load check for `@mergeStrategy("lastModified")` — fails the run on a NULL `@lastModifiedTracking` value in the source. |
| **Pre-SQL `<n>`** | Each `@preSQL` statement, in the order they appear. |
| **Truncate table** | Executed only when `@writeMode("truncateInsert")` is set — clears the target before the load. |
| **Load table - Zero Key Record** | Executed only when node-level `@zeroKey` is set and a surrogate key column exists — inserts the placeholder "zero key" row when it is missing or its values differ from `@zeroKey`; otherwise it inserts nothing. |
| **Load table - Last Modified Comparison - SCD1 \| SCD2** | Executed for `@mergeStrategy("lastModified")` — compares the `@lastModifiedTracking` column against the current target row, then inserts new keys and the changed rows (SCD1: the new values; SCD2: the new version plus the expired old version). |
| **Load table - Change Tracking - SCD1 \| SCD2** | Executed for `@mergeStrategy("changeTracking")` (the default) — compares `@isChangeTracking` columns (or, absent any, every plain attribute column) against the current target row, then inserts new keys and the changed rows. Under SCD2, a change only in a plain attribute column re-inserts the current version with the new values. |
| **Clean Up Previous Data** | Deletes the copies the insert replaced — see [How a Load Replaces Rows](#how-a-load-replaces-rows-dimension-and-fact). Runs only when the table is not a ReplacingMergeTree (e.g. the default MergeTree) and the node has `@isBusinessKey` and `@isSystemUpdateDate` columns. |
| **Optimize Table** | Executed only when [`@optimize`](#optimize) is set — `OPTIMIZE TABLE … FINAL` merges the table's parts after the load, before Post-SQL. |
| **Post-SQL `<n>`** | Each `@postSQL` statement, in the order they appear. |
| **`<column>: <test>` \| Post Load Test `<n>`** | Column-level data quality tests and node-level `@tests(..., "After")` tests, run after the load. |

> **Note:** ClickHouse has no `MERGE` statement; the load stages only insert the new and changed rows, and **Clean Up Previous Data** (MergeTree) or the ReplacingMergeTree removes the older copies — see [How a Load Replaces Rows](#how-a-load-replaces-rows-dimension-and-fact).

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
| [`@final`](#final) | Views only: the view reads its sources with `FINAL` (`SETTINGS final = 1`). |
| [`@optimize`](#optimize) | Tables only: runs `OPTIMIZE TABLE … FINAL` after the load, before Post-SQL. |
| [`@engine(engine)`](#engine) | The table's `ENGINE`.<br/>*Not specified in the SQL editor → the package's `engine` parameter, else **MergeTree** (no `ENGINE` written).* |
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
| `allColumnMatch` | A factless fact: a source row is inserted only if no target row matches it on the **match columns** — the non-system columns that come from the source — and an existing row is never updated or deleted. `@isBusinessKey` isn't needed — if present, a warning is raised and it's ignored. `@lastModifiedTracking` isn't used either — a warning is raised and it's ignored. System columns are optional, are left out of the comparison, and are written exactly as the SELECT/CTE computes them. |

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
* Ignored under `@mergeStrategy("allColumnMatch")`, which matches on the non-system columns that come from the source (a warning is raised).
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
| any (ignored, warning if marked) | `allColumnMatch` | Insert rows that don't match on the non-system columns that come from the source |

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
* Keys are matched NULL-safely (`isNotDistinctFrom`) under every strategy: a NULL business key is one key value, matched and updated like any other — see [NULL Business Keys](#known-limitations).

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
| **Create table** | Executes a `CREATE OR REPLACE TABLE` statement with the column types, defaults and comments, `ENGINE`, `PARTITION BY`, `ORDER BY`, `PRIMARY KEY`, `SETTINGS` and the table comment |
| **Note: Query with FINAL** | On a ReplacingMergeTree, after **Create table** / **Recreate Table** — a passing stage reminding whoever deploys that readers need `FINAL`. See [Querying a ReplacingMergeTree](#querying-a-replacingmergetree). |
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
| **Duplicate Column Names \| Duplicate Column IDs \| Missing Column IDs \| Invalid configuration: … \| Warning: mergeStrategy \| Warning: No Business Key \| Missing Required System Columns** | Validation checks — rendered only when the node's annotations have a problem (the SELECT returns the same column name twice, two columns share an `@id` value, a column without `@id`, an unrecognised `@mergeStrategy`, an explicit strategy without a business key, a missing or repeated `@lastModifiedTracking` column, a `@lastModifiedTracking` column that cannot detect newer rows, a tracking/key annotation the strategy ignores (non-failing), an `@engine` that is not a MergeTree-family engine, `@orderBy` / `@primaryKey` on a ReplacingMergeTree, a ReplacingMergeTree without a business key, `SYSTEM_VERSION` (Dimension) or `@isSystemUpdateDate` column, or a missing system column). |
| **Check Last Modified Column - NULL Values (`<column>`)** | Pre-load check for `@mergeStrategy("lastModified")` — fails the run on a NULL `@lastModifiedTracking` value in the source. |
| **Pre-SQL `<n>`** | Each `@preSQL` statement, in the order they appear. |
| **Truncate table** | Executed only when `@writeMode("truncateInsert")` is set — clears the target before the load. |
| **Load table - Insert** | Executed when no `@mergeStrategy` is set and no column is marked `@isBusinessKey` — inserts every source row with `INSERT INTO … SELECT`. |
| **Load table - Change Tracking - SCD1** | Executed for `@mergeStrategy("changeTracking")`, and by default when no `@mergeStrategy` is set and a column is marked `@isBusinessKey` — compares every plain attribute column against the target, then inserts new keys and changed rows. |
| **Load table - Last Modified Comparison - SCD1** | Executed for `@mergeStrategy("lastModified")` — compares the `@lastModifiedTracking` column against the target, then inserts new keys and newer rows. |
| **Load table - All Column Match** | Executed for `@mergeStrategy("allColumnMatch")` — matches on the non-system columns that come from the source and inserts only rows that don't already exist; nothing is updated or deleted. |
| **Clean Up Previous Data** | Deletes the copies the insert replaced — see [How a Load Replaces Rows](#how-a-load-replaces-rows-dimension-and-fact). Runs for `changeTracking` / `lastModified` only when the table is not a ReplacingMergeTree (e.g. the default MergeTree) and the node has an `@isSystemUpdateDate` column. |
| **Optimize Table** | Executed only when [`@optimize`](#optimize) is set — `OPTIMIZE TABLE … FINAL` merges the table's parts after the load, before Post-SQL. |
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

Work tables are always MergeTree (Work has no `@engine`); Dimension and Fact tables take their engine from [`@engine`](#engine) or the package `engine` parameter, by default MergeTree. Tables are created without the clauses ClickHouse Cloud adds by itself:

- No `ENGINE` is written on a Work table, or on a Dimension / Fact that defaults to MergeTree; Cloud creates `ENGINE = SharedMergeTree('/clickhouse/tables/{uuid}/{shard}', '{replica}')`. A written `ENGINE = ReplacingMergeTree(...)` becomes `SharedReplacingMergeTree(...)` on Cloud.
- `ORDER BY tuple()` is not written when the node has no `@orderBy` / `@primaryKey`; Cloud adds it.
- `SETTINGS index_granularity = 8192` is never written unless `@settings` sets it; Cloud adds it.

These rely on Cloud's `default_table_engine` and `create_table_empty_primary_key_by_default` settings.

`SETTINGS allow_nullable_key = 1` is added automatically when the table has an `@orderBy`, `@primaryKey` or `@partitionBy`, so `Nullable` columns can be key terms. Set `allow_nullable_key` in `@settings` to override it.

### Package Parameters

Package-level defaults, set once for every node instead of on each one. A node's own annotation always wins. Syntax:

```
{%- set packageParameter = namespace(engine = "ReplacingMergeTree") -%}
```

Use `"MergeTree"` (or `""` for the default) in place of `"ReplacingMergeTree"`.

**`engine`** — the Dimension / Fact `ENGINE` when the node has no [`@engine`](#engine).

| Value | Dimension / Fact tables without `@engine` |
|---|---|
| `"ReplacingMergeTree"` | ReplacingMergeTree — except a plain-insert Fact, which stays MergeTree. An `allColumnMatch` Fact is ordered by its match columns |
| `"MergeTree"` | MergeTree |
| `""` (not set, the default) | MergeTree, the built-in default |

* Work tables are always MergeTree, whatever the value.
* Decide it before the first deployment: changing it later does not recreate tables already deployed — see [Changing the Package `engine` Parameter](#known-limitations).

### Runtime Parameters

Set per environment (**Environment → Parameters**) or per job run — not a package parameter.

**`readWithFinal`** — whether the SQL the Work, Dimension and Fact node types run reads ReplacingMergeTree tables with `FINAL`: every load (its sources and the node's own target), the zero key record, the Last Modified NULL check, the column-level tests, and views without [`@final`](#final). A run-time query setting, not related to [`@settings`](#settings), which are the target table's settings in `CREATE TABLE`.

Example (Environment → Parameters):

```json
{
  "readWithFinal": true
}
```

| Value | Loads, zero key record, column-level tests and views without `@final` |
|---|---|
| `true` (or `1`) | End with `SETTINGS final = 1`, so any ReplacingMergeTree they read is read with `FINAL`; ClickHouse ignores it for tables that do not support `FINAL`, e.g. MergeTree |
| `false` (or `0`) | Run as written — readers rely on `final = 1` set on the ClickHouse user, or `FINAL` in the node's SQL |
| not set | Same as `false` |

* Loads read the value on every run. A view without [`@final`](#final) takes it once, when it is created.
* The node's own `SETTINGS` clause — see [A Node's Own `SETTINGS`](#a-nodes-own-settings).
* The **Note: Query with FINAL** deploy stage says which value is in effect (runtime parameter, or not set).
* See [Reading an Upstream ReplacingMergeTree](#reading-an-upstream-replacingmergetree-readwithfinal) for how the package `engine` and `readWithFinal` combine.

**`joinUseNulls`** — with `true`, sets ClickHouse's `join_use_nulls = 1` for every Work, Dimension and Fact node, so a `LEFT JOIN` without a match gives `NULL` in every environment, whatever the ClickHouse user's own settings. With `false` the package leaves the setting to ClickHouse.

```json
{
  "readWithFinal": true,
  "joinUseNulls": true
}
```

| Value | Added to the node's SQL | A `LEFT JOIN` column with no match |
|---|---|---|
| `true` (or `1`) — recommended | `SETTINGS join_use_nulls = 1` | `NULL` |
| `false` (or `0`), or not set | Nothing | As configured in ClickHouse (server, profile, user or session). ClickHouse's default: the type's default value — `''`, `0`, nil UUID (`NULL` if the joined column is `Nullable`) |

**How it affects your data** — a customer whose region is missing from the lookup:

```sql
SELECT c.customer_id,
       r.region_name                         AS region_name,
       coalesce(r.region_name, 'UNKNOWN')    AS region_name_clean
FROM customers c
LEFT JOIN regions r ON r.region_id = c.region_id
```

| `joinUseNulls` | `region_name` | `region_name_clean` |
|---|---|---|
| `true` | `NULL` | `UNKNOWN` |
| `false`, with ClickHouse's default | `''` (empty) | `''` — `coalesce()` only replaces `NULL` |

* Applies to every load and to views (a view keeps the value it was created with). With `readWithFinal`, both are added together: `SETTINGS final = 1, join_use_nulls = 1`.
* Change detection, SCD Type 2 versioning and the clean-up work the same with either value — only the columns your SQL takes from a join are affected.
* A node can still set its own value in its SQL (`SETTINGS join_use_nulls = 0`); it takes priority for that node — see [A Node's Own `SETTINGS`](#a-nodes-own-settings).
* With `false`, keep `join_use_nulls` the same on the ClickHouse users of every environment, so they all load the same data.
* **Keep joined columns nullable.** A `NULL` can only be stored in a `Nullable` column: in a column marked `@notNull`, ClickHouse stores the type's default value instead (`''`, `0`, nil UUID), without an error. So don't add `@notNull` to a column taken directly from a `LEFT JOIN` — or give it a fallback first:

  ```sql
  coalesce(`r`.`region_name`, 'UNKNOWN') AS `region_name` @notNull
  ```
* Not applied to node-level `@tests`, `@preSQL` / `@postSQL`, queries outside Coalesce, or Preview (which uses the ClickHouse user's settings).
* An invalid value stops the deploy and the run with **Invalid configuration: joinUseNulls**.
* This is a query setting: `@settings("join_use_nulls = 1")` holds table settings for `CREATE TABLE` and does not affect loads.

#### A Node's Own `SETTINGS`

A node's SQL can end with its own `SETTINGS` clause (e.g. `SETTINGS max_threads = 4`). The package's query settings (`final = 1`, `join_use_nulls`) are combined with it, and any setting the node sets itself takes priority for that node:

| Node | Resulting SQL |
|---|---|
| Work, plain-insert Fact, views | `… SETTINGS max_threads = 4, final = 1, join_use_nulls = 1` |
| Dimension, Fact with a merge strategy | The node's clause stays with its own `SELECT`; the load ends with `SETTINGS final = 1, join_use_nulls = 1` |

So `SETTINGS final = 0` or `SETTINGS join_use_nulls = 0` in a node's SQL opts that single node out.

### Column Types

Each column is created with the type Coalesce infers for it, with its nullability folded into the type:

| **Column** | **Created as** |
|---|---|
| Default (Coalesce infers SQL node columns as nullable) | `Nullable(<type>)` |
| Marked `@notNull` | `<type>` |
| `@isSurrogateKey` (Dimension) | Same rule, and `@notNull` is required: without it the **Missing Required System Columns** check stops the deploy and the run |
| `@isSystemUpdateDate` on a ReplacingMergeTree (the engine's version argument) | Same rule: `<type>` only with `@notNull`. ClickHouse rejects a `Nullable` version argument, so mark it `@notNull` |
| `LowCardinality(<type>)`, nullable | `LowCardinality(Nullable(<type>))` |
| `Array`, `Map`, `Tuple`, `Nested`, `JSON` / `Object`, `Dynamic`, `Variant`, `AggregateFunction`, `SimpleAggregateFunction`, geo types (`Point`, `Ring`, `LineString`, `MultiLineString`, `Polygon`, `MultiPolygon`, `Geometry`) | `<type>` — ClickHouse cannot make these `Nullable` |

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
| `Nullable` → not null (`@notNull` added) without `@defaultValue` | Deploy fails: *Cannot convert column ... from nullable type ... to non-nullable type ... Please specify `DEFAULT` expression*. ClickHouse requires the `DEFAULT` even when the column holds no NULLs, including on an empty table. Add `@defaultValue` to fill the NULLs |
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
| `@engine` changed (Dimension / Fact) | Table recreated — reason `ENGINE changed` |
| ReplacingMergeTree (Dimension / Fact): a column marked or unmarked `@isBusinessKey`, a business key column renamed or retyped, or `@isSystemVersion` added, removed or moved | Table recreated — reason `ReplacingMergeTree key changed: @isBusinessKey or SYSTEM_VERSION` |
| `@orderBy` changed, no `@primaryKey` | Table recreated |
| `@primaryKey` changed | Table recreated |
| `@partitionBy` changed | Table recreated |
| Key column renamed or its type changed (nullability included) | Table recreated |
| `@primaryKey` unchanged, trailing `@orderBy` terms removed | Altered in place (**Modify Order By**) |
| `@primaryKey` unchanged, new columns (without a `@defaultValue`) added at the end of `@orderBy` | Altered in place (**Add Column** with `MODIFY ORDER BY`) |
| `@settings` changed | Altered in place (**Modify Settings** / **Reset Settings**) |
| A column dropped after it is removed from `@orderBy` | Altered in place (**Modify Order By** runs before **Drop Column**) |

Terms are compared ignoring spaces, backticks and case.

On a Dimension or Fact ReplacingMergeTree, `ORDER BY` is always built from the business key, plus `SYSTEM_VERSION` on a Dimension that has it, so marking another column `@isBusinessKey` (or removing one), adding / removing `@isSystemVersion`, or adding / removing `@zeroKey` on a Dimension, changes `ORDER BY` and recreates the table. ⚠️ The existing data is lost; the next run reloads the table from the source, so an SCD Type 2 Dimension loses its history.

A recreate always runs a non-failing **Warning: Table Recreated (`<reason>`)** stage first. Its comment repeats the reason and, when the sort key changed, shows it as `ORDER BY (<old>) -> (<new>)`, e.g.:

```sql
-- DIM_CUSTOMER cannot be altered in place (ReplacingMergeTree key changed: @isBusinessKey, SYSTEM_VERSION or @zeroKey): ...
-- ORDER BY (`c_custkey`, `SYSTEM_VERSION`) -> (`c_custkey`, `c_name`, `SYSTEM_VERSION`)
-- The table is recreated with CREATE OR REPLACE. Its existing data is lost; it stays empty until the next run reloads it.
```

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

ClickHouse has no `MERGE`. A Dimension or Fact load therefore **only inserts** the row set a `MERGE` would have applied: new keys, plus a new copy of every changed row. An "update" re-inserts the same business key with a newer `SYSTEM_UPDATE_DATE`; an SCD Type 2 expiry re-inserts the old version with `SYSTEM_CURRENT_FLAG = 'N'` and its end date.

The older copies are removed according to the table engine, set with [`@engine`](#engine) or the package `engine` parameter:

* **MergeTree** (the default) — see below.
* **ReplacingMergeTree** — created as `ReplacingMergeTree(<@isSystemUpdateDate column>)`. Per `ORDER BY` key, ClickHouse keeps only the row with the latest `SYSTEM_UPDATE_DATE`. `ORDER BY` is always built from the business key, plus `SYSTEM_VERSION` on a Dimension that has it — every copy of a row the load replaces has the same values there. `@orderBy` / `@primaryKey` are not accepted. Nothing is deleted.
* **MergeTree** (the default, or any engine other than a ReplacingMergeTree) — **Clean Up Previous Data** runs after the insert: a `DELETE` of the copies the insert replaced, per business key (plus `SYSTEM_VERSION` for SCD Type 2, plus the surrogate key on a Dimension), keeping the row with the latest `SYSTEM_UPDATE_DATE`. Only keys that now have more than one row are read, and only the target is read — never the source. A NULL key is cleaned up like any other (`SETTINGS transform_null_in = 1`). A plain `SELECT` is correct right after the run.

**Both engines give the same result, for every merge strategy.** A MergeTree table holds exactly the rows a ReplacingMergeTree returns when read with `FINAL`: ClickHouse removes the older copies of a ReplacingMergeTree itself, and the load does it for a MergeTree. To keep the two the same, every load also:

* keeps **one source row per key** before it inserts (`LIMIT 1 BY` the business key; for `allColumnMatch`, its match columns), as a ReplacingMergeTree keeps one row per `ORDER BY` key. `lastModified` keeps the row with the newest `@lastModifiedTracking` value, and `allColumnMatch` the one with the latest `@isSystemUpdateDate` when there is one; otherwise which duplicate is kept is not defined — see [Unique Business Keys](#unique-business-keys-fact-and-dimension).
* matches keys **NULL-safely** (`isNotDistinctFrom`): a NULL business key is one key value, as it is in a ReplacingMergeTree's `ORDER BY`.

This holds when `readWithFinal` is `true`: with it `false`, a ReplacingMergeTree load reads its own copies before they are merged and can differ — see [Reading an Upstream ReplacingMergeTree](#reading-an-upstream-replacingmergetree-readwithfinal).

#### Querying a ReplacingMergeTree

The older copies are removed at a background merge, at a time ClickHouse picks. Until then a plain `SELECT` returns **every** copy: a changed key can appear twice, and the replaced (old) values are included. Counts, sums and joins on the table are then wrong.

**Ways to get clean output — one row per key, the latest values:**

| # | Way | Where it is set | What it covers | Notes |
|---|---|---|---|---|
| 1 | **`final = 1` on the ClickHouse user or settings profile** (recommended) | ClickHouse: `ALTER USER` / `ALTER SETTINGS PROFILE` | Every query from that user: BI tools, analysts, downstream jobs | Nobody has to remember `FINAL`. See below. |
| 2 | **`FINAL` or `SETTINGS final = 1` in the query** | The query | That one query | `SETTINGS final = 1` covers every table in the query, CTEs and joins included. |
| 3 | **`readWithFinal: true`** (runtime parameter) | `--parameters` on each run | The package's own SQL: loads (sources and the node's own target), the zero key record, column-level tests, and views without `@final` when they are created | Not node-level `@tests` / `@preSQL` / `@postSQL` — add `FINAL` there yourself (a warning reminds you). See [Runtime Parameters](#runtime-parameters). |
| 4 | **`@final` on a view** | Node annotation (Work, Dimension, Fact views) | Everyone who reads the view | The view's `SELECT` ends with `SETTINGS final = 1`, whatever `readWithFinal` is. See [`@final`](#final). |
| 5 | **`@optimize` on a Dimension / Fact table** | Node annotation | The stored table itself: after each load `OPTIMIZE TABLE … FINAL` merges it, so even a plain `SELECT` returns one row per key | Rewrites the table on every run — for small or medium tables. A row whose `@partitionBy` value changed keeps an old copy in its old partition (only `FINAL` hides it). See [`@optimize`](#optimize). |
| 6 | **`@engine("MergeTree")`** instead of ReplacingMergeTree | Node annotation or package `engine` parameter | The stored table itself: **Clean Up Previous Data** deletes the replaced copies after each load, so a plain `SELECT` is always right | Slower loads (a `DELETE` per run); no `FINAL` needed anywhere. Same result as a ReplacingMergeTree read with `FINAL` — see [How a Load Replaces Rows](#how-a-load-replaces-rows-dimension-and-fact). |
| — | Waiting for background merges | ClickHouse, on its own schedule | — | **Not a guarantee:** merges run when ClickHouse decides, never cross partitions and may never fully finish. Do not rely on them for correct results. |

Options 1–4 decide how a ReplacingMergeTree is **read**; options 5–6 decide what is **stored**. For dashboards and ad-hoc queries use option 1; for the package's own loads use option 3; when readers cannot be controlled (exports, other tools), use option 5 or 6.

> **Recommended:** set `final = 1` on the ClickHouse user (or settings profile) that BI tools, analysts and downstream jobs connect with:
>
> ```sql
> ALTER USER <user> SETTINGS final = 1;
> -- or, for every user on a profile:
> ALTER SETTINGS PROFILE <profile> SETTINGS final = 1;
> ```
>
> Every query from that user then reads each ReplacingMergeTree with `FINAL` — one row per key, the latest values — without anyone having to remember it. `final` cannot be set on the table itself; it is a query, user or profile setting. Without it, every reader must add `FINAL` themselves, or the results include the replaced rows.

To apply it to a single query instead, add `FINAL` after the table, or `SETTINGS final = 1` to the statement:

```sql
SELECT * FROM `<DB>`.`DIM_CUSTOMER` FINAL WHERE `SYSTEM_CURRENT_FLAG` = 'Y'
SELECT * FROM `<DB>`.`DIM_CUSTOMER` WHERE `SYSTEM_CURRENT_FLAG` = 'Y' SETTINGS final = 1
```

`final = 1` applies `FINAL` to every table in the query that supports it; tables with other engines are read as usual.

How the node types remind readers:

* A passing **Note: Query with FINAL** stage runs after **Create table** / **Recreate Table**.
* **A warning inside the statement's own stage:** when `readWithFinal` is `true`, each `@tests`, `@preSQL` or `@postSQL` stage that `SELECT`s from the table — written as `{{ this }}` or by its name — without `FINAL` starts with comment lines saying the values shown may not be consistent, and how to fix it. It goes away once `FINAL` (or `SETTINGS final = 1`) is added. `DELETE`, `ALTER` and `TRUNCATE` statements are not flagged: they act on every copy. With the parameter `false` there is no warning: `FINAL` is then expected from the ClickHouse user's settings.

With `readWithFinal` = `true`, the load itself (its reads of the target for change detection and the zero key record) and the column-level tests end with `SETTINGS final = 1`, which reads the target with `FINAL`. With `false` they run without it. Node-level `@tests` and `@preSQL` / `@postSQL` always run as written — add `FINAL` yourself:

```sql
@tests("SELECT 1 FROM {{ this }} FINAL GROUP BY `l_orderkey`, `l_linenumber` HAVING count() > 1", false, "After")
```

#### Reading an Upstream ReplacingMergeTree (`readWithFinal`)

A Work, Dimension or Fact can come after a Dimension or Fact. When the upstream is a ReplacingMergeTree, the node's own `SELECT` reads its replaced copies too, unless it is read with `FINAL`. The [`readWithFinal`](#runtime-parameters) runtime parameter adds this for you — a run-time query setting for reading the sources, separate from [`@settings`](#settings), which are the target table's MergeTree settings in `CREATE TABLE`:

| `readWithFinal` | The node's loads |
|---|---|
| `true` (or `1`) | End with `SETTINGS final = 1`, whatever the node reads and whatever its own engine |
| `false` (or `0`, the default) | Run as written. Use this when `final = 1` is already set on the ClickHouse user that runs the pipeline (see above), or the node's SQL writes `FINAL` itself |

Together with the package `engine`:

| Package `engine` | `readWithFinal` | Dimension / Fact tables are created as | Load queries read their sources |
|---|---|---|---|
| `ReplacingMergeTree` | `true` | ReplacingMergeTree, unless `@engine` overrides | With `SETTINGS final = 1` |
| `MergeTree` / empty | `true` | MergeTree, unless `@engine` overrides | With `SETTINGS final = 1` — it takes effect only on the upstream nodes overridden to `@engine("ReplacingMergeTree")` |
| `ReplacingMergeTree` | `false` | ReplacingMergeTree, unless `@engine` overrides | As written — correct only when `final = 1` is set on the ClickHouse user or profile Coalesce runs with |
| `MergeTree` / empty | `false` | MergeTree, unless `@engine` overrides | As written — fine unless an upstream is overridden to a ReplacingMergeTree and the user has no `final = 1` |

A plain-insert Fact stays MergeTree whatever the package `engine` (see [`@engine`](#engine)). `readWithFinal` = `false` relies on `final = 1` being set on the ClickHouse user in the environment's connection — the one Coalesce runs as — not only on the users analysts connect with.

* **Work nodes too:** a Work table is always MergeTree (Work has no `@engine`), but what it reads can be a ReplacingMergeTree, so its load gets the setting like a Dimension or Fact.
* **Why always:** the engine of what a node reads is not in its metadata — an upstream node's `@engine` is not passed, and a source table can be anything. ClickHouse applies `final = 1` only to the tables that support `FINAL`, so a ReplacingMergeTree upstream (from the package `engine`, its own `@engine`, or an external source table) is read with one row per key, and a MergeTree — whose load already deleted its replaced copies — is read as usual. It covers the node's own target too: a MergeTree target ignores it, a ReplacingMergeTree target is read with `FINAL`.
* **Where:** the load `INSERT ... SELECT` of every Work, Dimension and Fact and the **Check Last Modified Column - NULL Values** test, on every run. A view gets it in its definition when it is created — with [`@final`](#final), or when `readWithFinal` is `true` at that deploy.
* **Cost:** `FINAL` merges the replaced copies at read time, so loads reading a large ReplacingMergeTree take longer. If background merges keep up, or the ClickHouse user already has `final = 1`, use `false`.
* **Always added** when `readWithFinal` is `true`. When the node's SQL ends with its own `SETTINGS` clause, see [A Node's Own `SETTINGS`](#a-nodes-own-settings); if that clause already sets `final`, the node's own value wins, so `SETTINGS final = 0` opts a node out.
* With `readWithFinal` = `false`, a single node can still read an upstream with `FINAL` in its SQL: ``FROM {{ ref('TARGET', 'DIM_CUSTOMER') }} FINAL``.

**Independent of `readWithFinal`:**

* **A ReplacingMergeTree node reads its own target with `FINAL` only through this setting** — in its load (change detection and the zero key record) and in its column-level tests. With `readWithFinal` = `false` they read it as stored: set `final = 1` on the ClickHouse user Coalesce runs as. Without either, change detection compares against copies not merged yet, and the results show it (unchanged rows inserted again, a key with two current SCD2 versions).
* **Only the node type's own SQL gets the setting** — the load, the zero key record, the Last Modified NULL check, the column-level tests and view definitions. Node-level `@tests`, `@preSQL` and `@postSQL` run as written; on a ReplacingMergeTree with `readWithFinal` = `true`, the ones that read it without `FINAL` get a warning at the top of their own stage.
* **Queries outside Coalesce** — BI tools, analysts — are not covered: set `final = 1` on their ClickHouse user or profile (see [Querying a ReplacingMergeTree](#querying-a-replacingmergetree)).
* **[`@settings`](#settings) is unrelated:** it holds the target table's MergeTree settings, written into `CREATE TABLE`. `final` is not a table setting — do not put it there.

| `@mergeStrategy` | Matches on | What the load does |
|---|---|---|
| `changeTracking` (default when `@mergeStrategy` is not set) | `@isBusinessKey` columns | New keys are inserted; changed rows are re-inserted with a newer `SYSTEM_UPDATE_DATE` and the older copy is removed |
| `lastModified` | `@isBusinessKey` columns, plus exactly one `@lastModifiedTracking` column | Only rows newer than the target's are loaded, then as `changeTracking` |
| `allColumnMatch` (Fact) | The match columns: the non-system columns that come from the source (`@isBusinessKey` is ignored) | Only rows with no matching row in the target are inserted; nothing is updated or deleted. On a ReplacingMergeTree the match columns are the `ORDER BY`, so identical rows also collapse at a merge |

A Fact with no `@isBusinessKey` column and no `@mergeStrategy` is loaded as a plain insert: it replaces no rows, nothing is cleaned up, and a package `engine` parameter of `ReplacingMergeTree` does not apply to it — it stays MergeTree (a ReplacingMergeTree would collapse identical rows). An `allColumnMatch` Fact only inserts rows that don't exist yet, so nothing is cleaned up either; it does take a `ReplacingMergeTree` engine, ordered by its match columns — see [Fact All Column Match](#fact-all-column-match).

* The ReplacingMergeTree and the clean-up tell the copies apart only by `SYSTEM_UPDATE_DATE`, so they need that column. On a ReplacingMergeTree it is the engine's version argument: required, and it must be marked `@notNull`. Like every column it is `Nullable(...)` without `@notNull`, and ClickHouse does not accept a `Nullable` version argument:

  ```sql
  CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS "SYSTEM_UPDATE_DATE" @isSystemUpdateDate @notNull
  ```

  Without it the deploy and the run show a passing **Warning: @isSystemUpdateDate without @notNull** stage, the flow continues, and ClickHouse's error stops the create — see [`@isSystemUpdateDate` Without `@notNull` on a ReplacingMergeTree](#known-limitations). Manually created nodes do not add `@notNull`; add it when the node is a ReplacingMergeTree.
* A ReplacingMergeTree requires a business key. `SYSTEM_VERSION` is required on an SCD Type 2 Dimension and optional on SCD Type 1 — see [`SYSTEM_VERSION` on a ReplacingMergeTree](#system_version-on-a-replacingmergetree-dimension). Without a business key, or with `@orderBy` / `@primaryKey` set, **Invalid configuration: engine** stops the deploy and the run: a manual sort key could collapse different rows into one, or keep the copies the load replaces. Use MergeTree (the default, or `@engine("MergeTree")` when the package parameter is ReplacingMergeTree) to set your own sort key.
* A ReplacingMergeTree only replaces rows within one partition. When a row moves partition (its `@partitionBy` value changes), the old copy stays in the old partition for good: background merges never cross partitions. Reads with `FINAL` still show one row per key, because ClickHouse's `FINAL` de-duplicates across partitions by default (`do_not_merge_across_partitions_select_final = 0`); a read without `FINAL` shows both copies. Prefer a `@partitionBy` whose value cannot change for a business key.
* On a MergeTree, a reader can briefly see both copies of a changed row between the insert and the clean-up. If the clean-up stage fails, the extra copies stay until the next successful run's clean-up removes them.
* The load runs the node's SELECT with the ClickHouse user's settings, as Preview does — except `join_use_nulls` when the [`joinUseNulls`](#runtime-parameters) runtime parameter is set.

#### `SYSTEM_VERSION` on a ReplacingMergeTree (Dimension)

A ReplacingMergeTree decides two things: which rows are copies of each other (its `ORDER BY`), and which copy survives (its version argument, `SYSTEM_UPDATE_DATE` — the latest one).

* **SCD Type 2 — required.** Every version of a business key is its own row, so `ORDER BY` is the business key plus `SYSTEM_VERSION`. Without `SYSTEM_VERSION` the versions would count as copies and only the newest would survive, wiping the history. The **Missing Required System Columns** check stops the node without it.
* **SCD Type 1 — optional.** There is one row per business key, and `SYSTEM_UPDATE_DATE` alone picks the latest copy. Without `SYSTEM_VERSION`, `ORDER BY` is just the business key; with it, `ORDER BY` is the business key plus `SYSTEM_VERSION`, which is always `1` and so groups the rows the same way.

**Why it might still be added on SCD Type 1:** with it, the table's `ORDER BY` has the same shape as an SCD Type 2 node's. ClickHouse cannot change an `ORDER BY` in place, so adding or removing `@isSystemVersion` later recreates the table (**Warning: Table Recreated**, existing data lost).

**However, changing a Dimension's SCD type after it holds data is not supported**, with either engine: the rows already loaded were never versioned (SCD Type 1 → 2 has no history to start from, and 2 → 1 leaves several versions per key), so the result would be corrupt. Rebuild the Dimension instead. As the SCD type is not changed in place, `SYSTEM_VERSION` can be left out of an SCD Type 1 Dimension.

### Unique Business Keys (Fact and Dimension)

The `@isBusinessKey` column(s) should be unique in the node's source: one row per business key per load.

If the source returns the same business key more than once, the load keeps **one row per key** (`LIMIT 1 BY` the business key) on either engine, so a MergeTree and a ReplacingMergeTree end the same. Under `lastModified` the row with the newest `@lastModifiedTracking` value is kept; under `changeTracking` which row is kept is **not defined**, and the others are dropped without an error.

To decide which row wins, or to stop the run instead, de-duplicate or check the data before it is loaded, for example:

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

### Surrogate Keys (Dimension)

ClickHouse has no identity columns. The surrogate key is a plain column, and the Dimension load gives a **new row or a new SCD Type 2 version** its key from the column's `@defaultValue`. Rows that are re-inserted by the load (an expired version, an in-place update) keep the key they already have.

The `@isSurrogateKey` column **requires `@notNull`**, because every row must have a key. The package does not force the type to not null: the column follows `@notNull` like every other column, so its nullability in the node's mapping matches the table. Without `@notNull` the **Missing Required System Columns** check stops the deploy and the run. This applies to Dimensions only: Facts have no surrogate key.

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

* ⛔ Not accepted on a Dimension or Fact ReplacingMergeTree: its `ORDER BY` is always built from the business key, plus `SYSTEM_VERSION` on a Dimension that has it, and the deploy and the run stop if `@orderBy` is set. Use it on Work nodes and on MergeTree Dimensions and Facts (the default).
* Without `@orderBy` (and `@primaryKey`) a MergeTree table uses `ORDER BY tuple()` — see [ClickHouse Cloud Defaults](#clickhouse-cloud-defaults).
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

* ⛔ Not accepted on a Dimension or Fact ReplacingMergeTree, as `@orderBy`.
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

##### `@engine`

`@engine("ReplacingMergeTree | MergeTree")` — Dimension and Fact only.

The table's `ENGINE`: **`MergeTree` or `ReplacingMergeTree` only**, written without arguments. The name is not case-sensitive (`@engine("replacingmergetree")` is written `ReplacingMergeTree`), and `MergeTree()` is the same as `MergeTree`. The loads are built for these two engines; other MergeTree-family engines (`SummingMergeTree`, `AggregatingMergeTree`, `CollapsingMergeTree`, ...) change rows at merges, so they are not accepted.

* **Where the engine comes from**, first match wins:
  1. The node's `@engine`.
  2. The package parameter `engine`, set once for every Dimension and Fact in the package — e.g. `ReplacingMergeTree`, so it does not have to be written on each node. A `ReplacingMergeTree` value is not applied to a plain-insert Fact (it would collapse identical rows) — that Fact goes on to step 3. An `allColumnMatch` Fact takes it, ordered by its match columns.
  3. The built-in default: **MergeTree**. No `ENGINE` is written, as when ClickHouse itself is given none (Cloud creates `SharedMergeTree`).
* **`readWithFinal` parameter:** `true` makes downstream nodes read their upstream ReplacingMergeTree with `FINAL` — see [Reading an Upstream ReplacingMergeTree](#reading-an-upstream-replacingmergetree-readwithfinal).
* **`ReplacingMergeTree`:** the load only inserts and ClickHouse keeps the latest copy of each row — see [How a Load Replaces Rows](#how-a-load-replaces-rows-dimension-and-fact). The `@isSystemUpdateDate` column is added as the version argument and must be marked `@notNull`. `ORDER BY` is always built from the business key, plus `SYSTEM_VERSION` on a Dimension that has it; `@orderBy` / `@primaryKey` are not accepted. Readers need `FINAL` — see [Querying a ReplacingMergeTree](#querying-a-replacingmergetree). The table `COMMENT` is the node description only; nothing is added for the engine.
* **`MergeTree` (the default):** the load inserts and then deletes the replaced copies in **Clean Up Previous Data**. `@orderBy` / `@primaryKey` can be set. No `ENGINE` and `@engine("MergeTree")` are the same engine: switching between them does not recreate the table.
* **Write `ReplacingMergeTree` without arguments.** The loads set the version argument and `ORDER BY` themselves, so an engine with its own arguments, such as ``@engine("ReplacingMergeTree(`SYSTEM_UPDATE_DATE`)")`` or the same value in the package `engine` parameter, stops the deploy and the run.
* **Invalid configuration: engine** stops the deploy and the run for any engine other than `MergeTree` / `ReplacingMergeTree`, for an engine written with arguments, and for a ReplacingMergeTree with `@orderBy` / `@primaryKey`, or without a business key or `@isSystemUpdateDate` column (except `allColumnMatch`, which needs neither).
* On redeploy, a changed `@engine` recreates the table — existing data is lost.
* **Note:** Ignored on Views.

**Example:**

```sql
@engine("ReplacingMergeTree")
```

On the first deployment, a Dimension with `@engine("ReplacingMergeTree")` (or no `@engine` and the package parameter `ReplacingMergeTree`) and a description creates:

```sql
CREATE OR REPLACE TABLE `<DB>`.`DIM_CUSTOMER`
(
    ...
    `SYSTEM_UPDATE_DATE` DateTime
)
ENGINE = ReplacingMergeTree(`SYSTEM_UPDATE_DATE`)
ORDER BY (`c_custkey`, `SYSTEM_VERSION`)
SETTINGS allow_nullable_key = 1
COMMENT 'Customer dimension'
```

`@zeroKey` does not change the table: a ReplacingMergeTree Dimension is ordered by the business key + `SYSTEM_VERSION` only, with or without it, and adding, changing or removing `@zeroKey` needs no redeploy. **The zero record's business key values must be unique** — different from every real business key; override them with a column-level `@zeroKey` when the defaults (`0`, `'UNKNOWN'`) can occur in the data. See [Zero Key Record](#zero-key-record) and the bullets above.

##### `@final`

`@final` — Work, Dimension and Fact, **views only**.

The view's `SELECT` ends with `SETTINGS final = 1`, so any ReplacingMergeTree it reads is read with `FINAL` — one row per key, without the copies a load replaced.

A view is fixed when it is deployed, so it decides then, first match wins:

| `@final` | `readWithFinal` at deploy | The view's `SELECT` |
|---|---|---|
| Set | any | Ends with `SETTINGS final = 1` |
| Not set | `true` | Ends with `SETTINGS final = 1` |
| Not set | `false` | No `SETTINGS final = 1` |
| Not set | not set | No `SETTINGS final = 1` |

* Adding or removing `@final` on redeploy recreates the view (**Create View**).
* Changing `readWithFinal` later does not change a deployed view — see [Changing `readWithFinal` on Views](#known-limitations). Use `@final` to fix a view's behaviour whatever the parameter.
* When the view's SQL already ends with its own `SETTINGS` clause, `final = 1` is appended to it (`SETTINGS max_threads = 4, final = 1`); if that clause already sets `final`, the node's own value wins: `SETTINGS final = 0, final = 1` reads without `FINAL`, so `SETTINGS final = 0` opts a node out.
* **On a table** `@final` does nothing: a non-failing **Warning: @final on a table** stage is shown at deploy and on every run, and the load follows `readWithFinal`.

**Example:**

```sql
@materializationType("view")
@final
```

##### `@optimize`

`@optimize` — Dimension and Fact, **tables only**.

Adds an **Optimize Table** stage after the load and before **Post-SQL**, that runs `OPTIMIZE TABLE <table> FINAL`. ClickHouse merges the table's parts on every load instead of waiting for a background merge, so `@postSQL` and the **After** tests see the merged table.

* **ReplacingMergeTree:** after the merge the table keeps only the latest row per `ORDER BY` key, so a plain `SELECT` returns what a `SELECT … FINAL` returns. The exception is a row whose `@partitionBy` value changed: merges never cross partitions, so its old copy stays in the old partition (`FINAL` still hides it).
* **MergeTree:** the replaced copies are already removed by **Clean Up Previous Data**; `@optimize` only merges the parts.
* Rewrites the whole table on every run — use it on small or medium tables, or where readers must not need `FINAL`.
* **On a view** `@optimize` does nothing: a non-failing **Warning: @optimize on a view** stage is shown at deploy and on every run.
* Adding or removing it on redeploy only updates the node metadata.

**Example:**

```sql
@optimize
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
| `algo` | **(optional)** Hashing function. `MD5`, `SHA1`, `SHA224`, `SHA256`, `SHA384` and `SHA512` (any case) return a lowercase hex `String`. Any other ClickHouse hash function (e.g. `cityHash64`, `xxHash64`, `sipHash64`) is called as written. These return a `UInt64`, but Coalesce types every `get_hash` column as `String`, so the number is stored as its digits (e.g. `'7740249813402470115'`); wrap the call for a numeric column: `toUInt64({{ get_hash('GH', 'cityHash64') }})`. Defaults to `SHA1`. |
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

* Must hold a source value that increases whenever the row changes, such as a last-updated timestamp or a change sequence number. Under `@mergeStrategy("lastModified")` the **Invalid configuration: Last Modified Column** check stops the deploy and the run when the column:
  * is also a key or system column (`@isBusinessKey`, `@isSurrogateKey`, `@isSystemVersion`, `@isSystemCurrentFlag`, `@isSystemCreateDate`, `@isSystemUpdateDate`, `@isSystemEndDate`): a key never changes, and system columns are written by the load;
  * is not a date/time (`Date`, `Date32`, `DateTime`, `DateTime64`) or numeric (`Int*`, `UInt*`, `Float*`, `Decimal*`) type — e.g. a `String`, `UUID` or `Bool`;
  * is not derived from any source column, e.g. a constant or `now64()`. A transformation is fine as long as it uses a source column (`toDateTime(src.updated_epoch)`). This is read from Coalesce's column lineage, which does not follow a column through the node's own CTEs, so it is not checked on a node with a `WITH` clause.
* Can only be applied to one column.
* Must not be NULL in the source — the **Check Last Modified Column - NULL Values (`<column>`)** stage fails the run, since a NULL value can never compare as newer: a row loaded with a NULL tracking value is never updated again.
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

* A column test checks **every row of the target**, not only the rows just loaded. On an SCD Type 2 Dimension this includes the expired versions and the zero key record, so `@uniqueness` on a business key fails as soon as one key has a second version. Test only the current rows with a node-level test instead, e.g. `@tests("SELECT `k` FROM {{ this }} WHERE `SYSTEM_CURRENT_FLAG` = 'Y' GROUP BY `k` HAVING count() > 1", false)`.
* A failing column test never stops the run. To stop the run on a failure, write the check as a node-level [`@tests`](#tests) with `continueOnFailure` = `false`.

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

* **Replaced Rows Until a Merge (ReplacingMergeTree)**:  
The load only inserts; the older copy of a changed row stays in the table until ClickHouse merges the parts in the background. A plain `SELECT` can return both copies until then — query with `FINAL`. With `@engine("MergeTree")` the copies are deleted in **Clean Up Previous Data** instead, and a changed key can have two rows between the two stages (or after a failed clean-up, until the next run). See [How a Load Replaces Rows](#how-a-load-replaces-rows-dimension-and-fact).

* **Changing the Package `engine` Parameter**:  
Changing the parameter does not recreate tables already deployed. Coalesce renders a node's deployed state and its new state with the same, current parameter and macro values — the value a table was deployed with is not kept — so a redeploy sees the same engine on both sides and only updates metadata — the `@isSystemUpdateDate` column has the same type under both engines, since `@notNull` alone decides its nullability. The tables keep their old engine while their loads follow the new one, and the loaded data no longer matches what the node expects:
  * **MergeTree table, package changed to `ReplacingMergeTree`:** the load only inserts and skips the clean-up `DELETE`, and a MergeTree never removes the older copies itself, so a changed key keeps every copy for good. `SETTINGS final = 1` does not help: ClickHouse ignores it on a MergeTree.
  * **ReplacingMergeTree table, package changed to `MergeTree`:** the load reads its own target without `FINAL`, so it can compare against an older copy that is not merged yet and insert rows that did not change. The clean-up `DELETE` then runs on the ReplacingMergeTree as an extra mutation. The **Note: Query with FINAL** stage still describes the old engine.
  * Downstream nodes read whatever the table holds, so the extra copies reach them too, unless `readWithFinal` or a user-level `final = 1` applies `FINAL` to a table that is still a ReplacingMergeTree.

  The engine shown in `system.tables` (`SELECT name, engine FROM system.tables WHERE database = '<schema>'`) is the table's real engine. To move existing tables to the new engine:
  * Set `@engine` on the node — a changed `@engine` is kept in the node's deployed state, so the redeploy recreates the table (existing data is lost). The annotation can stay; it then simply matches the package value.
  * Or recreate the tables: deploy once without the nodes (Coalesce drops the tables), then once with them (Coalesce creates them with the new engine). A table dropped outside Coalesce is not recreated by a deploy, since the node itself has not changed.
  
  Remove any `@orderBy` / `@primaryKey` from nodes that become a ReplacingMergeTree first — they are not accepted on one. Decide the package `engine` before the first deployment where possible.

* **Changing `readWithFinal` on Views**:  
A view's definition is compared before and after using the parameter's current value, so turning `readWithFinal` on or off does not recreate views already deployed — they keep the definition they were created with. Loads follow the new value on their next run. To change a view, add or remove [`@final`](#final) (the redeploy recreates it), or drop the view and redeploy. See [Reading an Upstream ReplacingMergeTree](#reading-an-upstream-replacingmergetree-readwithfinal).

* **Changing `joinUseNulls`**:  
Switching the value on tables that already hold data changes the unmatched join values (e.g. `''` becomes `NULL`), so the next run updates those rows even though the source has not changed — on a Dimension, as new SCD Type 2 versions when the joined column is `@isChangeTracking`. Deployed views keep the value they were created with until they are recreated, as with [`readWithFinal`](#known-limitations). Choose the value before the first load and use the same one in every environment.

* **Loads Within the Same Second**:  
The default system column expression `CAST(CURRENT_TIMESTAMP AS TIMESTAMP)` gives a `DateTime` column, which stores whole seconds. The ReplacingMergeTree and the clean-up tell a row's copies apart by `SYSTEM_UPDATE_DATE`, so if two loads change the same key within one second both copies have the same value: a ReplacingMergeTree keeps the one inserted last, the clean-up keeps both. Use a `DateTime64` type for `SYSTEM_UPDATE_DATE` (e.g. `CAST(now64(6) AS DateTime64(6))`) if a node can run more than once a second.

* **Duplicate Business Keys**:  
Duplicates in the source are not rejected: both copies are inserted and kept. De-duplicate upstream — see [Unique Business Keys](#unique-business-keys-fact-and-dimension).

* **NULL Business Keys**:  
A NULL business key is matched like a value (`isNotDistinctFrom`: NULL matches NULL), as it is in a ReplacingMergeTree's `ORDER BY`. All source rows with a NULL key are therefore **one key**: one of them is loaded and then updated like any other key, on both engines. If a NULL key should not be a member at all, filter or default NULL keys upstream, e.g. `WHERE <business key> IS NOT NULL` or `coalesce(<business key>, '<placeholder>')`, or check it with a `Before` test — see [Duplicate or NULL Business Key Check](#duplicate-or-null-business-key-check).

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

* **`@isSystemUpdateDate` Without `@notNull` on a ReplacingMergeTree**:  
A ReplacingMergeTree uses the `@isSystemUpdateDate` column (`SYSTEM_UPDATE_DATE`) as its version argument — ``ReplacingMergeTree(`SYSTEM_UPDATE_DATE`)``. Like every column it is `Nullable(...)` unless it is marked `@notNull`, and ClickHouse does not accept a `Nullable` version argument. The deploy and the run show a passing **Warning: @isSystemUpdateDate without @notNull** stage, the flow continues, and ClickHouse's error stops the create:

  ```
  The column SYSTEM_UPDATE_DATE cannot be used as a version column for storage ReplacingMergeTree because it is of type Nullable(DateTime64(6)) (must be of an integer type or of type Date/DateTime/DateTime64).
  ```

  or, on a table created before the `@notNull` was removed, the redeploy's `ALTER`:

  ```
  Cannot alter version column SYSTEM_UPDATE_DATE to type Nullable(DateTime64(6)) because version column must be of an integer type or of type Date or DateTime.
  ```

  Add `@notNull` to the column:

  ```sql
  CAST(CURRENT_TIMESTAMP AS TIMESTAMP) AS "SYSTEM_UPDATE_DATE" @isSystemUpdateDate @notNull
  ```

  A failed redeploy leaves the table unchanged, with a `<table>_COALESCE_INTERNAL_TABLE` clone that the next successful redeploy replaces (or drop it).

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

Every merge strategy loads one row per business key and treats a NULL key as one key value, so a duplicated key is dropped silently. A `Before` test runs ahead of the load and fails the run instead if the source returns a duplicated or NULL key.

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

A row is inserted only if no stored row has the same values in its **match columns**. Nothing is ever updated or deleted, and no `@isBusinessKey` is needed.

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
* **Match columns** are the non-system columns that come from the source: Coalesce's column lineage links them to a source column (`ps_partkey`, `ps_suppkey`, `ps_availqty` above). The load stage shows them in a `/* Match columns … */` comment.
* **Left out of the match:** system columns (`SYSTEM_CREATE_DATE` above), and any column that is only a transform with no source column — a constant, `now()`, `CURRENT_TIMESTAMP`, `generateUUIDv4()`, a load or batch id. Such a column never makes a stored row look new, so re-running the load doesn't insert the same row again.
* **No lineage to go on:** when the node has its own `WITH` CTEs (Coalesce does not trace columns through them) or reads a table function, every non-system column is matched. Then a column that changes on every run makes every row new on every run — mark such a timestamp `@isSystemCreateDate` / `@isSystemUpdateDate`, or leave it out.
* Matching is NULL-safe (`isNotDistinctFrom`): a row with a NULL in a match column matches its stored copy and is not inserted again.
* **ReplacingMergeTree** (`@engine("ReplacingMergeTree")` or the package `engine` parameter): `ORDER BY` is the match columns, so identical rows also collapse — within one insert and at background merges. The version argument is the `@isSystemUpdateDate` column when the node has one (``ReplacingMergeTree(`SYSTEM_UPDATE_DATE`)``, marked `@notNull`); without one the engine is a bare `ReplacingMergeTree`, which keeps the last copy inserted — the copies only differ in the columns left out of the match. No business key or update date is required; `@orderBy` / `@primaryKey` and an engine with its own arguments stop the deploy and the run (**Invalid configuration: engine**), and so does a node whose columns are all system columns. Readers need `FINAL` — see [Querying a ReplacingMergeTree](#querying-a-replacingmergetree). (The example above sets `@orderBy`, so it is for a MergeTree.)
* **MergeTree and ReplacingMergeTree give the same result** (as for every strategy — see [How a Load Replaces Rows](#how-a-load-replaces-rows-dimension-and-fact)). Each load keeps one source row per combination of match columns (`LIMIT 1 BY`; the row with the latest `@isSystemUpdateDate` when the node has one, as a ReplacingMergeTree's version argument would) and skips combinations already stored. So a MergeTree holds one row per combination — what a ReplacingMergeTree returns with `FINAL` — without needing `FINAL`; on a ReplacingMergeTree, ClickHouse also collapses copies at merges. Columns left out of the match (system columns, transforms) are not compared, so for duplicates that differ only there, the copy kept is not defined unless an `@isSystemUpdateDate` decides it.
* Changing the match columns (adding or removing a source column) on a ReplacingMergeTree changes its `ORDER BY` and recreates the table on redeploy — see [Sort Key and Partition Key Changes](#sort-key-and-partition-key-changes).

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

* An order line with no matching customer or part gets the nil UUID either way: with [`joinUseNulls`](#runtime-parameters) `true` the `coalesce()` fills it in, and with ClickHouse's default `join_use_nulls` it is already the UUID default. For other fallbacks (e.g. `'UNKNOWN'`), use `joinUseNulls: true` — see [Runtime Parameters](#runtime-parameters).

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
