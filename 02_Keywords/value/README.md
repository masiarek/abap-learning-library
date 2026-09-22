# `VALUE` — a structure or a whole table, as one expression

**Level:** 201 · working knowledge

**One line:** `VALUE` builds a value of a named type in a single expression — ``VALUE ty_line( id = 1 name = `Ada` )`` for a structure, one pair of parentheses per row for a table — and `BASE` is the difference between adding to what is there and starting from empty.

## The shape

```abap
DATA(ls_one) = VALUE ty_line( id = 1 name = `Ada` ).

DATA(lt_people) = VALUE ty_tab( ( id = 1 name = `Ada` )
                                ( id = 2 name = `Grace` ) ).
```

Before 7.40 that second one was four statements and a work area that lived on afterwards holding the last row. The expression form has no leftover work area, which is the quiet benefit: nothing survives to be used by accident.

Components you do not name are set to their **initial value**, not left alone. For a fresh variable that is the same thing; for an existing one it is emphatically not, which is what `BASE` is for.

## `BASE`, and the mistake it prevents

```abap
DATA(lt_more) = VALUE ty_tab( BASE lt_people ( id = 4 name = `Dorothy` ) ).
```

Without `BASE`, `lt_more` holds one row. With it, it holds the old rows plus the new one. The same applies to structures, and there it costs a field rather than a table: `ls = VALUE ty_s( a = 1 ).` clears `b`, every time.

`LINES OF` splices a table in rather than nesting it:

```abap
DATA(lt_all) = VALUE ty_tab( ( LINES OF lt_more ) ( id = 5 name = `Mary` ) ).
```

## `#` means "you already know the type"

`VALUE #( … )` asks the compiler to take the type from the context — the type of the variable being assigned to, or of the parameter being passed. Where there is no context to take it from, `#` is a syntax error and you name the type instead. This is the same `#` as in [`NEW`](../new/README.md), [`CONV`](../cast_conv/README.md) and [`CORRESPONDING`](../corresponding/README.md), and it always means the same thing.

A frequent use has no assignment at all:

```abap
APPEND VALUE #( id = 2 name = `Grace` ) TO lt_people.
```

The parameter's type supplies the `#`, and no work area is declared for a single row.

## Nesting, and where it stops paying

A table of structures, each containing a table, can be written as one `VALUE` expression — and at about three levels deep it becomes something nobody can review. The construct scales further than readability does; the test is whether a colleague can see the shape at a glance.

<!-- snippet:z_kw_value -->
*[`z_kw_value.prog.abap`](snippets/z_kw_value.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_value.

TYPES: BEGIN OF ty_line,
         id   TYPE i,
         name TYPE string,
       END OF ty_line.
TYPES ty_tab TYPE STANDARD TABLE OF ty_line WITH EMPTY KEY.

" A structure, filled in one expression. Components not named stay initial.
DATA(ls_one) = VALUE ty_line( id = 1 name = `Ada` ).

" A table: one pair of parentheses per row.
DATA(lt_people) = VALUE ty_tab( ( id = 1 name = `Ada` )
                                ( id = 2 name = `Grace` )
                                ( id = 3 name = `Katherine` ) ).

" BASE keeps what is already there; without it the value starts empty.
DATA(lt_more) = VALUE ty_tab( BASE lt_people ( id = 4 name = `Dorothy` ) ).

" LINES OF splices another table in rather than nesting it.
DATA(lt_all) = VALUE ty_tab( ( LINES OF lt_more ) ( id = 5 name = `Mary` ) ).

" The # stands for "the type is obvious here" -- obvious to the compiler, that
" is, from the context. lines( ) takes a table, so # is ty_tab.
DATA(lv_rows) = lines( VALUE ty_tab( ( id = 9 name = `Solo` ) ) ).

LOOP AT lt_all INTO DATA(ls_row).
  WRITE: / ls_row-id, ls_row-name.
ENDLOOP.
WRITE: / 'first  :', ls_one-name.
WRITE: / 'inline :', lv_rows.
```
<!-- /snippet -->

## If you are coming from another language

- **Python.** The list-of-dicts literal, with one difference that matters: the shape is checked against a declared type, so a misspelled component is a syntax error rather than a new key.
- **Rust.** A struct literal plus `vec![]`. `BASE` is Rust's `..other` struct-update syntax, in the same position and for the same reason.
- **JavaScript.** Object and array literals, with `BASE` playing the part of the spread operator.

## See also

- [`FOR`](../for/README.md) — the loop that goes *inside* a `VALUE`, turning one table into another
- [`CORRESPONDING`](../corresponding/README.md) — building a value out of another value with matching component names
- [`TYPES` and `CONSTANTS`](../types/README.md) — where the named type comes from
- [`NEW`](../new/README.md) — the same idea for objects and data references
- [Changing a table](../itab_changes/README.md) — `APPEND`, `INSERT`, and which one the table kind allows
