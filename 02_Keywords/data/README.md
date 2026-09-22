# `DATA` — declaring a variable, and declaring it where it is used

**Level:** 101 · newcomer

**One line:** `DATA lv_x TYPE i.` names a variable and its type before anything happens to it; `DATA(lv_x) = …` (7.40 and later) creates it at the point of first write and takes the type from what is written — which is shorter, and which is also how you end up with an integer where you wanted a decimal.

## The two forms

```abap
DATA lv_counter TYPE i.          " declared, then used
lv_counter = 3.

DATA(lv_doubled) = lv_counter * 2.   " declared BY being used
```

The old form separates the declaration from the use. In a 4,000-line report that separation is real distance: the `DATA` block sits at the top, the code that uses it is somewhere below, and the two drift. The inline form removes the distance — and with it, the second place that has to be kept in step when a type changes.

What the inline form does **not** remove is the type. `DATA(x)` is not `var` in the sense of "untyped": the compiler works out one specific static type and holds you to it forever after. It is inference, not dynamism.

## The trap: the inferred type is the *operand's* type

This is the whole reason the page exists.

```abap
DATA lv_counter TYPE i.
lv_counter = 3.
DATA(lv_half) = lv_counter / 2.
```

`lv_counter` is `i`, so the calculation is integer arithmetic and `lv_half` is `i`. ABAP's integer division does not truncate — it rounds commercially — so `3 / 2` lands on `2`, not `1` and not `1.5`. Nothing warns you. The fix is to say what you meant, either by declaring the target or by converting an operand:

```abap
DATA lv_half TYPE decfloat34.
lv_half = lv_counter / 2.                       " the target decides

DATA(lv_precise) = CONV decfloat34( lv_counter ) / 2.   " the operand decides
```

See [Numbers and currency](../../03_Topics/numbers_and_currency/README.md) for which numeric type to reach for, and [`CAST`, `CONV` and `EXACT`](../cast_conv/README.md) for what `CONV` is doing there.

## Where the name comes from

ABAP has no block scope. A `DATA` inside an `IF` is visible after the `ENDIF`; a `DATA(x)` inside a `LOOP` still exists when the loop is over, holding whatever the last pass left in it. Declaring inside a loop body does **not** create a fresh variable per pass, which is worth knowing before you rely on one being initial.

Declaring the same name twice is an error, which makes the inline form awkward in a second loop over the same shape — the usual answer is to name the second one differently rather than to move the declaration back to the top.

## Naming, briefly

Classic ABAP prefixes carry the scope and the shape: `lv_` local value, `lt_` local table, `ls_` local structure, `lo_` local object, `gv_` global, `mv_` member, `iv_`/`ev_`/`cv_`/`rv_` for importing, exporting, changing and returning parameters. [Clean ABAP](../../03_Topics/clean_abap/README.md) argues for dropping most of them; a 20-year-old system will not be dropping anything soon. Read both fluently, write whatever the code around you writes.

## `CONSTANTS` is not `DATA`

A value that never changes should say so. `CONSTANTS lc_limit TYPE i VALUE 3.` is checked by the compiler on every write attempt, and it documents intent in a way a comment does not. See [`TYPES` and `CONSTANTS`](../types/README.md).

<!-- snippet:z_kw_data -->
*[`z_kw_data.prog.abap`](snippets/z_kw_data.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_data.

" The classic form: a name, then a type. The type comes from the Dictionary
" as often as from ABAP's own built-ins.
DATA lv_counter TYPE i.
DATA lv_name    TYPE string.
DATA lv_today   TYPE d.

CONSTANTS lc_limit TYPE i VALUE 3.

lv_counter = lc_limit.
lv_name    = `Ada Lovelace`.
lv_today   = sy-datum.

WRITE: / 'counter', lv_counter,
       / 'name   ', lv_name,
       / 'today  ', lv_today.

" Inline declaration (7.40+): the variable is born where it is used, and takes
" the type of what is written into it. There is no second place to keep in step.
DATA(lv_doubled) = lv_counter * 2.
WRITE: / 'doubled', lv_doubled.

" The inferred type is not always the one you would have declared. lv_counter
" is i, so the whole expression is integer arithmetic.
DATA(lv_half) = lv_counter / 2.
WRITE: / 'half   ', lv_half.

" Ask for a decimal type and the division is a decimal division instead.
DATA(lv_precise) = CONV decfloat34( lv_counter ) / 2.
WRITE: / 'precise', lv_precise.
```
<!-- /snippet -->

## If you are coming from another language

- **Python.** `x = 3` is the whole declaration and the type follows the value around. `DATA(x) = 3` looks the same and behaves differently: the type is fixed at that first assignment and never changes again.
- **Rust.** `let x = 3;` infers the same way, and Rust's integer division truncates where ABAP's rounds. Rust also has block scope and shadowing; ABAP has neither.
- **Java / C#.** `var x = 3;` is the closest match, including the rule that the declared type is static and inferred once.
- **JavaScript.** `let`/`const` look similar but infer nothing — the value can change shape later. ABAP will not let it.

## See also

- [`TYPES` and `CONSTANTS`](../types/README.md) — naming a shape once instead of repeating it
- [`FIELD-SYMBOLS` and `ASSIGN`](../field_symbols/README.md) — a name for memory you already have, rather than new memory
- [`VALUE`](../value/README.md) — filling a structure or table in the same breath as declaring it
- [Numbers and currency](../../03_Topics/numbers_and_currency/README.md) — why `i`, `p`, `decfloat34` and `f` are not interchangeable
- [Which release am I writing for?](../../03_Topics/releases_and_syntax_levels/README.md) — inline declarations need 7.40, and plenty of systems are older
