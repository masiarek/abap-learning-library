# `CALL TRANSACTION` and `LEAVE TO TRANSACTION` — running a transaction from code

**Level:** 201 · working knowledge

**Status:** stub — the forms are here; the worked program is not yet.

**One line:** `CALL TRANSACTION 'VA01'` starts a transaction from inside a program and returns when it ends; with `USING lt_bdc` it drives the transaction's screens from a batch-input table, which is how a generation of interfaces posted documents before BAPIs — and `LEAVE TO TRANSACTION` ends the current program and starts another, with no return.

## The forms

```abap
CALL TRANSACTION 'VA03' AND SKIP FIRST SCREEN.      " SET PARAMETER ID fills the first screen
CALL TRANSACTION 'VA01' USING lt_bdcdata MODE 'N' UPDATE 'S' MESSAGES INTO lt_messages.
LEAVE TO TRANSACTION 'SE38'.                        " no way back
CALL TRANSACTION 'VA03' WITH AUTHORITY-CHECK.       " 7.40+: check S_TCODE explicitly
```

`AND SKIP FIRST SCREEN` works when every required field of the first screen was supplied through [SAP memory](../export_import/README.md) — the pattern behind every "jump to the document" hotspot in a report.

## Why it earns a page

The `USING` form is **batch input**: a table of screen, field and value rows that the runtime types into the transaction as if a user had. `MODE` `'A'` shows every screen, `'E'` shows only errors, `'N'` shows nothing. It is fragile — a screen change in a support package breaks it — and it is also the only way to post through some transactions that have no BAPI. See [Batch input and BDC](../../03_Topics/batch_input/README.md).

Since 7.40 the authorization check on the target transaction is **not** performed unless `WITH AUTHORITY-CHECK` is written or the default is configured otherwise — a program that jumps to a transaction the user may not run is a security finding. See [Authorizations](../../03_Topics/authorizations/README.md).

## What this page still needs

- [ ] a `snippets/` program with `SET PARAMETER ID` and `AND SKIP FIRST SCREEN` against a demo transaction
- [ ] a small `BDCDATA` table built by hand, with the recording (`SHDB`) that produced it
- [ ] `MESSAGES INTO` and what the message table contains after a failed posting

## See also

- [`SUBMIT`](../submit/README.md) — the same idea for a report
- [`EXPORT` and `IMPORT`](../export_import/README.md) — `SET PARAMETER ID`, which fills the first screen
- [Batch input and BDC](../../03_Topics/batch_input/README.md) — the `USING` form in full
- [Dynpro screens](../../03_Topics/dynpro_screens/README.md) — what a transaction is made of
- [Authorizations](../../03_Topics/authorizations/README.md) — the check `CALL TRANSACTION` skips by default
