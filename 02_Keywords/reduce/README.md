# `REDUCE` — many rows, one value

**Level:** 201 · working knowledge

**One line:** `REDUCE type( INIT acc = … FOR row IN itab NEXT acc = … )` folds a table into a single value: `INIT` names the accumulator and starts it, `NEXT` says how each row changes it, and the result is whatever the accumulator holds at the end.

## The shape

```abap
DATA(lv_sum) = REDUCE i( INIT s = 0
                         FOR lv_x IN lt_n
                         NEXT s = s + lv_x ).
```

Three moving parts, in the order they happen:

| Part | Job |
|---|---|
| `REDUCE i(` | the type of the result — and of the accumulator |
| `INIT s = 0` | declares the accumulator and its starting value |
| `FOR lv_x IN lt_n` | the rows to fold, with the same options as [`FOR`](../for/README.md) |
| `NEXT s = …` | the new value of the accumulator after this row |

`INIT` is mandatory even when the starting value is the initial one: `REDUCE` has to know the type and the starting point before the first row.

## It is not only for sums

The accumulator can be any type, which is what makes `REDUCE` more than a sum:

```abap
DATA(lv_csv) = REDUCE string( INIT out = ``
                              FOR lv_v IN lt_n
                              NEXT out = COND #( WHEN out IS INITIAL
                                                 THEN |{ lv_v }|
                                                 ELSE |{ out },{ lv_v }| ) ).
```

A maximum, a count, a concatenation, a flag that goes true and stays true — all the same shape with a different `NEXT`. For joining strings specifically, ``concat_lines_of( table = lt sep = `,` )`` is shorter and clearer; reach for `REDUCE` when the fold is genuinely a fold.

## `WHERE` filters what is folded

```abap
DATA(lv_big) = REDUCE i( INIT c = 0
                         FOR lv_z IN lt_n WHERE ( table_line > 2 )
                         NEXT c = c + 1 ).
```

`table_line` is how a row of an unstructured table (a table of `i`, of `string`) is named, since there is no component to name. It can be **compared** but not calculated with: `WHERE ( table_line MOD 2 = 1 )` does not parse. That is not a rule about `REDUCE` — it is the internal-table `WHERE` rule everywhere, and it is what sends people back to `LOOP AT` with an `IF` inside.

## When not to

`REDUCE` earns its place when the fold is one clear line. A `NEXT` clause with three nested `COND`s in it is a `LOOP` that has been squeezed into an expression, and the `LOOP` will read better. The measure is the reader, not the line count.

<!-- snippet:z_kw_reduce -->
*[`z_kw_reduce.prog.abap`](snippets/z_kw_reduce.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_reduce.

TYPES ty_ints TYPE STANDARD TABLE OF i WITH EMPTY KEY.

DATA(lt_n) = VALUE ty_ints( ( 3 ) ( 1 ) ( 4 ) ( 1 ) ( 5 ) ).

" INIT names the accumulator and its starting value; NEXT says how each row
" changes it; the type in front is the type of the result.
DATA(lv_sum) = REDUCE i( INIT s = 0
                         FOR lv_x IN lt_n
                         NEXT s = s + lv_x ).

" A maximum is the same shape with a different NEXT.
DATA(lv_max) = REDUCE i( INIT m = 0
                         FOR lv_y IN lt_n
                         NEXT m = COND #( WHEN lv_y > m THEN lv_y ELSE m ) ).

" WHERE filters what is folded. table_line names the whole row of a table that
" has no components to name -- and it can only be compared, not calculated with:
" WHERE ( table_line MOD 2 = 1 ) is a syntax error, not a slow filter.
DATA(lv_big) = REDUCE i( INIT c = 0
                         FOR lv_z IN lt_n WHERE ( table_line > 2 )
                         NEXT c = c + 1 ).

" The accumulator need not be a number.
DATA(lv_csv) = REDUCE string( INIT out = ``
                              FOR lv_v IN lt_n
                              NEXT out = COND #( WHEN out IS INITIAL
                                                 THEN |{ lv_v }|
                                                 ELSE |{ out },{ lv_v }| ) ).

WRITE: / 'sum ', lv_sum.
WRITE: / 'max ', lv_max.
WRITE: / 'over2', lv_big.
WRITE: / 'csv ', lv_csv.
```
<!-- /snippet -->

## If you are coming from another language

- **Python.** `functools.reduce`, or more often the `sum()`/`max()` that replace it. ABAP has `REDUCE` and no built-in `sum()` over an internal table, so the explicit fold is the normal way.
- **Rust.** `.fold(init, |acc, x| …)`, with `INIT` as the first argument and `NEXT` as the closure body.
- **JavaScript.** `Array.prototype.reduce`, same three parts in the same order.
- **SQL.** An aggregate. If the rows came from the database, `SUM( )` there beats `REDUCE` here — see [Open SQL](../../03_Topics/open_sql/README.md).

## See also

- [`FOR`](../for/README.md) — the iteration clause `REDUCE` borrows
- [`VALUE`](../value/README.md) — the same family, building a table instead of a value
- [`COND` and `SWITCH`](../cond_switch/README.md) — what usually sits inside a `NEXT`
- [`LOOP AT`](../loop_at/README.md) — the statement form, and `GROUP BY` for folding per group
