# Parallel processing — `STARTING NEW TASK`, bgRFC, and server groups

**Level:** 301 · deep dive

**Status:** stub — the map is here; the worked example is not yet.

**One line:** ABAP has no threads; parallelism means more **work processes**, reached through asynchronous RFC (`CALL FUNCTION … STARTING NEW TASK … DESTINATION IN GROUP`) with a callback that collects results, or through queued bgRFC units the system processes when it can — and both raise every question about locks, commits and error reporting that a single process let you ignore.

## The forms

| Form | Runs | Results come back via | Good for |
|---|---|---|---|
| `STARTING NEW TASK … CALLING m ON END OF TASK` | now, on a free dialog process in a server group (`RZ12`) | the callback method; `WAIT FOR ASYNCHRONOUS TASKS` | splitting a big job across processes |
| `IN BACKGROUND TASK` (tRFC) | at `COMMIT WORK`, in order per LUW | not at all — check `SM58` | fire-and-forget updates to another system |
| bgRFC (`SBGRFCCONF`) | when the scheduler picks it up; queued or transactional | the unit's status | the modern queued form |
| `SUBMIT … VIA JOB` | as a background job | the job log | coarse parallelism by job |
| Parallel `SELECT` on HANA | the database | the result | often the answer instead |

The function module for the task form must be **remote-enabled**, gets its own LUW, and cannot share memory with the caller — parameters in, parameters back through the callback, nothing else.

## What goes wrong

- **Resource exhaustion.** Every task takes a dialog work process; the server group limits it, and a program that ignores `RESOURCE_FAILURE` starts tasks until the system is unusable.
- **Ordering and totals.** Callbacks arrive in any order; the collecting code must be re-entrant.
- **Locks.** Each task locks independently, so two tasks on the same document block each other or, worse, do not.
- **Errors.** A task that dumps reports it to the callback's `sy-subrc`, if anyone reads it.

## What this page still needs

- [ ] a `snippets/` program splitting a table across tasks, with the callback and the wait
- [ ] `RZ12` group setup, and `RESOURCE_FAILURE` handling recorded
- [ ] a bgRFC unit created and monitored, with what `SBGRFCMON` shows

## See also

- [`CALL FUNCTION`](../../02_Keywords/call_function/README.md) — the additions
- [BAPIs and RFC](../bapis_and_rfc/README.md) — tRFC and `SM58`
- [LUW and locking](../luw_and_locking/README.md) — what each task owns
- [How ABAP runs](../how_abap_runs/README.md) — work processes
- The [concurrency learning library](https://masiarek.github.io/concurrency-learning-library/) — the same problems in languages that do have threads
