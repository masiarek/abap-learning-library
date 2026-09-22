# `COMMIT WORK` and `ROLLBACK WORK` — where the transaction ends

**Level:** 301 · deep dive

**Status:** stub — the shape is here; the worked program is not yet.

**One line:** `COMMIT WORK` ends the database LUW, writes everything since the last commit, and releases every lock the program holds — and the trap is everything else that commits implicitly: a screen change, an RFC call, a `MESSAGE` of certain types, or a function module you did not write.

## What it does

```abap
COMMIT WORK.            " commit, and carry on
COMMIT WORK AND WAIT.   " commit, and wait for the update task to finish
ROLLBACK WORK.          " discard everything since the last commit
```

`AND WAIT` matters whenever the next statement reads what was just written: without it, the update task may not have run yet and the read returns the old data. It is also what makes a failed update visible to the caller instead of silent.

Both statements release **all** the program's enqueue locks. A `COMMIT WORK` in the middle of a sequence that assumed a lock is held for its duration is a data-integrity bug that shows up only under concurrency. See [LUW and locking](../../03_Topics/luw_and_locking/README.md).

## Why it earns a page

The implicit commits are what catch people:

- A screen change (`CALL SCREEN`, a list displayed, `MESSAGE` types that wait for input) commits.
- A synchronous RFC call commits before it goes.
- Many SAP function modules commit inside, which is why `BAPI_TRANSACTION_COMMIT` exists at all — a BAPI deliberately does *not* commit, leaving the decision to you.

Writing to the database from inside a BAdI or a user exit is where this bites hardest: the surrounding transaction's commit is not yours to control, and a commit of your own there can leave SAP's own update half-written.

## What this page still needs

- [ ] a `snippets/` program using the update task and `AND WAIT`, with what each does to a subsequent read
- [ ] the full list of implicit commits, checked against SAP's documentation for a named release
- [ ] what `ROLLBACK WORK` does *not* undo: number ranges, exported memory, files
- [ ] the same story for a RAP transactional buffer, where the rules are different again

## See also

- [LUW and locking](../../03_Topics/luw_and_locking/README.md) — the topic page
- [`CALL FUNCTION`](../call_function/README.md) — `IN BACKGROUND TASK` and the update task
- [BAPIs and RFC](../../03_Topics/bapis_and_rfc/README.md) — `BAPI_TRANSACTION_COMMIT`
- [Background jobs](../../03_Topics/background_jobs/README.md) — where nobody is there to answer a dialog
