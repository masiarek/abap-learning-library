# ABAP memory, SAP memory, shared objects — the memories between programs

**Level:** 201 · working knowledge

**Status:** stub — the map is here; the worked example is on the keyword page.

**One line:** Four places hold data outside a program's own variables — ABAP memory for the call stack, SAP memory for the logon session, the shared buffer and shared objects for the application server, and cluster tables for the database — and each has a different lifetime, a different visibility, and a different way to go stale.

## The map

| Memory | Scope | Lifetime | Access |
|---|---|---|---|
| ABAP memory | one session's call stack | until the stack unwinds or `FREE MEMORY` | `EXPORT`/`IMPORT … MEMORY ID` |
| SAP memory | one logon session, all windows | until logoff | `SET`/`GET PARAMETER ID` |
| Shared buffer | one application server | until displaced (LRU) | `EXPORT … TO SHARED BUFFER` |
| Shared memory / shared objects | one application server | until invalidated | `EXPORT … TO SHARED MEMORY`; area classes (`SHMA`) |
| Cluster table (`INDX` etc.) | the database | until deleted | `EXPORT … TO DATABASE` |
| Function group global data | one session | while the group is loaded | ordinary variables |

Shared objects are the serious form of server-level caching: an **area** (`SHMA`) with a root class, versioned, read by many sessions and written under a lock, invalidated when the underlying data changes. They are how customizing caches are built properly, and they are per application server — which means a landscape with three servers has three copies that can disagree until each is refreshed.

## The rules of thumb

- Passing data to a program you `SUBMIT`: ABAP memory.
- Pre-filling a screen field: SAP memory, via the data element's parameter ID.
- Caching read-mostly data for everyone on a server: shared objects, with an invalidation strategy you can name.
- Anything that must be the same on every server: the database, not a memory.

## What this page still needs

- [ ] a shared-objects area built end to end, with the read/write locks shown
- [ ] what happens to each memory on a `COMMIT WORK`, a `LEAVE PROGRAM`, a logoff
- [ ] the `SHMM` monitor and what a stale area looks like

## See also

- [`EXPORT` and `IMPORT`](../../02_Keywords/export_import/README.md) — the statements, with a program
- [`SUBMIT`](../../02_Keywords/submit/README.md) — the caller ABAP memory serves
- [Modularization](../modularization/README.md) — function group global data
- [How ABAP runs](../how_abap_runs/README.md) — why "per application server" matters
