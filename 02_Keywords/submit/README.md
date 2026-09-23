# `SUBMIT` — running another program

**Level:** 201 · working knowledge

**One line:** `SUBMIT prog` runs an executable program from inside this one, passing selection-screen values by name — `AND RETURN` comes back afterwards, `EXPORTING LIST TO MEMORY` captures its output instead of showing it, and `VIA JOB` schedules it in the background.

## The forms that matter

```abap
SUBMIT z_report AND RETURN.                                  " run, come back
SUBMIT z_report WITH p_carr = 'AA' WITH s_date IN lt_range AND RETURN.
SUBMIT z_report USING SELECTION-SET 'MONTHLY' AND RETURN.    " a saved variant
SUBMIT z_report EXPORTING LIST TO MEMORY AND RETURN.         " capture the list
SUBMIT z_report VIA JOB lv_name NUMBER lv_number AND RETURN. " inside JOB_OPEN/JOB_CLOSE
```

Without `AND RETURN`, the current program **ends** and the submitted one takes over — occasionally intended, usually a bug.

Parameters are matched by the called program's names, and `WITH … IN` takes a ranges table for a `SELECT-OPTIONS`. `VIA SELECTION-SCREEN` shows the called program's screen first so the user completes it.

## Why it earns a page

`SUBMIT … EXPORTING LIST TO MEMORY` followed by `LIST_FROM_MEMORY` and `LIST_TO_ASCI` is how a generation of ABAP reused a report as a data source: run it, scrape its list. It works, it is fragile — a changed column width breaks the caller — and it is still everywhere. The class-based alternative is to move the logic into a method that returns a table, which is the same refactoring [ABAP Unit](../../03_Topics/abap_unit/README.md) asks for.

The other recurring use is a wrapper report that runs several others in sequence for a job — legitimate, and worth a `RETURN` check on `sy-subrc` after each, because a submitted program that ends with an `E` message ends *this* one's job step too.

<!-- snippet:z_kw_submit -->
*[`z_kw_submit.prog.abap`](snippets/z_kw_submit.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_submit.

" SUBMIT runs another executable program. AND RETURN comes back here when it
" finishes; without it, control never comes back at all.
SUBMIT z_kw_data AND RETURN.
WRITE: / 'back from z_kw_data'.

" Parameters and select-options are passed by their names on the called
" program's selection screen.
SUBMIT z_kw_select WITH p_carr = 'AA' AND RETURN.
WRITE: / 'back from z_kw_select'.

" EXPORTING LIST TO MEMORY keeps the called report's list off the screen so
" the caller can read it back (function module LIST_FROM_MEMORY). It is the
" pre-object way to reuse a report as a data source, and still common.
SUBMIT z_kw_data EXPORTING LIST TO MEMORY AND RETURN.
WRITE: / 'list captured in memory, not displayed'.

" VIA SELECTION-SCREEN shows the called program's screen first, so the user
" fills it in; USING SELECTION-SET runs a saved variant instead.
SUBMIT z_kw_select VIA SELECTION-SCREEN AND RETURN.
WRITE: / 'and back again'.
```
<!-- /snippet -->

## If you are coming from another language

- **Shell.** `SUBMIT … AND RETURN` is running a script and waiting for it; `EXPORTING LIST TO MEMORY` is capturing its stdout. Without `AND RETURN` it is `exec`.
- **Python / Java.** There is no equivalent of loading a whole program as a callable; the nearest is a subprocess, with the same argument-by-name marshalling.

## See also

- [`CALL TRANSACTION`](../call_transaction/README.md) — running a transaction rather than a report
- [`PARAMETERS` and `SELECT-OPTIONS`](../parameters_select_options/README.md) — what the `WITH` clauses are filling
- [Background jobs](../../03_Topics/background_jobs/README.md) — `VIA JOB`, and what the called report may not do there
- [`EXPORT` and `IMPORT`](../export_import/README.md) — the memory the list lands in, and the general mechanism
