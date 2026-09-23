# Application log — `BAL_LOG_CREATE`, `SLG1`, and messages that outlive the run

**Level:** 201 · working knowledge

**Status:** stub — the API is here; the worked example is not yet.

**One line:** The application log (`BAL_*` function modules, transaction `SLG1`) stores messages under an object and subobject with a timestamp, a user and an optional external ID, so a job that ran last night can be asked what it did — and the discipline is to log the message *and its variables*, not a formatted sentence.

## The API, in order

| Step | Function module |
|---|---|
| define the log object and subobject once | `SLG0` |
| open a log | `BAL_LOG_CREATE` with `BAL_S_LOG` (object, subobject, external number) |
| add a message | `BAL_LOG_MSG_ADD` with a `BAL_S_MSG` (msgid, msgno, msgty, msgv1–4) |
| add an exception | `BAL_LOG_EXCEPTION_ADD` |
| save | `BAL_DB_SAVE` — nothing is persisted until this, and it needs a `COMMIT WORK` |
| display | `BAL_DSP_LOG_DISPLAY`, or `SLG1` |

Newer code wraps this in `cl_bali_log` (ABAP Cloud's released API) — same model, class-based.

## Why it earns a page

Because a `WRITE` in a background job goes to a spool nobody reads, and a message collected into an internal table dies with the program. The application log is the mechanism support colleagues actually use: `SLG1`, filter by object and date, read the messages with their variables intact. A log written as pre-formatted text loses the message class and number that make it searchable and translatable — log the `BAL_S_MSG`, and let the display format it.

## What this page still needs

- [ ] a `snippets/` program writing a log with two message types and saving it
- [ ] the `SLG1` display of that log, recorded
- [ ] `cl_bali_log` beside the function modules
- [ ] log expiry and `SLG2` deletion, so a log object does not fill a table forever

## See also

- [`MESSAGE`](../../02_Keywords/message/README.md) — the pieces a `BAL_S_MSG` is made of
- [Background jobs](../background_jobs/README.md) — where logs matter most
- [`RETRY`, `RESUME`, `RESUMABLE`](../../02_Keywords/retry_resume/README.md) — "log it and carry on"
- [Checkpoint groups](../../02_Keywords/break_point_log_point/README.md) — the lighter-weight `LOG-POINT`
