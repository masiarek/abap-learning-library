# `LOOP AT` — `INTO` copies, `ASSIGNING` does not

**Level:** 201 · working knowledge

**One line:** `LOOP AT itab INTO wa` gives you a **copy** of each row, so writing to `wa` changes nothing in the table; `ASSIGNING <fs>` points a field symbol at the row itself, so writing lands — and `GROUP BY` replaces the `AT NEW` control-break dance entirely.

## The one that costs an afternoon

```abap
LOOP AT lt_rows INTO DATA(ls_copy).
  ls_copy-amount = 0.        " changes the copy. The table is untouched.
ENDLOOP.
```

No warning, no error, no effect. The fix is either to write the row back —

```abap
  MODIFY lt_rows FROM ls_copy.
```

— or, better, not to copy in the first place:

```abap
LOOP AT lt_rows ASSIGNING FIELD-SYMBOL(<ls_row>).
  <ls_row>-amount = <ls_row>-amount * 2.
ENDLOOP.
```

`ASSIGNING` is also faster for wide rows, because nothing is copied. Use `INTO` when you deliberately want a copy to modify without touching the table; use `ASSIGNING` otherwise. `REFERENCE INTO DATA(lr_row)` is the third form, giving a data reference — needed when the reference has to outlive the pass.

## `WHERE` filters before the copy

```abap
LOOP AT lt_rows INTO DATA(ls_eu) WHERE region = `EU`.
```

An `IF` as the first statement inside the loop does the same thing logically and copies every row first. On a large table the difference is measurable. The `WHERE` follows internal-table rules: a component compared with a value, no arithmetic on the left.

On a table with a [secondary key](../../03_Topics/internal_tables/README.md), `USING KEY` tells the loop to use it — and without naming it, the loop uses the primary key or the table order, whatever the secondary key would have cost you.

## `sy-tabix`, and the rule about deleting

`sy-tabix` holds the index of the current row. Deleting rows inside the loop renumbers everything after the current position, which is why `DELETE lt WHERE …` as a single statement is both faster and correct where a `DELETE` inside the loop is a classic off-by-one. See [Changing a table](../itab_changes/README.md).

## `GROUP BY` instead of a control break

The classic way to total per group was `SORT`, then `AT NEW`/`AT END OF` inside the loop, with `sy-subrc` and hidden work-area truncation rules that surprised everyone at least once. Since 7.40:

```abap
LOOP AT lt_rows INTO DATA(ls_any)
     GROUP BY ( region = ls_any-region )
     INTO DATA(ls_group).
  " one pass per group; members reachable with FOR … IN GROUP
ENDLOOP.
```

No `SORT` is required first — the grouping is by value, not by adjacency, which is the substantive difference from `AT NEW` rather than a syntactic one. Inside the group pass, `LOOP AT GROUP ls_group` walks its members, and a `REDUCE … FOR … IN GROUP` totals them in one expression.

<!-- snippet:z_kw_loop_at -->
*[`z_kw_loop_at.prog.abap`](snippets/z_kw_loop_at.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_loop_at.

TYPES ty_amount TYPE p LENGTH 9 DECIMALS 2.
TYPES: BEGIN OF ty_row,
         region TYPE string,
         amount TYPE ty_amount,
       END OF ty_row.
TYPES ty_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

DATA(lt_rows) = VALUE ty_tab( ( region = `EU` amount = '10.00' )
                              ( region = `US` amount = '20.00' )
                              ( region = `EU` amount = '30.00' ) ).

" INTO copies the row into a work area. Writing to the copy changes nothing in
" the table -- the commonest silent bug in ABAP.
LOOP AT lt_rows INTO DATA(ls_copy).
  ls_copy-amount = 0.
ENDLOOP.

" ASSIGNING points a field symbol AT the row itself. No copy, and writes land.
LOOP AT lt_rows ASSIGNING FIELD-SYMBOL(<ls_row>).
  <ls_row>-amount = <ls_row>-amount * 2.
ENDLOOP.

" WHERE filters before the copy is made; an IF inside the loop filters after it.
LOOP AT lt_rows INTO DATA(ls_eu) WHERE region = `EU`.
  WRITE: / 'eu row', sy-tabix, ls_eu-amount.
ENDLOOP.

" GROUP BY replaces the AT NEW / control-break dance, and needs no SORT first.
LOOP AT lt_rows INTO DATA(ls_any)
     GROUP BY ( region = ls_any-region )
     INTO DATA(ls_group).
  DATA(lv_total) = REDUCE ty_amount( INIT s = 0
                                     FOR <ls_member> IN GROUP ls_group
                                     NEXT s = s + <ls_member>-amount ).
  WRITE: / 'group', ls_group-region, lv_total.
ENDLOOP.
```
<!-- /snippet -->

## If you are coming from another language

- **Python.** `for row in rows:` binds a reference, so mutating `row` *does* change the list's object — the opposite default from `INTO`. ABAP's `ASSIGNING` is the Python-like one.
- **Rust.** `for x in &v` versus `for x in &mut v` makes the same distinction the compiler enforces; ABAP's is a naming convention you have to notice.
- **SQL.** `GROUP BY` means the same thing here as there, on a table you already hold — and if the rows came from the database, the grouping usually belonged there. See [Open SQL](../../03_Topics/open_sql/README.md).

## See also

- [`READ TABLE` and table expressions](../read_table/README.md) — reading one row instead of all of them
- [Changing a table](../itab_changes/README.md) — `MODIFY`, `DELETE`, and why not inside the loop
- [`FIELD-SYMBOLS` and `ASSIGN`](../field_symbols/README.md) — what `ASSIGNING` is actually doing
- [`FOR`](../for/README.md) — the same iteration as an expression
- [Internal tables](../../03_Topics/internal_tables/README.md) — keys, kinds and what each lookup costs
