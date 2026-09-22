# `CAST`, `CONV` and `EXACT` — changing what the compiler thinks it has

**Level:** 201 · working knowledge

**One line:** `CAST` changes the static type of a **reference** and checks the claim at runtime, `CONV` converts a **value** to a type ABAP would not convert to on its own, and `EXACT` performs the same conversion but raises instead of quietly losing information.

## `CAST` — down the hierarchy, with a runtime check

```abap
DATA(lo_shape)  = CAST lif_shape( NEW lcl_square( 3 ) ).   " up: always fine
DATA(lo_square) = CAST lcl_square( lo_shape ).             " down: checked
```

Going up — treating a square as a shape — needs no check, because it is true by construction. Going down is a claim about what the object really is, and when the claim is false the result is `CX_SY_MOVE_CAST_ERROR`, not a compile error. Catch it, or make the claim safe with `IS INSTANCE OF`:

```abap
IF lo_shape IS INSTANCE OF lcl_square.
  DATA(lo_sure) = CAST lcl_square( lo_shape ).
ENDIF.
```

A hierarchy where downcasts are common is usually a hierarchy whose interface is missing a method. The cast is the symptom.

## `CONV` — converting a value

```abap
DATA(lv_len) = strlen( CONV string( lv_chars ) ).
```

ABAP converts between many types implicitly on assignment, but a *parameter* is not an assignment: a method expecting `string` will not take a `c` field on its own. `CONV` performs the conversion where the compiler will not.

It also changes what an expression *means*. `CONV decfloat34( lv_i ) / 2` is a decimal division; `lv_i / 2` is an integer one. See [`DATA`](../data/README.md) for how easily that happens by accident.

Converting `c` to `string` is worth its own note: **trailing blanks are removed**. A `c LENGTH 10` holding `'ABAP'` is ten characters long; the same value converted to a string is four. That single rule accounts for a large share of "the length changed and I did not touch it" bugs. [How long is a string?](../../01_Foundations/how_long_is_a_string/README.md) is the recorded-run page next door.

## `EXACT` — refusing to lose information

```abap
DATA(lv_ok)    = EXACT i( '42' ).      " fine
DATA(lv_lossy) = EXACT i( '42.7' ).    " raises CX_SY_CONVERSION_ERROR
```

Ordinary conversion would round `42.7` to `43` and say nothing. `EXACT` raises instead. For a length check it does the same job — a value that does not fit the target is an exception rather than a truncation. It is the right default anywhere the data came from outside: a file, an interface, a user.

## `REF`

`REF #( lv_x )` takes a reference to an existing variable — the expression form of `GET REFERENCE OF`. It appears mostly when passing something to a parameter typed `REF TO data`, and it does not copy: change the original and the reference sees it.

<!-- snippet:z_kw_cast_conv -->
*[`z_kw_cast_conv.prog.abap`](snippets/z_kw_cast_conv.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_cast_conv.

INTERFACE lif_shape.
  METHODS area RETURNING VALUE(rv_area) TYPE i.
ENDINTERFACE.

CLASS lcl_square DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif_shape.
    METHODS constructor IMPORTING iv_side TYPE i.
    METHODS side RETURNING VALUE(rv_side) TYPE i.
  PRIVATE SECTION.
    DATA mv_side TYPE i.
ENDCLASS.

CLASS lcl_square IMPLEMENTATION.
  METHOD constructor.
    mv_side = iv_side.
  ENDMETHOD.
  METHOD side.
    rv_side = mv_side.
  ENDMETHOD.
  METHOD lif_shape~area.
    rv_area = mv_side * mv_side.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  " Up the hierarchy is free: a square is a shape.
  DATA(lo_shape) = CAST lif_shape( NEW lcl_square( 3 ) ).
  WRITE: / 'area', lo_shape->area( ).

  " Down it is a claim, and CAST checks it at runtime.
  TRY.
      DATA(lo_square) = CAST lcl_square( lo_shape ).
      WRITE: / 'side', lo_square->side( ).
    CATCH cx_sy_move_cast_error.
      WRITE: / 'that object was not a square'.
  ENDTRY.

  " CONV converts a VALUE where ABAP would not convert on its own.
  DATA lv_chars TYPE c LENGTH 10 VALUE 'ABAP'.
  WRITE: / 'c len     ', strlen( lv_chars ).
  WRITE: / 'string len', strlen( CONV string( lv_chars ) ).

  " EXACT refuses a conversion that would lose something, instead of rounding.
  TRY.
      DATA(lv_ok) = EXACT i( '42' ).
      WRITE: / 'exact', lv_ok.
      DATA(lv_lossy) = EXACT i( '42.7' ).
      WRITE: / 'never reached', lv_lossy.
    CATCH cx_sy_conversion_error.
      WRITE: / '42.7 does not fit in an integer without losing something'.
  ENDTRY.
```
<!-- /snippet -->

## If you are coming from another language

- **Java.** `(Square) shape` is `CAST`, `ClassCastException` is `CX_SY_MOVE_CAST_ERROR`, and `instanceof` is `IS INSTANCE OF`. The mapping is almost exact.
- **Rust.** `CONV` is `into()`/`as`, and `EXACT` is `try_into()` — the version that returns an error instead of wrapping or rounding. Rust makes the fallible one the default; ABAP makes the silent one the default.
- **Python.** `int("42")` raises on `"42.7"`, so Python's built-in conversion behaves like `EXACT` rather than like `CONV`.

## See also

- [`NEW`](../new/README.md) — where the reference being cast usually comes from
- [`DATA` — and `DATA( )`](../data/README.md) — the inferred type that `CONV` is often fixing
- [How long is a string?](../../01_Foundations/how_long_is_a_string/README.md) — `c`, `string` and what counts as a character
- [Numbers and currency](../../03_Topics/numbers_and_currency/README.md) — which numeric conversions lose what
