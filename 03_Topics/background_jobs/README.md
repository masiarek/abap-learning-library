# Background jobs — when nobody is watching the screen

**Level:** 201 · working knowledge

**Status:** stub — the differences are here; the worked example is not yet.

**One line:** A program running in the background has no screen, so anything that waits for input hangs or fails — `MESSAGE` types behave differently, frontend services are unavailable, and the job's only inputs are its variant and the system's own state.

## What changes

| In dialog | In background |
|---|---|
| `MESSAGE … TYPE 'I'` shows a box | cannot display — the step fails |
| `MESSAGE … TYPE 'W'` warns, user continues | behaves like `E` |
| `cl_gui_frontend_services` reads the user's PC | no frontend at all |
| A dialog step may run for `rdisp/max_wp_run_time` | no such limit |
| The user picks values | the variant does, saved earlier |
| Output appears on screen | goes to the spool |

`sy-batch` is how a program can tell. Using it to branch is legitimate; needing it in many places usually means output and logic are tangled.

## Running and watching

`SM36` schedules, `SM37` monitors, `SM35` is the batch-input relative. A job's log holds the messages; the spool holds the list. A job that "did nothing" has usually either failed on a selection-screen validation or run with a variant nobody checked.

For parallel work, `CALL FUNCTION … STARTING NEW TASK` inside a job spreads work across dialog work processes — with all the care that implies about locks, commits and error reporting, since a failing task has no caller to tell.

## What this page still needs

- [ ] a program that behaves correctly in both modes, with a recorded run of each
- [ ] what each `MESSAGE` type actually did in a job log, recorded rather than recalled
- [ ] job scheduling from ABAP (`JOB_OPEN`, `JOB_SUBMIT`, `JOB_CLOSE`)
- [ ] how to debug a job that has already run (`JDBG`), and one that is running now

## See also

- [`MESSAGE`](../../02_Keywords/message/README.md) — the type table, with the background column
- [Selection screens](../selection_screens/README.md) — variants, the job's only input
- [Debugging](../debugging/README.md) — debugging something you cannot start
- [File handling](../file_handling/README.md) — why the application server, not the PC
