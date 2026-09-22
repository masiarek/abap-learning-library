# `TRY`, `CATCH`, `RAISE` — class-based exceptions

**Level:** 201 · working knowledge

**One line:** ABAP exceptions are objects, they come in three flavours that differ only in what the **compiler** demands of the caller — `CX_STATIC_CHECK` (declare or catch it), `CX_DYNAMIC_CHECK` (your problem at runtime), `CX_NO_CHECK` (nobody can be expected to handle it) — and choosing the wrong flavour is how an error ends up silently ignored.

## The three flavours

| Superclass | The compiler says | Use it for |
|---|---|---|
| `CX_STATIC_CHECK` | every caller must `CATCH` it or declare `RAISING` | a failure the caller can reasonably handle: invalid input, a business rule |
| `CX_DYNAMIC_CHECK` | nothing | a failure the caller could have prevented by checking first — division by zero, a bad cast |
| `CX_NO_CHECK` | nothing, and it propagates all the way up | a failure nobody can recover from: resource gone, configuration missing |

All three are caught the same way. The difference is entirely in what the compiler forces on whoever calls your method — which is a design decision about your API, not a technical one.

## Raising

```abap
RAISE EXCEPTION TYPE cx_sy_conversion_error.
RAISE EXCEPTION NEW zcx_too_big( iv_value = lv_value ).   " 7.52+
```

The second form is the modern one, and it makes the point that an exception is an **object**: it carries the facts of the failure — which value, which document, which row — in typed attributes. A message string cannot be tested, translated or acted on; an attribute can.

A custom exception class is written like this. It is shown rather than checked, because [abaplint cannot resolve `CX_STATIC_CHECK`](../README.md#what-the-machine-checks-here-and-what-it-cannot) without SAP's class library:

```abap
CLASS zcx_too_big DEFINITION INHERITING FROM cx_static_check.
  PUBLIC SECTION.
    METHODS constructor IMPORTING iv_value TYPE i.
    DATA mv_value TYPE i READ-ONLY.
ENDCLASS.
```

## Catching

```abap
TRY.
    lo_thing->risky( ).
  CATCH zcx_too_big INTO DATA(lx_big).
    " lx_big->mv_value has the facts
  CLEANUP.
    " runs only when the exception leaves this TRY unhandled
ENDTRY.
```

A `CATCH` for a superclass catches all of its subclasses, which is why `CATCH cx_root` is almost always wrong: it swallows programming errors — a wrong cast, a missing row, an arithmetic overflow — along with the one failure you meant to handle, and turns a dump into a wrong result.

`CLEANUP` runs when the exception is on its way *out* of this block. It does not run when the block ends normally, and it does not run when the exception is caught here. It is where you release what you acquired.

## The older machinery is still everywhere

Function modules raise **classic** exceptions, which are not objects at all: you list them under `EXCEPTIONS` in the `CALL FUNCTION` and read `sy-subrc` afterwards. Forget the list and the exception becomes a short dump; write `OTHERS = 99` and forget to check `sy-subrc` and it becomes silence. See [`CALL FUNCTION`](../call_function/README.md).

And `MESSAGE … TYPE 'E'` is a third mechanism again, which ends the current step rather than raising anything. See [`MESSAGE`](../message/README.md).

<!-- snippet:z_kw_try_catch -->
*[`z_kw_try_catch.prog.abap`](snippets/z_kw_try_catch.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_try_catch.

START-OF-SELECTION.

  " A runtime error like division by zero is a CX_DYNAMIC_CHECK: the compiler
  " does not force you to catch it, and it still ends the program if you do not.
  " The divisor is a variable on purpose -- 10 / 0 written out is caught at
  " compile time instead, which is a different lesson.
  DATA(lv_divisor) = 0.
  TRY.
      DATA(lv_result) = 10 / lv_divisor.
      WRITE: / 'result', lv_result.
    CATCH cx_sy_zerodivide INTO DATA(lx_zero).
      " The exception object carries the facts; get_text( ) is the human line.
      WRITE: / 'divide by zero:', lx_zero->get_text( ).
  ENDTRY.

  " Catching the wrong thing is worse than catching nothing: CX_ROOT here would
  " have swallowed a programming error along with the missing row.
  TYPES ty_ints TYPE STANDARD TABLE OF i WITH EMPTY KEY.
  DATA(lt_n) = VALUE ty_ints( ( 1 ) ( 2 ) ).
  TRY.
      DATA(lv_third) = lt_n[ 3 ].
      WRITE: / 'third', lv_third.
    CATCH cx_sy_itab_line_not_found.
      WRITE: / 'there is no third row'.
  ENDTRY.

  " CLEANUP runs when an exception leaves this TRY block unhandled -- the place
  " to close what you opened. It does not run when the block ends normally, and
  " it does not run when the exception is caught here.
  TRY.
      TRY.
          RAISE EXCEPTION TYPE cx_sy_conversion_error.
        CLEANUP.
          WRITE: / 'cleanup ran on the way out'.
      ENDTRY.
    CATCH cx_sy_conversion_error.
      WRITE: / 'caught one level up'.
  ENDTRY.

  " Several exceptions, one handler: list them after CATCH. The INTO variable
  " is then typed to their nearest common superclass.
  TRY.
      DATA(lv_again) = 1 / lv_divisor.
      WRITE: / lv_again.
    CATCH cx_sy_zerodivide cx_sy_conversion_error INTO DATA(lx_any).
      WRITE: / 'one of the two:', lx_any->get_text( ).
  ENDTRY.
```
<!-- /snippet -->

## If you are coming from another language

- **Java.** `CX_STATIC_CHECK` is a checked exception and `CX_DYNAMIC_CHECK` is a `RuntimeException`; the debate about which to use is the same debate, with the same answers.
- **Python.** Everything is unchecked, so `CX_DYNAMIC_CHECK` is the familiar default. ABAP's `CLEANUP` is `finally` with one difference: `finally` also runs on the normal path, `CLEANUP` does not.
- **Rust.** `Result` makes failure part of the type rather than a side channel, and `?` is what `RAISING` approximates. ABAP has no equivalent of the compiler refusing to let you ignore a `Result`, except by choosing `CX_STATIC_CHECK`.

## See also

- [Exceptions](../../03_Topics/exceptions/README.md) — the topic page: designing exception classes, `RESUMABLE`, and wrapping
- [`MESSAGE`](../message/README.md) — the other way ABAP reports a problem
- [`CALL FUNCTION`](../call_function/README.md) — classic exceptions and `sy-subrc`
- [`ASSERT`](../assert/README.md) — for the condition that must never be false
- [`COND` and `SWITCH`](../cond_switch/README.md) — `THROW`, for a branch that should not exist
