# Table types and buffering — transparent, pooled, cluster, and the SAP table buffer

**Level:** 201 · working knowledge

**Status:** stub — the settings are here; the worked example is not yet.

**One line:** A Dictionary table is transparent (one database table), pooled or cluster (several logical tables packed into one physical one — largely gone on HANA), and its **technical settings** decide whether the application server caches it: a buffered table is read from memory without a database call, and a write from another server makes that memory stale for a while.

## The settings that matter

| Setting | Values | Consequence |
|---|---|---|
| Table type | transparent, pooled, cluster | pooled/cluster cannot be joined in Open SQL and are converted to transparent on HANA |
| Buffering | off; single record; generic (by leading key fields); full | what is cached per application server |
| Data class / size category | `APPL0`… | storage hints; ignored on HANA |
| Delivery class | `A` application, `C` customizing, `L` temporary… | what a client copy and a transport do with the rows |
| Log data changes | on/off | writes every change to `DBTABLOG` (`SCU3`) — for customizing tables, a compliance requirement |

Buffer synchronisation happens between servers every few seconds (`rdisp/bufreftime`), so a buffered table written on server A can be read stale on server B until then. `SELECT … BYPASSING BUFFER` reads the database regardless; and several Open SQL forms — joins, aggregates, `FOR ALL ENTRIES`, `DISTINCT` — bypass it whether you asked or not.

## Why it earns a page

Because "the customizing change did not take effect" on a multi-server system is the buffer, because a large, often-written table with full buffering is a performance bug in the technical settings rather than in any program, and because `SE11` → *Technical settings* is a screen developers change without a transport review. `ST10` shows what the buffer is actually doing.

## What this page still needs

- [ ] a `snippets/` program showing which `SELECT` forms bypass the buffer, checked in the SQL trace
- [ ] `ST10` for a buffered table, recorded
- [ ] delivery class `C` versus `A` on a client copy, worked through

## See also

- [DDIC, domains and data elements](../ddic_and_domains/README.md) — the rest of the Dictionary
- [Open SQL](../open_sql/README.md) — the statements that bypass the buffer
- [How ABAP runs](../how_abap_runs/README.md) — per-server memory
- [HANA specifics](../hana_specifics/README.md) — what changed for pooled and cluster tables
- [Table maintenance](../table_maintenance/README.md) — `SM30` on a customizing table
