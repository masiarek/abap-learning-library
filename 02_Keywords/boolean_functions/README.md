# `xsdbool( )` and `boolc( )` — ABAP has no boolean type

**Level:** 201 · working knowledge

**One line:** There is no boolean type in ABAP: a flag is a one-character field holding `'X'` or `' '`, `abap_true`/`abap_false` name those two values, `xsdbool( )` turns a logical expression into them as a value — and `boolc( )`, which looks identical, returns a `string` that does not compare equal to `abap_false`.

## The convention

```abap
DATA lv_flag TYPE abap_bool.          " a c LENGTH 1
lv_flag = abap_true.                  " 'X'
IF lv_flag = abap_true.
```

`abap_bool`, `abap_true` and `abap_false` come from the type pool `ABAP` and are the convention every SAP interface uses. Write them, not `'X'` — the letter means nothing to a reader and everything to the compiler.

A logical expression is **not** a value in ABAP: `lv_flag = lv_a > lv_b.` does not compile. That is the gap the two functions fill.

## `xsdbool( )` — the one to use

```abap
lv_flag = xsdbool( lv_qty > 0 ).
lo_thing->set_active( xsdbool( lt_rows IS NOT INITIAL ) ).
```

Returns `abap_true`/`abap_false` as a `c LENGTH 1`. The odd name is historical — it was added for XML schema boolean mapping — and it is the function SAP's own guidelines recommend.

## `boolc( )` — the trap

`boolc( )` returns a **`string`**: `X` for true and a single blank for false. Comparing that blank string with `abap_false` (a blank `c`) is a comparison between a string and a character field, in which trailing blanks are dropped from the `c` side — so a false `boolc( )` is not equal to `abap_false`, and `IF boolc( cond ) = abap_false.` is never true. The documented advice is to use `xsdbool( )`; the program below lets your system show what it does.

## Predicates do not need a flag at all

`line_exists( )`, `matches( )`, `contains( )`, `IS INITIAL`, `IS BOUND` and every comparison can be tested directly in an `IF`, `COND` or `WHERE`. The flag variable exists for storing and passing a truth value, not for testing one.

<!-- snippet:z_kw_boolean_functions -->
*[`z_kw_boolean_functions.prog.abap`](snippets/z_kw_boolean_functions.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_boolean_functions.

DATA(lv_qty) = 3.

" There is no boolean TYPE. abap_bool is a one-character c; abap_true is 'X'
" and abap_false is ' ' -- constants from the type pool ABAP, and the
" convention every SAP interface uses.
DATA lv_flag TYPE abap_bool.

" xsdbool( ) turns a logical expression into that convention, as a value.
lv_flag = xsdbool( lv_qty > 0 ).
WRITE: / 'positive:', lv_flag.

" boolc( ) does the same and returns a STRING. The documented catch: a false
" boolc( ) is a one-blank string, and comparing it with abap_false is not the
" comparison it looks like. This program reports what your system does.
DATA(lv_text) = boolc( lv_qty > 100 ).
IF lv_text = abap_false.
  WRITE: / 'boolc( false ) = abap_false held on this system'.
ELSE.
  WRITE: / 'boolc( false ) = abap_false did NOT hold -- use xsdbool( )'.
ENDIF.

" A predicate function is tested directly; no flag variable is needed.
DATA(lt_names) = VALUE string_table( ( `Ada` ) ).
IF line_exists( lt_names[ 1 ] ) AND lv_flag = abap_true.
  WRITE: / 'predicate and flag, in one condition'.
ENDIF.

" A flag passed to a method that expects abap_bool: xsdbool( ) keeps the call
" a single expression instead of an IF that sets a variable first.
WRITE: / 'is initial:', xsdbool( lt_names IS INITIAL ).
```
<!-- /snippet -->

## If you are coming from another language

- **C.** The pre-C99 situation exactly: an integer convention standing in for a type, with the value `1`/`0` replaced by `'X'`/`' '`.
- **Python / Rust / Java.** A real boolean, and a comparison that *is* a value. The habit to unlearn is `flag = a > b` — in ABAP it needs `xsdbool( )`.

## See also

- [`IF` and `CASE`](../case_if/README.md) — where the predicates are tested directly
- [`COND` and `SWITCH`](../cond_switch/README.md) — producing a value from a condition without a flag
- [`TYPES` and `CONSTANTS`](../types/README.md) — where `abap_true` lives
- [Conversion and comparison rules](../../03_Topics/conversion_and_comparison_rules/README.md) — why the string comparison fails
