# BOPF — the Business Object Processing Framework

**Level:** 301 · deep dive

**Status:** stub — for maintainers; no new development is planned on it.

**One line:** BOPF was SAP's business-object framework before RAP — nodes, actions, determinations, validations and a transaction manager, generated from a model in `BOBX` — and it survives in S/4HANA under many applications, so a maintainer needs the vocabulary even though [RAP](../rap/README.md) is where the same ideas live now.

## The vocabulary, mapped to RAP

| BOPF | Means | RAP equivalent |
|---|---|---|
| Business object, root node, sub-nodes | the data model, a tree | CDS root entity and compositions |
| Action | a callable operation on a node | `action` in the behaviour definition |
| Determination | derived data, computed at defined times | `determination` |
| Validation | a check that can reject | `validation` |
| Association | navigation between nodes | CDS association / composition |
| Service manager (`/BOBF/IF_TRA_SERVICE_MANAGER`) | the API to read, modify, execute | EML (`READ ENTITIES`, `MODIFY ENTITIES`) |
| Transaction manager | save, cleanup | the RAP save sequence |
| Consumer proxy / BOPF-based CDS | consumption | the RAP service |

## What a maintainer meets

Most of the code is generated; the parts a developer wrote are the determination, validation and action classes, each implementing a `/BOBF/IF_FRW_*` interface with `execute`/`check` methods that receive keys and read through the `io_read` object. Debugging starts from those, and from the `BOBT` test tool. Enhancing an SAP-delivered BOPF object is done through its enhancement workbench (`BOBX` → enhancement), not by editing the generated classes.

## What this page still needs

- [ ] a determination class, minimal, with the interface explained
- [ ] `BOBT` used to read and modify one node, recorded
- [ ] a straight before/after of one object in BOPF and in RAP

## See also

- [RAP](../rap/README.md) — the successor
- [CDS views](../cds_views/README.md) — the model layer both share
- [Object-oriented ABAP](../oo_abap/README.md) — the interface-implementation shape
- [LUW and locking](../luw_and_locking/README.md) — what the transaction manager was managing
