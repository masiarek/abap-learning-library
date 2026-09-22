# `FIELD-SYMBOLS` and `ASSIGN` — another name for memory you already have

**Level:** 201 · working knowledge

**One line:** A field symbol is not a variable and not a pointer you can test with `IS INITIAL` — it is an alias for a piece of memory, `ASSIGN` is what points it somewhere, `IS ASSIGNED` is how you ask whether it points anywhere at all, and using an unassigned one is a short dump rather than an initial value.

## Why they exist

```abap
LOOP AT lt_rows ASSIGNING FIELD-SYMBOL(<ls_row>).
  <ls_row>-name = to_upper( <ls_row>-name ).
ENDLOOP.
```

This is the common case, and the reason most ABAP developers meet field symbols in week one: `ASSIGNING` writes into the table itself, while `INTO` writes into a copy that is then thrown away. See [`LOOP AT`](../loop_at/README.md).

The angle brackets are part of the name. The convention `<ls_…>` / `<lv_…>` / `<lt_…>` follows the same shape as ordinary variable prefixes.

## `IS ASSIGNED`, not `IS INITIAL`

`IS INITIAL` asks about the **value** at the other end. Whether the field symbol points anywhere is a different question:

```abap
IF <lv_any> IS ASSIGNED.
UNASSIGN <lv_any>.
```

Touching an unassigned field symbol raises `CX_SY_UNASSIGNED_FIELD` — it dumps, it does not quietly act like an empty value. After a failed `ASSIGN`, `sy-subrc` is non-zero and the field symbol is left unassigned, so both tests work; pick one and be consistent.

## The dynamic half

```abap
ASSIGN COMPONENT `NAME` OF STRUCTURE ls_row TO <lv_any>.
ASSIGN COMPONENT 1      OF STRUCTURE ls_row TO <lv_any>.
ASSIGN ('SY-UZEIT') TO <lv_any>.
```

Naming a component at runtime is how every generic tool in SAP works — a table display, a file exporter, a conversion routine that must handle a structure it has never seen. It is also where the compiler stops helping: a typo in `` `NAME` `` is not an error, it is `sy-subrc = 4` at runtime, and a wrong component number is a value of the wrong type that may well convert silently.

Declare the field symbol `TYPE any` only when it really can be anything. `TYPE ty_row` or `TYPE REF TO cl_thing` gets the checks back for the cases where the target's shape *is* known.

## Field symbol or data reference?

Both give access without copying. The difference:

| | Field symbol | Data reference (`REF TO data`) |
|---|---|---|
| Written as | `<fs>` | `lr_x->*` |
| Can be stored in a table | no | yes |
| Can be passed around and kept | only within its scope | yes |
| Can be re-pointed | yes, with `ASSIGN` | yes, by assignment |

The rule of thumb: a field symbol for reading and writing *here*, a data reference for holding on to something *later*. `LOOP AT … REFERENCE INTO DATA(lr_row)` is the loop form when the reference must outlive the pass.

<!-- snippet:z_kw_field_symbols -->
*[`z_kw_field_symbols.prog.abap`](snippets/z_kw_field_symbols.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_field_symbols.

TYPES: BEGIN OF ty_row,
         id   TYPE i,
         name TYPE string,
       END OF ty_row.
TYPES ty_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

DATA(lt_rows) = VALUE ty_tab( ( id = 1 name = `Ada` )
                              ( id = 2 name = `Grace` ) ).

" A field symbol is another name for a piece of memory, not a copy of it.
" Declared up front and typed, so the compiler can check what you do with it.
FIELD-SYMBOLS <ls_row> TYPE ty_row.
LOOP AT lt_rows ASSIGNING <ls_row>.
  <ls_row>-name = to_upper( <ls_row>-name ).
ENDLOOP.

" Untyped, it can point at anything -- and nothing about it is checked until
" the ASSIGN runs. Power and the bill for it, in one declaration.
FIELD-SYMBOLS <lv_any> TYPE any.

" A component named at runtime: this is the shape of every generic table tool.
ASSIGN COMPONENT `NAME` OF STRUCTURE lt_rows[ 1 ] TO <lv_any>.
IF sy-subrc = 0.
  WRITE: / 'by name  ', <lv_any>.
ENDIF.

" ...and by position, which is how you walk a structure you have never seen.
ASSIGN COMPONENT 1 OF STRUCTURE lt_rows[ 2 ] TO <lv_any>.
IF <lv_any> IS ASSIGNED.
  WRITE: / 'by number', <lv_any>.
ENDIF.

" IS INITIAL asks about the VALUE. Ask about the pointer with IS ASSIGNED --
" using an unassigned field symbol is a short dump, not an initial value.
UNASSIGN <lv_any>.
IF <lv_any> IS NOT ASSIGNED.
  WRITE: / 'unassigned now'.
ENDIF.

" A whole variable, named as text at runtime.
ASSIGN ('SY-UZEIT') TO <lv_any>.
IF sy-subrc = 0.
  WRITE: / 'dynamic  ', <lv_any>.
ENDIF.
```
<!-- /snippet -->

## If you are coming from another language

- **C.** A field symbol is close to `T *p`, with `ASSIGN` as `p = &x` — but there is no pointer arithmetic, no casting to an unrelated type, and dereferencing an unassigned one is a controlled dump rather than undefined behaviour.
- **Rust.** `&mut x` covers the safe cases, and the dynamic `ASSIGN COMPONENT` has no safe equivalent at all — that is reflection, and in Rust it would be a macro or a trait implemented per type.
- **Python.** Names already bind rather than copy, so `ASSIGNING` is Python's default; `ASSIGN COMPONENT` is `getattr(obj, name)`, with the same runtime-only failure.

## See also

- [`LOOP AT`](../loop_at/README.md) — the loop where `ASSIGNING` matters most
- [Dynamic programming](../../03_Topics/dynamic_programming/README.md) — where the untyped form belongs, and what it costs
- [`DATA` — and `DATA( )`](../data/README.md) — the ordinary way to get a variable
- [`READ TABLE` and table expressions](../read_table/README.md) — `ASSIGNING` for a single row
