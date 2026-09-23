# `FOR` — the loop that lives inside an expression

**Level:** 201 · working knowledge

**One line:** `FOR` turns one table into another inside a `VALUE`, `REDUCE` or `NEW` expression — mapping, filtering with `WHERE`, or counting with `UNTIL`/`WHILE` — and the loop variable it declares exists only inside that expression.

## Map

```abap
DATA(lt_ids) = VALUE ty_ints( FOR ls_o IN lt_orders ( ls_o-id ) ).
```

Read it right to left: for each row of `lt_orders`, produce one row holding `ls_o-id`. The equivalent `LOOP … APPEND … ENDLOOP` is four lines and leaves a work area behind; this is one expression and leaves nothing.

`ls_o` is declared by the `FOR` itself. It is not visible after the closing parenthesis, which is the one place ABAP does give you a scope narrower than the program.

## Filter

```abap
DATA(lt_eu) = VALUE ty_orders( FOR ls_e IN lt_orders WHERE ( region = `EU` ) ( ls_e ) ).
```

The `WHERE` condition sits in parentheses and follows internal-table `WHERE` rules — a component compared to a value. You cannot calculate in it: `WHERE ( amount * 2 > 100 )` is a syntax error, not a slow filter. [`FILTER`](../filter/README.md) does the same job in a shorter form when the table has a suitable key; `FOR … WHERE` works on any table.

## Count

```abap
DATA(lt_squares) = VALUE ty_ints( FOR lv_i = 1 UNTIL lv_i > 5 ( lv_i * lv_i ) ).
```

`UNTIL` stops when the condition becomes true; `WHILE` continues as long as it is true. `THEN` sets the step — `FOR lv_i = 10 THEN lv_i - 2 UNTIL lv_i < 0` counts down by twos. There is no `FOR i = 1 TO 5` form; the condition is always written out.

## Nesting is a cross product

```abap
DATA(lt_labels) = VALUE ty_names( FOR ls_p IN lt_orders
                                  FOR lv_n = 1 UNTIL lv_n > 2
                                  ( |{ ls_p-id }-{ lv_n }| ) ).
```

Two `FOR` clauses in a row mean every combination — rows × 2 here. This is the construct's sharpest edge: a nested `FOR` over two tables of a thousand rows builds a million-row table in one statement that fits on one line. See [Performance](../../03_Topics/performance/README.md).

## `LET`, in passing

`LET` names a value once inside the expression so it is not recomputed or repeated. It is covered on its own page — [`LET`](../let/README.md) — and appears in the program below.

<!-- snippet:z_kw_for -->
*[`z_kw_for.prog.abap`](snippets/z_kw_for.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_for.

TYPES ty_amount TYPE p LENGTH 9 DECIMALS 2.
TYPES: BEGIN OF ty_order,
         id     TYPE i,
         region TYPE string,
         amount TYPE ty_amount,
       END OF ty_order.
TYPES ty_orders TYPE STANDARD TABLE OF ty_order WITH EMPTY KEY.
TYPES ty_ints   TYPE STANDARD TABLE OF i WITH EMPTY KEY.
TYPES ty_names  TYPE STANDARD TABLE OF string WITH EMPTY KEY.

DATA(lt_orders) = VALUE ty_orders( ( id = 1 region = `EU` amount = '100.00' )
                                   ( id = 2 region = `US` amount = '250.50' )
                                   ( id = 3 region = `EU` amount = '75.25' ) ).

" Map: one output row per input row.
DATA(lt_ids) = VALUE ty_ints( FOR ls_o IN lt_orders ( ls_o-id ) ).

" Filter: WHERE decides which input rows are visited at all.
DATA(lt_eu) = VALUE ty_orders( FOR ls_e IN lt_orders WHERE ( region = `EU` ) ( ls_e ) ).

" No table to walk: an index of your own, counting with UNTIL or WHILE.
DATA(lt_squares) = VALUE ty_ints( FOR lv_i = 1 UNTIL lv_i > 5 ( lv_i * lv_i ) ).

" Nested FOR is a cross product, read left to right.
DATA(lt_labels) = VALUE ty_names( FOR ls_p IN lt_orders
                                  FOR lv_n = 1 UNTIL lv_n > 2
                                  ( |{ ls_p-id }-{ lv_n }| ) ).

" LET names a value once so the expression does not repeat itself.
DATA(lt_tagged) = VALUE ty_names( LET lv_tag = `order` IN
                                  FOR ls_t IN lt_orders ( |{ lv_tag } { ls_t-id }| ) ).

WRITE: / 'ids     ', lines( lt_ids ).
WRITE: / 'eu      ', lines( lt_eu ).
WRITE: / 'squares ', lines( lt_squares ).
WRITE: / 'labels  ', lines( lt_labels ).
LOOP AT lt_tagged INTO DATA(lv_label).
  WRITE: / lv_label.
ENDLOOP.
```
<!-- /snippet -->

## If you are coming from another language

- **Python.** This is the list comprehension, including the `WHERE` as the trailing `if` and nesting as the cross product. `UNTIL` plays the part of `range()`, spelled as a condition.
- **Rust.** `iter().map(…)` and `.filter(…)` collected into a `Vec`. ABAP's version is not lazy: it builds the whole table.
- **SQL.** `FOR … IN … WHERE` is a `SELECT … FROM … WHERE` over a table you already hold in memory — which is worth noticing, because if the rows came from the database the filter usually belonged there instead. See [Open SQL](../../03_Topics/open_sql/README.md).

## See also

- [`VALUE`](../value/README.md) — the expression `FOR` most often lives in
- [`REDUCE`](../reduce/README.md) — `FOR` folding many rows into one value
- [`FILTER`](../filter/README.md) — the shorter form, when the table has the key for it
- [`LOOP AT`](../loop_at/README.md) — the statement, and when it is still the right choice
- [Performance](../../03_Topics/performance/README.md) — what a nested `FOR` costs
- [Constructor expressions](../../03_Topics/constructor_expressions/README.md) — the `VALUE`/`NEW`/`COND` family as a family
