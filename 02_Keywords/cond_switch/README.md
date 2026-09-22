# `COND` and `SWITCH` — choosing, as an expression

**Level:** 201 · working knowledge

**One line:** `COND` is `IF`/`ELSEIF` written as a value and `SWITCH` is `CASE` written as a value; both need a type, both return the type's initial value when nothing matches and there is no `ELSE`, and that silent empty result is the only trap either of them has.

## `COND` tests conditions

```abap
DATA(lv_grade) = COND string( WHEN lv_score >= 90 THEN `A`
                              WHEN lv_score >= 80 THEN `B`
                              WHEN lv_score >= 70 THEN `C`
                              ELSE `F` ).
```

Conditions are tried in order and the first one that holds wins — so the order of the `WHEN`s is part of the logic, exactly as with `ELSEIF`. Any logical expression is allowed, including `BETWEEN`, `IS INITIAL`, `IS BOUND` and comparisons of different fields.

## `SWITCH` compares one operand

```abap
DATA(lv_band) = SWITCH string( lv_grade
                               WHEN `A` OR `B` THEN `distinction`
                               WHEN `C`        THEN `pass`
                               ELSE `fail` ).
```

The operand is named once, then compared for equality against each `WHEN`. `OR` lists alternatives. What `SWITCH` **cannot** do is express a range or any other relation — that is what `COND` is for, and reaching for `SWITCH` first and discovering this is a normal afternoon.

## The missing `ELSE` is silent

Leave out `ELSE` and no error is raised when nothing matches: the expression yields the **initial value** of its type. An empty string, a zero, an initial date. In a grading expression that is a wrong grade; in a factor it is a zero that multiplies something to nothing three screens later.

`THROW` turns the gap into a failure at the point it happens:

```abap
DATA(lv_checked) = COND string( WHEN lv_score BETWEEN 0 AND 100 THEN lv_grade
                                ELSE THROW cx_sy_conversion_error( ) ).
```

That is the same exception machinery as everywhere else — see [`TRY`, `CATCH`, `RAISE`](../try_catch/README.md). For a condition that should be impossible rather than merely unexpected, [`ASSERT`](../assert/README.md) is the blunter instrument.

## When the statement is still better

An `IF` whose branches *do things* — call a method, write a log, update a table — is an `IF`. `COND` is for producing **one value**; the moment a branch has a side effect, the expression form stops being available and stops being the goal. The conversion is not a modernisation exercise.

<!-- snippet:z_kw_cond_switch -->
*[`z_kw_cond_switch.prog.abap`](snippets/z_kw_cond_switch.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_cond_switch.

DATA(lv_score) = 72.

" COND tests conditions, in order, and stops at the first that holds.
DATA(lv_grade) = COND string( WHEN lv_score >= 90 THEN `A`
                              WHEN lv_score >= 80 THEN `B`
                              WHEN lv_score >= 70 THEN `C`
                              ELSE `F` ).

" SWITCH compares one operand against values. It cannot express a range.
DATA(lv_band) = SWITCH string( lv_grade
                               WHEN `A` OR `B` THEN `distinction`
                               WHEN `C`        THEN `pass`
                               ELSE `fail` ).

" Without ELSE the result is the initial value of the type -- a silent empty
" string, not an error. THROW turns that gap into an exception instead.
TRY.
    DATA(lv_checked) = COND string( WHEN lv_score BETWEEN 0 AND 100 THEN lv_grade
                                    ELSE THROW cx_sy_conversion_error( ) ).
    WRITE: / 'checked', lv_checked.
  CATCH cx_sy_conversion_error.
    WRITE: / 'score out of range'.
ENDTRY.

WRITE: / 'grade', lv_grade.
WRITE: / 'band ', lv_band.
```
<!-- /snippet -->

## If you are coming from another language

- **Rust.** `match` and `if/else` are expressions too, and Rust's compiler *refuses* a non-exhaustive `match`. ABAP's missing `ELSE` is the same hole with no compiler standing in it.
- **Python.** The conditional expression `a if cond else b`, and `match` from 3.10. Python's `if` expression makes `else` mandatory, which is the safer default.
- **JavaScript.** The ternary chain, with the same readability limit at about three branches.

## See also

- [`IF` and `CASE`](../case_if/README.md) — the statement forms, and when each is right
- [`REDUCE`](../reduce/README.md) — where `COND` most often appears, inside a `NEXT`
- [`TRY`, `CATCH`, `RAISE`](../try_catch/README.md) — what `THROW` is throwing
- [`ASSERT`](../assert/README.md) — for the case that should be impossible
