# `RETRY`, `RESUME`, `RESUMABLE` — going back after an exception

**Level:** 301 · deep dive

**Status:** stub — the shapes are here; the worked program is not yet.

**One line:** `RETRY` inside a `CATCH` runs the whole `TRY` block again; `RESUME` continues *after the statement that raised*, which is only possible if the exception was raised `RESUMABLE` and caught `BEFORE UNWIND` — a mechanism for "log it and carry on" that almost nobody uses and that is exactly right for a batch that must not stop on one bad row.

## The two shapes

```abap
TRY.
    lo_conn->send( ).
  CATCH zcx_transient INTO DATA(lx).
    lv_attempts = lv_attempts + 1.
    IF lv_attempts < 3.
      RETRY.                          " the TRY block runs again from the top
    ENDIF.
ENDTRY.

TRY.
    lo_batch->post_all( ).            " raises RESUMABLE per bad row
  CATCH BEFORE UNWIND zcx_bad_row INTO DATA(lx_row).
    lo_log->add( lx_row ).
    RESUME.                           " back inside post_all, after the RAISE
ENDTRY.
```

`RAISE RESUMABLE EXCEPTION TYPE …` is what makes `RESUME` legal, and `CATCH BEFORE UNWIND` is what keeps the raising context alive long enough to go back to. Without both, `RESUME` is a syntax error.

## Why it earns a page

A loop that posts a thousand documents has two bad choices without this: stop at the first failure, or wrap every iteration in its own `TRY`. `RESUMABLE` gives a third — the method raises, the caller decides, the method continues — with the exception object recording each problem. It is the right design for tolerant batch processing, and rare enough that a colleague meeting it will need the comment.

`RETRY` has its own trap: a `TRY` block that re-runs must be safe to re-run. A partial write before the exception is executed twice.

## What this page still needs

- [ ] a `snippets/` program with a resumable exception (once a local `CX_STATIC_CHECK` subclass can be checked here)
- [ ] `IS_RESUMABLE` on the exception object, and what the debugger shows at the `RESUME`
- [ ] a recorded run of `RETRY` with a counter, including the double-write trap

## See also

- [`TRY`, `CATCH`, `RAISE`](../try_catch/README.md) — the ordinary mechanism
- [Exceptions](../../03_Topics/exceptions/README.md) — designing the failure
- [Application log](../../03_Topics/application_log/README.md) — where "log it and carry on" logs to
- [Background jobs](../../03_Topics/background_jobs/README.md) — the batch that must not stop
