# `GET BADI`, `CALL BADI` — calling an enhancement spot

**Level:** 301 · deep dive

**Status:** stub — the shape is here; the worked program is not yet.

**One line:** For a new-style BAdI, `GET BADI lo_badi` obtains the handle and `CALL BADI lo_badi->method` runs every active implementation whose filter matches — statements, not method calls, because the kernel resolves the implementations — and `cl_exithandler=>get_instance` is the same idea for the classic BAdIs you will meet in older code.

## The shapes

```abap
DATA lo_badi TYPE REF TO zbadi_pricing.
GET BADI lo_badi FILTERS country = lv_country.
CALL BADI lo_badi->adjust_price
  EXPORTING iv_material = lv_matnr
  CHANGING  cv_price    = lv_price.
```

`GET BADI` raises `CX_BADI_NOT_IMPLEMENTED` when no implementation exists and the BAdI is not marked as optional, and `CX_BADI_MULTIPLY_IMPLEMENTED` when a single-use BAdI has two active implementations — both worth catching deliberately rather than by `cx_root`.

The classic form:

```abap
DATA lo_exit TYPE REF TO if_ex_zbadi_pricing.
CALL METHOD cl_exithandler=>get_instance CHANGING instance = lo_exit.
lo_exit->adjust_price( … ).
```

## Why it earns a page

You will *implement* BAdIs far more often than define them, but reading the calling side is how you find out whether an enhancement will run: a breakpoint on `GET BADI` or `cl_exithandler=>get_instance` inside the standard transaction is the standard technique. See [Enhancements and BAdIs](../../03_Topics/enhancements_and_badis/README.md).

## What this page still needs

- [ ] a BAdI defined, implemented with a filter, and called, end to end (definition and implementation are repository objects, so this needs a system)
- [ ] the two exception cases recorded
- [ ] the debugger technique, step by step

## See also

- [Enhancements and BAdIs](../../03_Topics/enhancements_and_badis/README.md) — the topic page
- [`ENHANCEMENT-POINT`](../enhancement_point/README.md) — the source-level hooks
- [`CALL FUNCTION`](../call_function/README.md) — customer exits, the older mechanism
- [Debugging](../../03_Topics/debugging/README.md) — finding the hook
