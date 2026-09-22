# Dynamic programming — names decided at runtime

**Level:** 301 · deep dive

**One line:** ABAP lets you name a table, a field, a class or a method as a *string* at runtime — which is how every generic tool in SAP is built, and which moves every check the compiler was doing (does it exist, is the type right, may this user see it) to runtime, where it becomes your problem.

## The four doors

| What is dynamic | Written as |
|---|---|
| A database table or field | `SELECT * FROM (lv_table)`, `SELECT (lv_fields) FROM …` |
| A component of a structure | `ASSIGN COMPONENT lv_name OF STRUCTURE ls_x TO <fs>` |
| A whole data object | `CREATE DATA lr_x TYPE (lv_type)`, `ASSIGN ('SY-UZEIT') TO <fs>` |
| A class or method | `CREATE OBJECT lo_x TYPE (lv_class)`, `CALL METHOD lo_x->(lv_method)` |

RTTI — `cl_abap_typedescr=>describe_by_data( )` and the `cl_abap_structdescr` / `cl_abap_tabledescr` / `cl_abap_classdescr` family — is the read side: given a value, describe its type, walk its components, and build a new type from a component list with `create( )`. That pair, dynamic access plus RTTI, is what a table display, a file exporter or a generic converter is made of.

## What you give up

- **The compiler.** A misspelled field name is `sy-subrc = 4`, not a syntax error.
- **The where-used list.** A method called through a variable is invisible to `SE84`, to ADT's references, and to the colleague deciding whether a method is still used.
- **Refactoring.** Renaming a field cannot update a string.
- **Authorization clarity.** `SELECT * FROM (lv_table)` will happily read a table the program was never meant to touch, which makes the [authorization check](../authorizations/README.md) both more important and harder to write.
- **The optimiser's help.** A dynamic `WHERE` built as text is a query the ATC cannot check for an index — and a place SQL injection becomes possible, if any part of that text came from a user.

## Where it is the right answer

A tool that must work on structures nobody has written yet: a download, a comparison report, a mapping engine, a test-data generator. The test is whether the *set of types* is open. If it is closed — three document types, five statuses — an interface with three implementations is better in every way the list above describes.

<!-- snippet:z_tp_dynamic -->
*[`z_tp_dynamic.prog.abap`](snippets/z_tp_dynamic.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_tp_dynamic.

PARAMETERS p_table TYPE tabname DEFAULT 'SCARR'.
PARAMETERS p_field TYPE fieldname DEFAULT 'CARRNAME'.

START-OF-SELECTION.

  " A table named at runtime. Everything the compiler would normally check --
  " does the table exist, does the field, may this user read it -- moves to
  " runtime, and so does every error.
  DATA lr_rows TYPE REF TO data.
  FIELD-SYMBOLS <lt_rows> TYPE STANDARD TABLE.
  FIELD-SYMBOLS <lv_value> TYPE any.

  CREATE DATA lr_rows TYPE STANDARD TABLE OF (p_table).
  ASSIGN lr_rows->* TO <lt_rows>.

  SELECT * FROM (p_table)
    INTO TABLE @<lt_rows>
    UP TO 5 ROWS.

  " Reading a component whose name is only known now.
  LOOP AT <lt_rows> ASSIGNING FIELD-SYMBOL(<ls_row>).
    ASSIGN COMPONENT p_field OF STRUCTURE <ls_row> TO <lv_value>.
    IF sy-subrc = 0.
      WRITE: / <lv_value>.
    ELSE.
      WRITE: / 'no such field in this table'.
      EXIT.
    ENDIF.
  ENDLOOP.

  " Calling a method whose name is a string. The same trade: no compiler, no
  " where-used list, and a refactoring tool cannot see this call at all.
  DATA(lv_method) = `GET_TEXT`.
  DATA(lo_error) = NEW cx_sy_zerodivide( ).
  DATA lv_text TYPE string.
  CALL METHOD lo_error->(lv_method)
    RECEIVING
      result = lv_text.
  WRITE: / lv_text.
```
<!-- /snippet -->

## If you are coming from another language

- **Python.** `getattr`, `setattr` and `__import__` — the same power with the same trade, except Python code is dynamic throughout while ABAP's static half is where the safety was.
- **Java / C#.** Reflection, including the performance cost and the tooling blindness.
- **Rust.** No equivalent, deliberately: generics and traits cover the cases that can be closed, and the open cases are pushed to serialisation formats.

## See also

- [`FIELD-SYMBOLS` and `ASSIGN`](../../02_Keywords/field_symbols/README.md) — the access mechanism, in detail
- [`DESCRIBE` and `lines( )`](../../02_Keywords/describe_lines/README.md) — the old statement-shaped ancestor of RTTI
- [Authorizations](../authorizations/README.md) — why a dynamic read needs an explicit check
- [Performance](../performance/README.md) — dynamic access is not free, and the cost is per row
