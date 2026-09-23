# HANA specifics — what changes when the database is a column store

**Level:** 301 · deep dive

**Status:** stub — the list is here; the measurements are not yet.

**One line:** On HANA the database is in memory and column-oriented, which makes aggregation cheap and row-by-row access relatively expensive, changes the order rows come back in when no `ORDER BY` was written, removes the pooled and cluster tables, and makes *code-to-data* — doing the work in a `SELECT`, a CDS view or an AMDP — the performance strategy rather than "read it all and loop".

## What actually changes

| Before | On HANA |
|---|---|
| a `SELECT` with no `ORDER BY` returned rows in primary-key order, by accident | any order; code that relied on it (`READ TABLE … BINARY SEARCH` after a `SELECT`) breaks |
| `SELECT … UP TO 1 ROWS` and `SELECT SINGLE` were interchangeable | still return one row, but `SINGLE` without a full key is now a random one in practice |
| pooled and cluster tables (`BSEG` in `RFBLG`, `KONV`) | converted to transparent; joinable, and larger |
| secondary indexes were the tuning tool | mostly unnecessary; the column store is its own index; existing ones may be ignored |
| `SELECT *` was cheap-ish | costs every column's decompression; select what you need |
| aggregation was pushed to ABAP to spare the database | the reverse: `SUM`, `GROUP BY`, CDS, AMDP |
| table buffering made small tables fast | still applies, and matters less |
| native SQL for vendor features | AMDP and CDS table functions instead |

The **golden rules** SAP publishes for HANA-oriented ABAP are the ones on the [Open SQL](../open_sql/README.md) and [Performance](../performance/README.md) pages with the emphasis moved: fewer round trips, fewer columns, fewer rows, and the calculation next to the data.

## Why it earns a page

Because the `ORDER BY` change is a *correctness* break, not a performance one, and it surfaces only with real data volumes; and because a team that learned to avoid aggregates on Oracle will avoid them on HANA out of habit, where they are now the right answer.

## What this page still needs

- [ ] the `ORDER BY` break demonstrated with a program run on a HANA and a non-HANA system, both recorded
- [ ] the SQL trace of an aggregate on HANA versus in ABAP, on real volumes
- [ ] the SAP golden-rules list, each mapped to a page here

## See also

- [Open SQL](../open_sql/README.md) — the statements
- [AMDP and code pushdown](../amdp_and_code_pushdown/README.md) — the strategy's last step
- [CDS views](../cds_views/README.md) — its usual step
- [S/4HANA custom code migration](../s4hana_custom_code/README.md) — finding the breaks
- [Performance](../performance/README.md) — measuring
