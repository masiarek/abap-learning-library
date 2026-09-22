# `READ TABLE` and table expressions — one row, two ways to fail

**Level:** 201 · working knowledge

**One line:** `READ TABLE … INTO wa WITH KEY …` reports a miss through `sy-subrc` and leaves the work area holding whatever it held before, while `itab[ … ]` raises `CX_SY_ITAB_LINE_NOT_FOUND` — so the statement fails quietly and the expression fails loudly, and which one you want depends on whether a miss is normal.

## The statement form

```abap
READ TABLE lt_rows INTO DATA(ls_hit) WITH KEY id = 2.
IF sy-subrc = 0.
  " ls_hit is the row
ENDIF.
```

Two things go wrong here, both famous:

1. **Nobody checks `sy-subrc`.** The next statement uses `ls_hit` as if it were found.
2. **The work area is not cleared on a miss.** It still holds the *previous* row, so the code carries on with real-looking data from an unrelated record. This is the difference between a wrong answer and a dump, and it is why the expression form exists.

`READ TABLE … ASSIGNING <fs>` avoids the copy, and an unassigned field symbol at least dumps rather than lying.

## The expression form

```abap
DATA(ls_two) = lt_rows[ id = 2 ].         " raises on a miss
DATA(ls_opt) = VALUE #( lt_rows[ id = 9 ] OPTIONAL ).   " initial row on a miss
DATA(ls_def) = VALUE #( lt_rows[ id = 9 ] DEFAULT lt_rows[ 1 ] ).
```

There is no `sy-subrc` to forget. A miss is an exception you either catch or let end the program — and for a row that must exist, ending the program at the point of the missing row beats continuing with the last one. `OPTIONAL` and `DEFAULT` are the deliberate ways to say a miss is fine.

`lt_rows[ 1 ]` reads by index; ``lt_rows[ KEY by_region region = `EU` ]`` reads by a named [secondary key](../../03_Topics/internal_tables/README.md).

## `line_exists( )` and `line_index( )`

```abap
IF line_exists( lt_rows[ id = 3 ] ).
  DATA(lv_idx) = line_index( lt_rows[ id = 3 ] ).
ENDIF.
```

Both take a table expression and neither raises. The cost is that asking-then-reading searches **twice**; for a test that is fine, for a read prefer `OPTIONAL` and one search.

## `BINARY SEARCH` is a promise you have to keep

`READ TABLE … WITH KEY … BINARY SEARCH` on a standard table is fast only because it assumes the table is sorted **by exactly those fields, in that order**. If it is not, the read does not fail — it returns the wrong row or reports a miss on a row that is present. A sorted or hashed table type makes the guarantee structural instead of something a maintainer has to remember; see [Internal tables](../../03_Topics/internal_tables/README.md).

<!-- snippet:z_kw_read_table -->
*[`z_kw_read_table.prog.abap`](snippets/z_kw_read_table.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_read_table.

TYPES: BEGIN OF ty_row,
         id   TYPE i,
         name TYPE string,
       END OF ty_row.
TYPES ty_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

DATA(lt_rows) = VALUE ty_tab( ( id = 1 name = `Ada` )
                              ( id = 2 name = `Grace` )
                              ( id = 3 name = `Katherine` ) ).

" The statement form reports through sy-subrc, and says nothing if you forget
" to look. The work area keeps its previous contents when the read misses.
READ TABLE lt_rows INTO DATA(ls_hit) WITH KEY id = 2.
IF sy-subrc = 0.
  WRITE: / 'found', ls_hit-name.
ENDIF.

" The expression form has no sy-subrc: a miss is an exception.
TRY.
    DATA(ls_two) = lt_rows[ id = 2 ].
    WRITE: / 'expr ', ls_two-name.
    DATA(ls_gone) = lt_rows[ id = 99 ].
    WRITE: / 'never reached', ls_gone-name.
  CATCH cx_sy_itab_line_not_found.
    WRITE: / 'no row with id 99'.
ENDTRY.

" OPTIONAL turns a miss into an initial row; DEFAULT into a row you choose.
DATA(ls_opt) = VALUE #( lt_rows[ id = 99 ] OPTIONAL ).
DATA(ls_def) = VALUE #( lt_rows[ id = 99 ] DEFAULT lt_rows[ 1 ] ).

" Asking first costs a second search, so prefer it for a test, not for a read.
IF line_exists( lt_rows[ id = 3 ] ).
  WRITE: / 'index', line_index( lt_rows[ id = 3 ] ).
ENDIF.

" ASSIGNING reads without copying the row.
READ TABLE lt_rows ASSIGNING FIELD-SYMBOL(<ls_first>) INDEX 1.
IF <ls_first> IS ASSIGNED.
  WRITE: / 'first', <ls_first>-name.
ENDIF.

WRITE: / 'opt id', ls_opt-id.
WRITE: / 'def   ', ls_def-name.
```
<!-- /snippet -->

## If you are coming from another language

- **Python.** `d[k]` raises `KeyError` and `d.get(k)` returns `None`: exactly the `itab[ ]` versus `OPTIONAL` pair. The `READ TABLE` form has no Python equivalent, because nothing in Python leaves the old value in place on a miss.
- **Rust.** `map[&k]` panics, `map.get(&k)` returns an `Option`. `DEFAULT` is `unwrap_or`.
- **Java.** `Map.get` returning `null` is the closest, and it has the same problem `READ TABLE` has — the caller must remember to check.

## See also

- [`LOOP AT`](../loop_at/README.md) — when you want every row, and the same `INTO`/`ASSIGNING` choice
- [Internal tables](../../03_Topics/internal_tables/README.md) — which table kind makes this read cheap
- [`VALUE`](../value/README.md) — where `OPTIONAL` and `DEFAULT` come from
- [`TRY`, `CATCH`, `RAISE`](../try_catch/README.md) — catching the miss when a miss is normal
