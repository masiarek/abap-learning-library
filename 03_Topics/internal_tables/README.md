# Internal tables — three kinds, three promises

**Level:** 201 · working knowledge

**One line:** An internal table is ABAP's only collection, and the kind you declare — `STANDARD`, `SORTED`, `HASHED` — is a promise about what a lookup costs and whether duplicates are allowed, made once in the type and paid on every read and every write for the life of the program.

## The choice

| Kind | Lookup by full key | Keeps insertion order | Duplicates | Index access |
|---|---|---|---|---|
| `STANDARD` | linear scan | yes | yes | yes |
| `SORTED` | binary search | no — key order | optional (`UNIQUE`/`NON-UNIQUE`) | yes |
| `HASHED` | one step, size-independent | no | never — `UNIQUE` only | **no** |

A hashed table has no index at all. `lt[ 3 ]` is a syntax error on one, and that is the type doing its job: there is no third row, only rows.

The rule of thumb that survives contact with real code: **standard** while the table is being built and looped over in full, **hashed** for a lookup dictionary read by full key, **sorted** when reads use a partial key or a range, or when the order itself matters.

## The key, and `WITH EMPTY KEY`

```abap
TYPES ty_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
```

`WITH EMPTY KEY` says, explicitly, that this table has no key. It is the honest declaration for a list — and it means a bare `SORT itab.` sorts by nothing, `READ TABLE … WITH TABLE KEY` has nothing to read by, and `DELETE ADJACENT DUPLICATES` without `COMPARING` compares nothing. Name fields in those statements; see [`SORT`](../../02_Keywords/sort/README.md).

The older alternative, `WITH DEFAULT KEY`, silently makes the key *every non-numeric field* — slow, surprising, and still the default in plenty of legacy declarations.

## Secondary keys

```abap
TYPES ty_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY
             WITH NON-UNIQUE SORTED KEY by_region COMPONENTS region.
```

A secondary key is an index kept alongside the table: reads that name it (``lt[ KEY by_region region = `EU` ]``, `LOOP AT … USING KEY by_region`) get the fast path, and everything else is unchanged. The cost is not free — the index is maintained lazily but it *is* maintained, so a table written far more often than it is read is the wrong place for one.

A read that does **not** name the key does not use it. That is the single most common disappointment with secondary keys: the declaration is added, the code is not changed, and nothing gets faster.

## What it costs to get this wrong

The nested loop over two standard tables is the defining ABAP performance bug: a thousand rows against a thousand rows is a million comparisons, and it grows as the square while the test system's ten rows stay instant. The fix is a keyed lookup, and it is a change to a *declaration* plus one read. See [Performance](../performance/README.md).

<!-- snippet:z_tp_itab_kinds -->
*[`z_tp_itab_kinds.prog.abap`](snippets/z_tp_itab_kinds.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_tp_itab_kinds.

TYPES: BEGIN OF ty_row,
         id     TYPE i,
         region TYPE string,
         name   TYPE string,
       END OF ty_row.

" The three kinds are three different promises about lookup, order and duplicates.
TYPES ty_standard TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
TYPES ty_sorted   TYPE SORTED   TABLE OF ty_row WITH UNIQUE KEY id.
TYPES ty_hashed   TYPE HASHED   TABLE OF ty_row WITH UNIQUE KEY id.

" A secondary key buys a fast lookup on a table that still keeps insertion
" order for everything else. The cost is paid on every change to the table.
TYPES ty_both TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY
              WITH NON-UNIQUE SORTED KEY by_region COMPONENTS region.

DATA(lt_std)    = VALUE ty_standard( ( id = 2 region = `EU` name = `Grace` )
                                     ( id = 1 region = `US` name = `Ada` ) ).
DATA lt_sorted TYPE ty_sorted.
DATA lt_hashed TYPE ty_hashed.
DATA lt_both   TYPE ty_both.

" A sorted table keeps itself in key order: INSERT ... INTO TABLE, never APPEND.
INSERT LINES OF lt_std INTO TABLE lt_sorted.
INSERT LINES OF lt_std INTO TABLE lt_hashed.
INSERT LINES OF lt_std INTO TABLE lt_both.

" Reading by the full key: the hashed table gets there in one step whatever the
" table's size; the sorted table halves the search; the standard table walks.
DATA(ls_hash) = VALUE #( lt_hashed[ id = 1 ] OPTIONAL ).
DATA(ls_sort) = VALUE #( lt_sorted[ id = 1 ] OPTIONAL ).
DATA(ls_walk) = VALUE #( lt_std[ id = 1 ]    OPTIONAL ).

" The secondary key is named explicitly, or the read falls back to the walk.
DATA(ls_by_region) = VALUE #( lt_both[ KEY by_region region = `EU` ] OPTIONAL ).

WRITE: / 'hashed  ', ls_hash-name.
WRITE: / 'sorted  ', ls_sort-name.
WRITE: / 'standard', ls_walk-name.
WRITE: / 'secondary key', ls_by_region-name.

" A hashed table has no index at all: reading by position is a syntax error,
" and that is the point -- there is no position to read.
LOOP AT lt_hashed INTO DATA(ls_any).
  WRITE: / 'hashed row', ls_any-id, ls_any-name.
ENDLOOP.
```
<!-- /snippet -->

## If you are coming from another language

- **Python.** `list`, `dict` and `sorted` containers, except the choice is part of the table's declared type rather than a different class. `HASHED … WITH UNIQUE KEY id` is `dict[id] = row`, with the row still carrying its own `id`.
- **Rust.** `Vec`, `HashMap`, `BTreeMap` — the same three, with the same cost profile. ABAP's secondary key has no direct equivalent: it is a `HashMap` index kept beside a `Vec`, maintained for you.
- **Java.** `ArrayList`, `HashMap`, `TreeMap`. The ABAP peculiarity is that the row type is the same in all three — you do not wrap it in an entry or a pair.

## See also

- [`LOOP AT`](../../02_Keywords/loop_at/README.md) — walking a table, and `USING KEY`
- [`READ TABLE` and table expressions](../../02_Keywords/read_table/README.md) — reading one row from it
- [Changing a table](../../02_Keywords/itab_changes/README.md) — which statement each kind allows
- [`SORT` and adjacent duplicates](../../02_Keywords/sort/README.md) — the pair that needs a matching sort
- [Performance](../performance/README.md) — the nested loop, and how to measure instead of guess
- [`COLLECT`](../../02_Keywords/collect/README.md) — totals by key without a loop
- [Control breaks](../../02_Keywords/at_new/README.md) — `AT NEW`, `AT END OF`, `SUM` — the older way to total per group
- [Meshes](../../02_Keywords/mesh/README.md) — tables with declared associations
