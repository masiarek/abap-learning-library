# Logical databases — `GET`, and why old HR and FI reports look strange

**Level:** 201 · working knowledge

**Status:** stub — for recognition; no new development is planned on it.

**One line:** A logical database (`SE36`) is a reusable data-retrieval program with a hierarchy of nodes, a shared selection screen and authorization checks; a report attaches to one in its attributes and receives records through `GET node` event blocks instead of writing `SELECT`s — the model behind classic HR (`PNP`), FI (`SDF`, `BRF`) and SD reporting, and obsolete for anything new.

## The model

```abap
REPORT z_hr_list.                 " attributes: logical database PNP
TABLES: pernr.
INFOTYPES: 0001, 0002.

GET pernr.                        " fires once per employee the LDB delivers
  rp_provide_from_last p0001 space pn-begda pn-endda.
  WRITE: / pernr-pernr, p0001-ename.

END-OF-SELECTION.
```

The selection screen is the LDB's, extended by the report's own `PARAMETERS`. Records arrive in hierarchy order (`GET pernr`, then `GET pernr LATE` after its children), and the LDB has already applied its authorization checks — which is the feature that kept HR reporting on it long after everywhere else moved.

## What a maintainer needs

- Which LDB the report uses (attributes), and its structure in `SE36`.
- That `GET` blocks are events: the code runs once per record, and the `END-OF-SELECTION` block after all of them.
- That `SUBMIT` and `CALL TRANSACTION` still work; that `LDB_PROCESS` calls an LDB from a program that is not attached to it; and that HR's `PNP`/`PNPCE` bring their own macros (`rp_provide_from_last`) which are [macros](../../02_Keywords/define_macro/README.md) in the ordinary sense.

## What this page still needs

- [ ] a minimal report on a demo LDB (`F1S` for the flight model), shown with its `GET` events
- [ ] the selection screen an LDB contributes, recorded
- [ ] `LDB_PROCESS` as the way to reuse one from a class

## See also

- [Report events](../../02_Keywords/report_events/README.md) — where `GET` fits
- [`SUBMIT`](../../02_Keywords/submit/README.md) — running an LDB report
- [Authorizations](../authorizations/README.md) — what the LDB checks for you
- [Obsolete declarations](../../02_Keywords/obsolete_declarations/README.md) — `TABLES` and `INFOTYPES`
