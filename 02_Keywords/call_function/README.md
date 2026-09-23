# `CALL FUNCTION` — function modules, remote or not

**Level:** 201 · working knowledge

**Status:** stub — the shape is here; the worked program is not yet.

**One line:** `CALL FUNCTION` invokes a function module with named parameter blocks, its **classic** exceptions arrive as `sy-subrc` values you assign yourself, and the additions `DESTINATION`, `IN BACKGROUND TASK` and `STARTING NEW TASK` change it from a call into a remote, queued or parallel one.

## What it does

```abap
CALL FUNCTION 'BAPI_COMPANYCODE_GETDETAIL'
  EXPORTING  companycodeid = lv_bukrs
  IMPORTING  companycode_detail = ls_detail
  TABLES     return = lt_return
  EXCEPTIONS communication_failure = 1
             system_failure        = 2
             OTHERS                = 3.
IF sy-subrc <> 0.
  " and now you have to decide what 1, 2 and 3 meant
ENDIF.
```

The directions mirror the module's own signature, and are the reverse of the method's point of view: what the caller *exports* is what the module *imports*. `TABLES` is a parameter kind that methods do not have — it is obsolete for new function modules and unavoidable in old ones and in most BAPIs.

Classic exceptions are numbers you choose at the call site. Omit the `EXCEPTIONS` block entirely and an exception the module raises becomes a short dump; write `OTHERS = 99` and never test `sy-subrc` and it becomes silence.

## Where it still matters

New code should be a class — but BAPIs, RFC-enabled modules, most of SAP's own APIs and every update-task call are function modules, so `CALL FUNCTION` is not going anywhere. The additions are the interesting part:

- `DESTINATION 'SYS'` — the call runs in another system (`SM59`), synchronously.
- `IN BACKGROUND TASK` — queued, executed at the next `COMMIT WORK`. See [LUW and locking](../../03_Topics/luw_and_locking/README.md).
- `STARTING NEW TASK` — asynchronous, with a callback; the ABAP way to parallelise.
- `CALL FUNCTION lv_name` — the name in a variable, resolved at runtime.

## What this page still needs

- [ ] a `snippets/` program calling a function module with a full `EXCEPTIONS` block
- [ ] the `BAPIRET2` handling pattern, with `BAPI_TRANSACTION_COMMIT`
- [ ] `STARTING NEW TASK` with a real callback, and what happens to its errors
- [ ] how to read a function module's signature quickly in `SE37` / ADT

## See also

- [BAPIs and RFC](../../03_Topics/bapis_and_rfc/README.md) — the topic page
- [`METHODS` and parameters](../methods/README.md) — the modern equivalent of this signature
- [`TRY`, `CATCH`, `RAISE`](../try_catch/README.md) — class-based exceptions, and why classic ones are different
- [LUW and locking](../../03_Topics/luw_and_locking/README.md) — `IN BACKGROUND TASK` and the update task
- [`GET BADI` and `CALL BADI`](../get_badi/README.md) — calling an enhancement spot
- [Parallel processing](../../03_Topics/parallel_processing/README.md) — `STARTING NEW TASK`, bgRFC, server groups
- [Number ranges](../../03_Topics/number_ranges/README.md) — the next document number, and the gaps
