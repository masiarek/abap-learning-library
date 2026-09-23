# How ABAP runs — work processes, dialog steps, and the application server

**Level:** 201 · working knowledge

**Status:** stub — the model is here; the measurements are not yet.

**One line:** An ABAP program does not own a process: a **dispatcher** hands each dialog step to whichever **work process** is free, the program's memory is rolled in and out around it, and the database, the enqueue server and the message server are separate processes — which is why "the same program, a different server" can behave differently and why nothing in ABAP is a thread.

## The pieces

| Piece | Does |
|---|---|
| Application server instance | one dispatcher plus its work processes; a system has one or more |
| Dialog work process (`DIA`) | runs a dialog step, then is free for anyone; limited by `rdisp/max_wp_run_time` |
| Background (`BTC`) | runs a job step, no time limit |
| Update (`UPD`, `UP2`) | runs the update task's registered calls after `COMMIT WORK` |
| Enqueue (`ENQ`) | holds the lock table — one per system, the enqueue server |
| Spool (`SPO`) | printing |
| Gateway | RFC in and out |
| ICM | HTTP in and out |
| Message server | tells instances about each other; logon balancing |
| Roll area, extended memory, heap | where a session's data lives between steps and during them |

`SM50` shows one server's work processes; `SM66` all of them; `SM51` the instances; `ST02` the buffers; `ST06` the host.

## What it explains

- **Per-server state.** Table buffers, shared objects and `STATICS` in function groups live in one instance's memory. See [Table types and buffering](../table_types_and_buffering/README.md).
- **`rdisp/max_wp_run_time`.** A dialog step past the limit is killed with `TIME_OUT`; the same code in a job is not. That is the reason long work goes to [background jobs](../background_jobs/README.md).
- **No threads.** Parallelism is more work processes — see [Parallel processing](../parallel_processing/README.md).
- **The dialog step is the LUW boundary.** A screen change rolls the session out and commits. See [LUW and locking](../luw_and_locking/README.md).

## What this page still needs

- [ ] `SM50` during a running report, recorded, with the memory columns explained
- [ ] the roll-in / roll-out sequence in one diagram
- [ ] what changes with HANA, and what does not

## See also

- [Background jobs](../background_jobs/README.md) — the `BTC` process
- [LUW and locking](../luw_and_locking/README.md) — `UPD` and `ENQ`
- [Performance](../performance/README.md) — the monitors above, used
- [Debugging](../debugging/README.md) — `SM50` → debug a running process
