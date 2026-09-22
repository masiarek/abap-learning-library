# LUW and locking — where a transaction really ends

**Level:** 301 · deep dive

**Status:** stub — the model is here; the worked example is not yet.

**One line:** SAP has two units of work — the **database LUW**, which ends at every commit, and the **SAP LUW**, which spans a user's whole dialog task — and the bridge between them is the update task, with `ENQUEUE` locks that are advisory: they only stop code that asks.

## The two LUWs

A database LUW ends at a `COMMIT WORK`, at a screen change, at an RFC call, and at the end of a dialog step. An SAP LUW is the business transaction — several dialog steps, one consistent change. Holding data across dialog steps and writing it all at the end is what the update task exists for: `CALL FUNCTION … IN BACKGROUND TASK` registers the work, and `COMMIT WORK` executes it.

`COMMIT WORK AND WAIT` blocks until the update has run, so the next statement sees the result and a failure is visible. Without `AND WAIT`, a failed update becomes an entry in `SM13` and the caller carries on believing it worked.

## Locks are advisory

`ENQUEUE_E…` sets a lock in the enqueue server; `DEQUEUE_E…` releases it, and so does every `COMMIT WORK`. The critical property: a lock only blocks code that **requests the same lock**. It is not a database lock, it does not stop a direct `UPDATE`, and it does not stop a program that forgot to ask. Consistency is a convention every program has to keep.

Lock objects are generated from `SE11`, and the lock modes (`E` exclusive, `S` shared, `X` exclusive non-cumulative) behave differently when the same program locks twice.

## What this page still needs

- [ ] a worked update-task scenario with `AND WAIT` and without, and what `SM13` shows after a failure
- [ ] a lock object built from scratch, with a second session demonstrating the block
- [ ] the implicit-commit list, checked against documentation for a named release
- [ ] the RAP transactional buffer beside this, since the rules there are the framework's

## See also

- [`COMMIT WORK` and `ROLLBACK WORK`](../../02_Keywords/commit_work/README.md) — the statements
- [`CALL FUNCTION`](../../02_Keywords/call_function/README.md) — `IN BACKGROUND TASK`
- [BAPIs and RFC](../bapis_and_rfc/README.md) — `BAPI_TRANSACTION_COMMIT`, and why it exists
- [RAP](../rap/README.md) — where the framework owns the transaction instead
