# `RAISE SHORTDUMP` — ending the program on purpose, with a dump

**Level:** 301 · deep dive

**Status:** stub — the shape is here; the worked program is not yet.

**One line:** Since 7.53, `RAISE SHORTDUMP TYPE zcx_fatal …` ends the program immediately with a runtime error that carries an exception object — the deliberate version of a short dump, for situations where continuing would corrupt data and no caller could sensibly recover.

## What it does

```abap
IF lv_balance_check <> 0.
  RAISE SHORTDUMP TYPE zcx_inconsistent_state
    EXPORTING iv_document = lv_belnr.
ENDIF.
```

The exception class must inherit from `CX_NO_CHECK`. Unlike `RAISE EXCEPTION`, nothing can catch this; unlike `ASSERT`, it carries typed attributes into the dump analysis (`ST22`), which is the point: the person reading the dump at 6 a.m. gets the document number, not `ASSERTION_FAILED`.

## Where it sits

| Mechanism | Catchable | Carries data | Use for |
|---|---|---|---|
| `RAISE EXCEPTION` | yes | yes | failures a caller can handle |
| `ASSERT` | no | no | invariants; a bug |
| `RAISE SHORTDUMP` | no | yes | an inconsistency that must stop everything and be diagnosable |
| `MESSAGE … TYPE 'X'` | no | message only | the pre-7.53 spelling of the same idea |

## What this page still needs

- [ ] a `snippets/` program, once a local `CX_NO_CHECK` subclass can be expressed here (abaplint cannot resolve the superclass)
- [ ] the `ST22` dump it produces, recorded, showing the attributes in the analysis
- [ ] the release note confirming 7.53

## See also

- [`ASSERT`](../assert/README.md) — the blunter relative
- [`TRY`, `CATCH`, `RAISE`](../try_catch/README.md) — the catchable mechanism
- [`MESSAGE`](../message/README.md) — type `X`
- [Short dumps](../../03_Topics/short_dumps/README.md) — reading what it produces
