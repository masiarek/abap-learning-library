# `APPEND`, `INSERT`, `MODIFY`, `DELETE` — changing an internal table

**Level:** 201 · working knowledge

**One line:** `APPEND` adds to the end and only makes sense for a standard table, `INSERT … INTO TABLE` lets the table decide where the row goes and reports a rejected duplicate as `sy-subrc = 4` rather than dumping, `MODIFY … TRANSPORTING` limits what is overwritten, and `DELETE … WHERE` as one statement beats deleting inside a loop.

## `APPEND` versus `INSERT`

```abap
APPEND VALUE #( id = 2 name = `Grace` ) TO lt_std.
INSERT VALUE #( id = 1 name = `Ada` )   INTO TABLE lt_sorted.
```

`APPEND` puts the row at the end, which is meaningful only where position is meaningful. On a **sorted** table it still compiles — the check is not a syntax check but a runtime one: the appended row has to belong at the end, and one that breaks the key order or duplicates a unique key raises an exception instead. That is a worse failure mode than a refusal, which is the argument for `INSERT … INTO TABLE` on anything that is not a plain list.

`INSERT … INTO TABLE` is the general form: the table places the row according to its key. On a `UNIQUE KEY`, a duplicate is **not** an exception — nothing is inserted and `sy-subrc` is 4. Unchecked, that is a row silently missing from a result.

`INSERT … INTO lt INDEX n` is the positional form for a standard table, and it shifts everything after it.

## `MODIFY`

```abap
MODIFY TABLE lt_sorted FROM VALUE #( id = 1 name = `Ada Lovelace` ) TRANSPORTING name.
MODIFY lt_std FROM ls_row INDEX sy-tabix.
```

`MODIFY TABLE … FROM wa` finds the row by key; `MODIFY lt … INDEX n` by position. `TRANSPORTING` limits which components are written — without it, every component of the work area lands in the row, including the ones that were initial because you never filled them. That is the quiet way to blank a field you did not intend to touch.

## `DELETE`

```abap
DELETE lt_std WHERE id > 1.                    " one statement, whole set
DELETE lt_std INDEX 1.                         " by position
DELETE ADJACENT DUPLICATES FROM lt COMPARING ALL FIELDS.
```

Deleting inside a `LOOP` renumbers the rows after the current one, so the loop skips the next row every time it deletes — the oldest off-by-one in ABAP. The `WHERE` form does the whole job in one statement, faster and without the trap. [`SORT` and adjacent duplicates](../sort/README.md) covers the third line.

## `CLEAR`, `REFRESH`, `FREE`

`CLEAR lt.` empties the table. `REFRESH` does the same and is [listed as obsolete](https://abaplint.org) — abaplint's `obsolete_statement` rule flags it, and so will your ATC run. `FREE` empties it *and* releases the memory, which matters only for tables big enough that you already know they are big.

On a **structure**, `CLEAR` sets every component to its initial value — including the ones you meant to keep. On a table it drops every row. The statement is the same word for both.

<!-- snippet:z_kw_itab_changes -->
*[`z_kw_itab_changes.prog.abap`](snippets/z_kw_itab_changes.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_itab_changes.

TYPES: BEGIN OF ty_row,
         id   TYPE i,
         name TYPE string,
       END OF ty_row.
TYPES ty_std    TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
TYPES ty_sorted TYPE SORTED TABLE OF ty_row WITH UNIQUE KEY id.

DATA lt_std    TYPE ty_std.
DATA lt_sorted TYPE ty_sorted.

" APPEND puts a row at the end. It only makes sense for a standard table --
" a sorted or hashed table decides the position itself.
APPEND VALUE #( id = 2 name = `Grace` ) TO lt_std.
APPEND VALUE #( id = 1 name = `Ada` )   TO lt_std.

" INSERT ... INTO TABLE lets the table place the row. On a unique key a
" duplicate does not dump: it sets sy-subrc = 4 and inserts nothing.
INSERT VALUE #( id = 1 name = `Ada` )     INTO TABLE lt_sorted.
INSERT VALUE #( id = 1 name = `Ada II` )  INTO TABLE lt_sorted.
WRITE: / 'duplicate rejected with sy-subrc', sy-subrc.

" MODIFY by key changes the row that matches; TRANSPORTING limits what moves.
MODIFY TABLE lt_sorted FROM VALUE #( id = 1 name = `Ada Lovelace` )
       TRANSPORTING name.

" DELETE by condition is one statement, and much faster than a LOOP with a
" DELETE inside it -- which also renumbers the index under your feet.
DELETE lt_std WHERE id > 1.

" INSERT at an index is the standard-table form, and shifts everything after it.
INSERT VALUE #( id = 9 name = `Nine` ) INTO lt_std INDEX 1.

LOOP AT lt_std INTO DATA(ls_std).
  WRITE: / 'std', ls_std-id, ls_std-name.
ENDLOOP.
LOOP AT lt_sorted INTO DATA(ls_sorted).
  WRITE: / 'srt', ls_sorted-id, ls_sorted-name.
ENDLOOP.

CLEAR lt_std.
WRITE: / 'cleared to', lines( lt_std ).
```
<!-- /snippet -->

## If you are coming from another language

- **Python.** `list.append`, `dict[k] = v`, `del`, `clear()`. The trap Python does not have is `MODIFY` without `TRANSPORTING`, because assigning a dict does not silently blank unnamed keys.
- **Rust.** `push`, `insert`, `retain` (which is `DELETE … WHERE`, done safely), and the borrow checker refusing the delete-inside-a-loop bug outright.
- **SQL.** The names line up — `INSERT`, `UPDATE`, `DELETE … WHERE` — which is a useful mnemonic and a reminder that this table is in memory and not transactional.

## See also

- [`SORT` and adjacent duplicates](../sort/README.md) — the statement that must follow a matching sort
- [Internal tables](../../03_Topics/internal_tables/README.md) — which statements each table kind allows
- [`LOOP AT`](../loop_at/README.md) — why the delete belongs outside the loop
- [`VALUE`](../value/README.md) — building the row being inserted
