# `STATICS` — a local variable with a global lifetime

**Level:** 201 · working knowledge

**One line:** `STATICS` declares a variable inside a method, function module or subroutine that is initialised **once** and keeps its value between calls — a cache or a counter with no global name — and the price is state that nothing outside the method can see, reset, or test.

## What it does

```abap
METHOD next.
  STATICS sv_calls TYPE i.
  sv_calls = sv_calls + 1.
  rv_n = sv_calls.
ENDMETHOD.
```

Three calls return 1, 2, 3. The variable is created the first time the method runs and lives until the program does. In a function group, `STATICS` in a function module survives across calls from different programs in the same session — the same lifetime as the group's global data, with a smaller scope.

The idiom is the one-off cache: "read the customizing table on the first call, keep it". It works, and it is why the second run of a job can behave differently from the first.

## The alternative, and why it usually wins

`CLASS-DATA` does the same job with the state declared in the class definition, where a reader will look for it, where a test's `setup` can clear it, and where a second method can see it. `STATICS` hides state inside a method body; that is occasionally exactly right — a purely internal memo — and usually an invitation to a bug that only appears on the second call.

`STATICS` is allowed in static methods, function modules and `FORM`s; in an **instance** method the sensible replacement is an instance attribute, which is what the state was all along.

<!-- snippet:z_kw_statics -->
*[`z_kw_statics.prog.abap`](snippets/z_kw_statics.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_statics.

CLASS lcl_counter DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS next RETURNING VALUE(rv_n) TYPE i.
    CLASS-METHODS next_visible RETURNING VALUE(rv_n) TYPE i.
  PRIVATE SECTION.
    CLASS-DATA gv_calls TYPE i.
ENDCLASS.

CLASS lcl_counter IMPLEMENTATION.
  METHOD next.
    " STATICS is declared like DATA, initialised ONCE, and keeps its value
    " between calls: a local name with a global lifetime. Nothing outside this
    " method can see it, which is both the point and the problem.
    STATICS sv_calls TYPE i.
    sv_calls = sv_calls + 1.
    rv_n = sv_calls.
  ENDMETHOD.

  METHOD next_visible.
    " The same behaviour with CLASS-DATA: the state is declared where a
    " reader will look for it, and a test can reset it.
    gv_calls = gv_calls + 1.
    rv_n = gv_calls.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  WRITE: / 'statics   ', lcl_counter=>next( ).
  WRITE: / 'statics   ', lcl_counter=>next( ).
  WRITE: / 'statics   ', lcl_counter=>next( ).
  WRITE: / 'class-data', lcl_counter=>next_visible( ).
  WRITE: / 'class-data', lcl_counter=>next_visible( ).
```
<!-- /snippet -->

## If you are coming from another language

- **C.** A `static` local inside a function — the same feature with the same name and the same reputation.
- **Python.** Mutable default arguments, or a function attribute: the same "initialised once, shared thereafter" surprise.
- **Rust.** `static` items with interior mutability, which the language makes deliberately awkward for the reasons above.

## See also

- [`DATA` — and `DATA( )`](../data/README.md) — ordinary local variables, and the lack of block scope
- [`CLASS`](../class/README.md) — `CLASS-DATA`, the visible version
- [ABAP Unit](../../03_Topics/abap_unit/README.md) — why hidden state is a testing problem
- [Modularization](../../03_Topics/modularization/README.md) — function group global data, the same lifetime at a larger scope
