# BAPIs and RFC — calling into SAP, and out of it

**Level:** 201 · working knowledge

**Status:** stub — the rules are here; the worked example is not yet.

**One line:** A BAPI is a released, RFC-enabled function module with a documented interface and a `RETURN` table of `BAPIRET2` rows — and the two rules that separate working code from broken data are: read `RETURN` before believing anything worked, and call `BAPI_TRANSACTION_COMMIT` yourself, because a BAPI deliberately does not commit.

## The shape of every BAPI call

```abap
CALL FUNCTION 'BAPI_SOMETHING_CREATE'
  EXPORTING  header = ls_header
  TABLES     items  = lt_items
             return = lt_return.

IF line_exists( lt_return[ type = 'E' ] ) OR line_exists( lt_return[ type = 'A' ] ).
  CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
ELSE.
  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' EXPORTING wait = abap_true.
ENDIF.
```

`RETURN` rows carry `TYPE`, `ID`, `NUMBER`, `MESSAGE` and four variables — the same fields [`MESSAGE`](../../02_Keywords/message/README.md) leaves in `sy-msg…`. A BAPI that failed usually returns `sy-subrc = 0` and an `E` row, which is why checking `sy-subrc` alone is not checking anything.

`wait = abap_true` on the commit is the difference between "it will be saved" and "it is saved" for whatever reads next. See [`COMMIT WORK`](../../02_Keywords/commit_work/README.md).

## RFC, in and out

`DESTINATION` (maintained in `SM59`) sends the call to another system — synchronous, or `IN BACKGROUND TASK` for a queued one (tRFC/qRFC), or `STARTING NEW TASK` for asynchronous parallel work. Inbound, any function module marked *remote-enabled* can be called from outside SAP; that is what the NetWeaver RFC SDK, the Java connector and every integration tool are talking to.

Two things bite: an RFC call **commits** the current LUW before it goes, and a failing background task leaves an entry in `SM58` that somebody has to look at — errors are not raised to the caller, because by then there is no caller.

## What this page still needs

- [ ] a full worked BAPI call with `BAPIRET2` translated into a class-based exception
- [ ] `BAPI_TRANSACTION_COMMIT` with and without `wait`, and what a subsequent read sees
- [ ] `SM58`, `SMQ1`/`SMQ2` and what to do with a stuck queue
- [ ] where OData and RAP replace this for new integrations

## See also

- [`CALL FUNCTION`](../../02_Keywords/call_function/README.md) — the statement, with `DESTINATION`
- [`COMMIT WORK`](../../02_Keywords/commit_work/README.md) — why a BAPI does not commit
- [Exceptions](../exceptions/README.md) — turning `RETURN` into something a caller can handle
- [IDocs](../idocs/README.md) — the asynchronous, document-shaped alternative
