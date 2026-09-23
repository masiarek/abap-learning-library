# Asking what time it is — `GET TIME`, `GET RUN TIME`, `GET TIME STAMP`, `WAIT`

**Level:** 201 · working knowledge

**One line:** `sy-datum` and `sy-uzeit` are set when the program starts and refreshed only by `GET TIME`; `GET RUN TIME FIELD` gives microseconds for timing a block; `GET TIME STAMP FIELD` gives a UTC timestamp; and `WAIT UP TO n SECONDS` pauses politely — and commits the database LUW while it does.

## The four

| Statement | Gives | Note |
|---|---|---|
| `GET TIME.` | refreshes `sy-datum`, `sy-uzeit`, `sy-timlo`, `sy-datlo`, `sy-zonlo` | a job that never calls it prints its start time at the end |
| `GET RUN TIME FIELD lv.` | microseconds since the first call | subtract two readings to time a block |
| `GET TIME STAMP FIELD lv.` | `TIMESTAMP` or `TIMESTAMPL` in UTC | the unambiguous one; see [Dates and times](../../03_Topics/dates_and_times/README.md) |
| `WAIT UP TO n SECONDS.` | pauses, releasing the work process | **implicit database commit** |

The `WAIT` commit is the fact people learn the hard way: a `WAIT` inside a sequence that assumed an open LUW commits half of it. `WAIT FOR ASYNCHRONOUS TASKS` (with `STARTING NEW TASK`) and `WAIT FOR MESSAGING CHANNELS` are the same statement with the same side effect.

## Timing honestly

`GET RUN TIME` is the right tool for "is A faster than B" in a program, with two cautions: the first execution of anything includes loading and buffering costs, so measure the second run; and a difference of a few hundred microseconds is noise on a shared server. For anything that matters, the [trace tools](../../03_Topics/performance/README.md) measure the whole call, including the database.

<!-- snippet:z_kw_get_time -->
*[`z_kw_get_time.prog.abap`](snippets/z_kw_get_time.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_get_time.

" sy-datum and sy-uzeit are set when the program starts and refreshed only by
" GET TIME. A job that prints sy-uzeit at the end prints its START time
" unless something asked again in between.
WRITE: / 'at start ', sy-uzeit.
GET TIME.
WRITE: / 'refreshed', sy-uzeit.

" GET RUN TIME FIELD: microseconds since the first call in this program. The
" cheapest way to time a block -- and a measurement, which beats a guess.
DATA lv_t0 TYPE i.
DATA lv_t1 TYPE i.
DATA lv_sum TYPE i.
GET RUN TIME FIELD lv_t0.
DO 100000 TIMES.
  lv_sum = lv_sum + sy-index.
ENDDO.
GET RUN TIME FIELD lv_t1.
DATA(lv_took) = lv_t1 - lv_t0.
WRITE: / 'loop took (microseconds)', lv_took.

" A time stamp is wall-clock time in UTC, independent of who is logged on and
" from where. See the dates and times topic for turning it back into a date.
GET TIME STAMP FIELD DATA(lv_stamp).
WRITE: / 'utc time stamp', lv_stamp.

" WAIT UP TO releases the work process rather than spinning -- and it also
" ends the database LUW with an implicit commit, which is the fact to know.
WAIT UP TO 1 SECONDS.
GET TIME.
WRITE: / 'after wait', sy-uzeit.
```
<!-- /snippet -->

## If you are coming from another language

- **Python.** `time.perf_counter()` is `GET RUN TIME`; `datetime.now()` is `GET TIME`; `time.sleep()` is `WAIT UP TO` — minus the commit.
- **Everywhere.** Wall clock versus monotonic clock is the same distinction as `sy-uzeit` versus `GET RUN TIME`.

## See also

- [Dates and times](../../03_Topics/dates_and_times/README.md) — the types, and time zones
- [`sy` fields](../sy_fields/README.md) — what `GET TIME` refreshes
- [Performance](../../03_Topics/performance/README.md) — measuring properly
- [`COMMIT WORK`](../commit_work/README.md) — the commit `WAIT` triggers
- [Parallel processing](../../03_Topics/parallel_processing/README.md) — `WAIT FOR ASYNCHRONOUS TASKS`
