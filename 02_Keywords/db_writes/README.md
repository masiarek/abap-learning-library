# `INSERT`, `UPDATE`, `MODIFY`, `DELETE` — writing to the database

**Level:** 201 · working knowledge

**One line:** The four Open SQL write statements change database rows inside the current LUW — nothing is durable until `COMMIT WORK` and everything can still be taken back by `ROLLBACK WORK` — and each reports through `sy-subrc` and `sy-dbcnt`, never through an exception, so a write that touched zero rows is silent unless you look.

## The four

| Statement | Does | On a key clash |
|---|---|---|
| `INSERT dbtab FROM @wa` | adds a row | `sy-subrc = 4`, nothing inserted |
| `UPDATE dbtab SET … WHERE …` | changes columns of matching rows | — |
| `MODIFY dbtab FROM @wa` | inserts, or updates if the key exists | never fails on the key, and never says which it did |
| `DELETE FROM dbtab WHERE …` | removes matching rows | — |

`sy-dbcnt` is the number of rows affected. An `UPDATE … WHERE` meant for one row that reports `sy-dbcnt = 0` did nothing, and one that reports `47` did far too much; both return `sy-subrc = 0`.

The table forms — `INSERT dbtab FROM TABLE @itab`, `UPDATE … FROM TABLE`, `DELETE … FROM TABLE` — write a whole internal table in one round trip, and `ACCEPTING DUPLICATE KEYS` on the `INSERT` makes the duplicates skip rather than abort the whole statement.

## What is not checked

- **Authorization.** Nothing. The [`AUTHORITY-CHECK`](../authority_check/README.md) is yours.
- **Business rules.** Nothing. Writing to a standard SAP table directly — `BKPF`, `MARA`, `KNA1` — bypasses every validation, every change document, every lock the standard transaction would have used. That is what BAPIs exist to prevent; see [BAPIs and RFC](../../03_Topics/bapis_and_rfc/README.md).
- **Locks.** Nothing. The database row lock is held until the commit, and the [enqueue lock](../../03_Topics/luw_and_locking/README.md) only if you set it.

Direct writes are correct on **your own** `Z` tables. On SAP's, they are the thing the auditor is looking for.

## The commit is a separate decision

The program below ends in `ROLLBACK WORK` so that running it changes nothing — which is also the demonstration: after four write statements, one rollback, and the table is exactly as it was. In real code the [`COMMIT WORK`](../commit_work/README.md) is placed deliberately, once, at the end of the unit of work, and not inside the loop that writes the rows.

<!-- snippet:z_kw_db_writes -->
*[`z_kw_db_writes.prog.abap`](snippets/z_kw_db_writes.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_db_writes.

" Every statement here targets the flight demo table SFLIGHT, and the program
" ends in ROLLBACK WORK, so running it changes nothing. That is the lesson as
" much as the setup: nothing is written until a COMMIT WORK, and everything
" since the last one can still be taken back.
DATA ls_flight TYPE sflight.

SELECT SINGLE * FROM sflight INTO @ls_flight.
IF sy-subrc <> 0.
  WRITE: / 'no demo data in SFLIGHT; nothing to show'.
  RETURN.
ENDIF.

" INSERT refuses a duplicate key: sy-subrc 4, no dump, nothing inserted.
INSERT sflight FROM @ls_flight.
WRITE: / 'insert of an existing key ->', sy-subrc.

" UPDATE by key, one column. sy-dbcnt says how many rows were touched, which
" is the number to check when a WHERE was meant to hit exactly one.
DATA(lv_more) = ls_flight-seatsocc + 1.
UPDATE sflight SET seatsocc = @lv_more
  WHERE carrid = @ls_flight-carrid
    AND connid = @ls_flight-connid
    AND fldate = @ls_flight-fldate.
WRITE: / 'rows updated', sy-dbcnt.

" MODIFY inserts or updates, whichever applies -- and does not say which.
ls_flight-seatsocc = ls_flight-seatsocc + 2.
MODIFY sflight FROM @ls_flight.
WRITE: / 'modify ->', sy-subrc.

" DELETE with a WHERE. A DELETE with no condition at all is a syntax error,
" which is the one guard rail the statement has.
DELETE FROM sflight
  WHERE carrid = @ls_flight-carrid
    AND connid = @ls_flight-connid
    AND fldate = @ls_flight-fldate.
WRITE: / 'rows deleted', sy-dbcnt.

ROLLBACK WORK.
WRITE: / 'rolled back: SFLIGHT is exactly as it was'.
```
<!-- /snippet -->

## If you are coming from another language

- **SQL.** These *are* SQL `INSERT`/`UPDATE`/`DELETE`, with `MODIFY` as the upsert most dialects spell `MERGE` or `ON CONFLICT`. The transaction is implicit and ends at `COMMIT WORK`.
- **ORMs.** No change tracking, no unit-of-work object, no flush: the statement runs when it is written. That is simpler to reason about and easier to get wrong by committing too early.

## See also

- [`SELECT`](../select/README.md) — the read side
- [`COMMIT WORK` and `ROLLBACK WORK`](../commit_work/README.md) — when the write becomes real
- [LUW and locking](../../03_Topics/luw_and_locking/README.md) — the update task, and why a BAdI must not commit
- [BAPIs and RFC](../../03_Topics/bapis_and_rfc/README.md) — the way to change SAP's own data
- [Change documents](../../03_Topics/change_documents/README.md) — what a direct write skips
