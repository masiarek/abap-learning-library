# Data references — `REF`, `REF TO data`, `->*`

**Level:** 301 · deep dive

**One line:** A data reference points at a data object — an existing variable via `REF #( )`, or a fresh anonymous one via `NEW` — is dereferenced with `->*`, is tested with `IS BOUND`, and unlike a [field symbol](../field_symbols/README.md) it can be stored in a table and kept past the scope it was made in.

## The shapes

```abap
DATA(lr_total) = REF #( lv_total ).      " points AT lv_total; no copy
lr_total->* = lr_total->* + 5.           " lv_total is now 15

DATA(lr_fresh) = NEW i( 42 ).            " a new, anonymous integer
DATA(lr_row)   = NEW ty_row( id = 1 ).   " a new structure; components via ->
WRITE lr_row->id.

DATA lr_any TYPE REF TO data.            " generic: holds anything
ASSIGN lr_any->* TO FIELD-SYMBOL(<fs>).  " ...and needs a field symbol to use
```

`GET REFERENCE OF lv INTO lr.` is the statement form of `REF #( )`; `CREATE DATA lr TYPE …` is the statement form of `NEW`, and the one that can take a type name at runtime.

## Field symbol or reference

| | Field symbol | Data reference |
|---|---|---|
| Is | an alias for memory | a value that points at memory |
| Stored in a table, passed around, kept | no | yes |
| Dereferenced as | `<fs>` | `lr->*`, `lr->comp` |
| Tested with | `IS ASSIGNED` | `IS BOUND` |
| Generic form | `TYPE any` | `TYPE REF TO data` |

The rule of thumb from the [field symbol page](../field_symbols/README.md) holds: a field symbol to work *here*, a reference to hold on to something *later*. `LOOP AT … REFERENCE INTO DATA(lr)` is the loop form when the row must outlive the pass.

## What a generic reference costs

`REF TO data` erases the static type. Nothing can be done with it until a cast (`CAST` to a typed reference) or an `ASSIGN lr->* TO <fs>` restores one — at which point every check the compiler would have made happens at runtime. This is the mechanism under every generic container in SAP, and it belongs in [dynamic programming](../../03_Topics/dynamic_programming/README.md), not in ordinary code that knows its types.

<!-- snippet:z_kw_data_references -->
*[`z_kw_data_references.prog.abap`](snippets/z_kw_data_references.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_data_references.

DATA lv_total TYPE i VALUE 10.

" REF #( ) takes a reference to a variable that already exists. No copy: the
" reference and the variable are the same memory.
DATA(lr_total) = REF #( lv_total ).
lr_total->* = lr_total->* + 5.
WRITE: / 'via the reference', lv_total.

" NEW allocates a fresh, anonymous object; the reference is its only name.
DATA(lr_fresh) = NEW i( 42 ).
WRITE: / 'anonymous', lr_fresh->*.

" A reference to a structure reaches its components with ->.
TYPES: BEGIN OF ty_row,
         id   TYPE i,
         name TYPE string,
       END OF ty_row.
DATA(lr_row) = NEW ty_row( id = 1 name = `Ada` ).
WRITE: / lr_row->id, lr_row->name.

" REF TO data holds anything -- and gives nothing back without a cast or a
" field symbol, because the compiler no longer knows what is behind it.
DATA lr_any TYPE REF TO data.
lr_any = lr_row.
FIELD-SYMBOLS <ls_row> TYPE ty_row.
ASSIGN lr_any->* TO <ls_row>.
WRITE: / 'through REF TO data', <ls_row>-name.

" IS BOUND is the test. Dereferencing an unbound reference is a short dump.
DATA lr_unset TYPE REF TO i.
IF lr_unset IS NOT BOUND.
  WRITE: / 'unbound, and tested before use'.
ENDIF.

" A reference into a table row stays valid as long as the row does, which is
" how a LOOP ... REFERENCE INTO keeps hold of a row after the loop ends.
DATA lt_rows TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
APPEND lr_row->* TO lt_rows.
LOOP AT lt_rows REFERENCE INTO DATA(lr_kept).
  lr_kept->name = to_upper( lr_kept->name ).
ENDLOOP.
WRITE: / 'kept after the loop', lr_kept->name.
```
<!-- /snippet -->

## If you are coming from another language

- **C.** `&x` is `REF #( x )`, `*p` is `p->*`, `malloc` is `NEW`, `void *` is `REF TO data`. No pointer arithmetic, no casting between unrelated types, and no dangling references — the object lives while anything points at it.
- **Rust.** `Box::new` and `&mut`, without the ownership rules; two references to one object are fine.
- **Java.** Every object variable is already a reference; ABAP needs the explicit form only because plain variables are values.

## See also

- [`FIELD-SYMBOLS` and `ASSIGN`](../field_symbols/README.md) — the alternative, and the table comparing them
- [`NEW`](../new/README.md) — creating the anonymous object
- [`CAST`, `CONV` and `EXACT`](../cast_conv/README.md) — getting a typed reference back
- [Dynamic programming](../../03_Topics/dynamic_programming/README.md) — `CREATE DATA` with a runtime type
- [`LOOP AT`](../loop_at/README.md) — `REFERENCE INTO`
