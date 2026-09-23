# `EXPORT` and `IMPORT` — ABAP memory, SAP memory, and the shared buffer

**Level:** 201 · working knowledge

**One line:** `EXPORT … TO MEMORY ID` stashes data objects for the duration of the call stack and `IMPORT … FROM MEMORY ID` reads them back — the way a program hands data to the report it `SUBMIT`s — while `SET`/`GET PARAMETER ID` is a different memory again, one value per key for the whole logon session.

## Three memories, three lifetimes

| Memory | Statements | Lives for | Used for |
|---|---|---|---|
| **ABAP memory** | `EXPORT`/`IMPORT … TO/FROM MEMORY ID` | this session's call stack: the program and everything it `SUBMIT`s or `CALL TRANSACTION`s | passing structured data to a called program |
| **SAP memory** | `SET PARAMETER ID` / `GET PARAMETER ID` | the whole logon session, every window | pre-filling screen fields (the *parameter ID* on a data element) |
| **Shared buffer / shared memory** | `EXPORT … TO SHARED BUFFER` / `SHARED MEMORY`, or shared objects | the application server, across users | a cross-session cache |

`EXPORT … TO DATABASE` is the fourth, writing to a cluster table such as `INDX` — persistence for a data object without a table definition, which is how many SAP tools store settings.

## The rules

- `EXPORT` and `IMPORT` must name the **same objects under the same names**; the types must match. A mismatch is `CX_SY_IMPORT_MISMATCH_ERROR`, a missing ID is `sy-subrc = 4`, and in the second case the targets are left untouched.
- `FREE MEMORY ID` releases it. Nothing else does until the stack unwinds.
- SAP memory holds one **character** value per ID, no structures. Its IDs are three-character keys defined on data elements (`MAT` for material, `BUK` for company code, `CAR` for carrier); a `GET PARAMETER` on an ID nobody set yields blank and `sy-subrc = 4`.

## Where each goes wrong

ABAP memory is a hidden parameter list: a program that `IMPORT`s expects a caller that `EXPORT`ed, and nothing in the signature says so. It is worth a comment at both ends. SAP memory is per user and per session, so a value set in one window appears in another — which is what makes it useful for screen defaults and dangerous for anything else. The shared buffer is per application server, so two users on different servers see different caches; a value that must be the same everywhere belongs in the database.

<!-- snippet:z_kw_export_import -->
*[`z_kw_export_import.prog.abap`](snippets/z_kw_export_import.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_export_import.

TYPES ty_names TYPE STANDARD TABLE OF string WITH EMPTY KEY.

DATA(lt_names) = VALUE ty_names( ( `Ada` ) ( `Grace` ) ).
DATA(lv_count) = lines( lt_names ).

" ABAP memory: lives as long as this session's call stack -- this program and
" anything it SUBMITs or CALL TRANSACTIONs. Several objects under one ID.
EXPORT names = lt_names
       count = lv_count
       TO MEMORY ID 'ZKW_DEMO'.

DATA lt_back TYPE ty_names.
DATA lv_back TYPE i.
IMPORT names = lt_back
       count = lv_back
       FROM MEMORY ID 'ZKW_DEMO'.
WRITE: / 'from ABAP memory', lv_back, lines( lt_back ).

" A miss is sy-subrc 4, not an exception, and the targets keep their values.
IMPORT names = lt_back FROM MEMORY ID 'NO_SUCH_ID'.
WRITE: / 'unknown id ->', sy-subrc.

FREE MEMORY ID 'ZKW_DEMO'.

" SAP memory: one value per parameter ID for the whole logon session, across
" programs and transactions. It is what pre-fills a screen field with the
" value you used last time.
SET PARAMETER ID 'CAR' FIELD 'LH'.
DATA lv_carrier TYPE scarr-carrid.
GET PARAMETER ID 'CAR' FIELD lv_carrier.
WRITE: / 'from SAP memory', lv_carrier.
```
<!-- /snippet -->

## If you are coming from another language

- **Environment variables.** SAP memory is closest: string-valued, session-wide, set by anyone.
- **A process-local dict passed to a subprocess.** ABAP memory, roughly — with the type check at the receiving end.
- **memcached.** The shared buffer, per server.

## See also

- [`SUBMIT`](../submit/README.md) — the caller that fills ABAP memory
- [`CALL TRANSACTION`](../call_transaction/README.md) — the other caller, and `SET PARAMETER` for its first screen
- [ABAP memory and SAP memory](../../03_Topics/abap_memory_and_sap_memory/README.md) — the topic page, with the shared-objects side
- [Selection screens](../../03_Topics/selection_screens/README.md) — where a parameter ID pre-fills a field
