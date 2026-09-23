# `BREAK-POINT`, `LOG-POINT`, `ASSERT ID` — checkpoint groups

**Level:** 201 · working knowledge

**Status:** stub — the shapes are here; the worked program is not yet.

**One line:** `BREAK-POINT` in source stops the debugger for whoever runs the program — including a background job, where it dumps instead — while `BREAK-POINT ID group`, `LOG-POINT ID group` and `ASSERT ID group` are switched on and off per system, user and group in transaction `SAAB`, so a debugging aid can stay in shipped code without ever firing in production.

## The forms

```abap
BREAK-POINT.                       " always; and transported if you forget it
BREAK lv_user.                     " only for that user name (obsolete form)
BREAK-POINT ID zfin_posting.       " only when the group is active in SAAB
LOG-POINT ID zfin_posting SUBKEY 'doc' FIELDS lv_belnr lv_amount.
ASSERT ID zfin_posting CONDITION lv_total = 0.
```

A **checkpoint group** is a repository object (`SAAB`) with three switches: breakpoints, log points, assertions. Each can be *inactive*, *break*, *log* or *abort*, per user or globally, with an expiry. A `LOG-POINT` that is active writes its fields to a log you read in the same transaction — a trace you can turn on in production without a transport.

## Why it earns a page

A bare `BREAK-POINT` left in code reaches production in a transport and stops a job with `BREAK-POINT` runtime error. The ATC flags it; the checkpoint-group forms are the answer that lets the aid stay. The other reason: `LOG-POINT` is the cheapest production diagnostic there is — no application-log setup, no file, switchable by an administrator.

## What this page still needs

- [ ] a `snippets/` program with all three forms under one group
- [ ] the `SAAB` screen, what each activation setting does, and the log it produces, recorded
- [ ] what a bare `BREAK-POINT` does in a background job, recorded

## See also

- [`ASSERT`](../assert/README.md) — assertions, with and without a group
- [Debugging](../../03_Topics/debugging/README.md) — the debugger itself
- [Application log](../../03_Topics/application_log/README.md) — the heavier-weight log
- [ATC and Code Inspector](../../03_Topics/atc_and_code_inspector/README.md) — the check that catches a stray breakpoint
