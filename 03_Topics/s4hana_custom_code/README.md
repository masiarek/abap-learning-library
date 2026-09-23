# S/4HANA custom code migration — what breaks, and how to find it first

**Level:** 301 · deep dive

**Status:** stub — the method is here; a worked run is not yet.

**One line:** Moving custom code to S/4HANA breaks it in three ways — the data model simplified under it (`MATNR` is 40 characters, `KONV` is `PRCD_ELEMENTS`, `BSEG` reads go to `ACDOCA`), HANA changed what a `SELECT` returns in what order, and ABAP Cloud rules may apply — and the ATC with the *S4HANA_READINESS* variant, fed by the Simplification Database, finds nearly all of it before the conversion does.

## The three kinds of break

| Kind | Example | Found by |
|---|---|---|
| Simplification items | field length changes (`MATNR`), tables replaced (`KONV`, `VBUK`/`VBUP` status fields), transactions removed | ATC `S4HANA_READINESS`, Simplification Database (`SYCM`) |
| HANA behaviour | `SELECT` without `ORDER BY` returning rows in a different order; pooled/cluster tables now transparent; `SELECT … UP TO 1 ROWS` versus `SINGLE` | ATC *SAP HANA* checks; code review of every `SELECT` a sort was assumed on |
| ABAP Cloud / released APIs | unreleased tables and function modules, `FORM`s, dynpros — **only** if the cloud model is the target | ATC *ABAP for Cloud Development* variant |

The **Custom Code Migration** Fiori app (on a 1909+ central check system) runs the same checks across a whole landscape and estimates effort; the older path is `SYCM` plus the ATC.

## The method

1. **Scope first.** Usage data (`SUSG`, `SCMON`) says which of the 12,000 custom objects actually ran last year. Half are usually dead; delete before converting.
2. **Run the ATC** with the readiness variant on a system that has the Simplification Database loaded. Every finding links to a note.
3. **Fix by category**, not by object: one `MATNR` length pattern fixed everywhere at once.
4. **Re-run** until green; keep the exemptions honest.

## What this page still needs

- [ ] a small readiness run over a demo package, with real findings, recorded
- [ ] the `MATNR` length change worked through: declaration, screen, interface
- [ ] `KONV` → `PRCD_ELEMENTS` as the model of a table replacement, with the compatibility view

## See also

- [ATC and Code Inspector](../atc_and_code_inspector/README.md) — the tool
- [HANA specifics](../hana_specifics/README.md) — the second kind of break
- [ABAP Cloud](../abap_cloud/README.md) — the third
- [Open SQL](../open_sql/README.md) — the `ORDER BY` assumption
