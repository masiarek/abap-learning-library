# `SORT` and `DELETE ADJACENT DUPLICATES` — the pair that must be used together

**Level:** 201 · working knowledge

**One line:** `DELETE ADJACENT DUPLICATES` compares **neighbouring rows only**, so it removes every duplicate on a table sorted by the same fields it compares and an arbitrary subset on any other table — and a bare `SORT itab.` on a table declared `WITH EMPTY KEY` sorts by nothing at all.

## Always name the fields

```abap
SORT lt_rows BY region ASCENDING name DESCENDING.
```

`SORT itab.` without `BY` sorts by the table's primary key. For a `STANDARD TABLE WITH EMPTY KEY` — the declaration the modern style guides recommend — that key is empty, so the statement is a no-op that looks like a sort. On an older table with a default key it sorts by *every* non-numeric field, which is slow and rarely what was meant.

Naming the fields is not a style preference. It is the difference between a sort and a statement that appears to sort.

## The duplicate rule

```abap
SORT lt_rows BY region name.
DELETE ADJACENT DUPLICATES FROM lt_rows COMPARING region name.
```

`COMPARING` names the fields that decide sameness, and the statement only ever looks at the row before. Sort by one set of fields and compare another and the result is *some* duplicates removed — a bug that survives testing, because small test data usually happens to be in a helpful order.

`COMPARING ALL FIELDS` is the honest form when "duplicate" means "identical row". The default, with no `COMPARING`, is the table's key — which is empty as often as it is useful.

## Cost, and the alternative

`SORT` is O(n log n) and it moves rows, so on a wide table it moves a lot of bytes. Where the same ordering is needed repeatedly, a `SORTED TABLE` type keeps the order continuously and needs no `SORT` statement at all; where uniqueness is the point, a `UNIQUE KEY` refuses the duplicate on insertion instead of deleting it later. Both are declarations rather than statements, which means they cannot be forgotten in the one branch that also inserts a row. See [Internal tables](../../03_Topics/internal_tables/README.md).

And if the rows came from the database, `ORDER BY` there is usually cheaper than `SORT` here — the database has indexes and this program does not. See [Open SQL](../../03_Topics/open_sql/README.md).

## Stability

`SORT` is **not** stable by default: rows with equal keys may change their relative order. `SORT … STABLE` keeps it, at a cost. Code that sorts twice — once by a secondary criterion, then by a primary one — depends on stability whether its author knew it or not.

<!-- snippet:z_kw_sort -->
*[`z_kw_sort.prog.abap`](snippets/z_kw_sort.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_sort.

TYPES: BEGIN OF ty_row,
         region TYPE string,
         name   TYPE string,
       END OF ty_row.
TYPES ty_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

DATA(lt_rows) = VALUE ty_tab( ( region = `US` name = `Grace` )
                              ( region = `EU` name = `Ada` )
                              ( region = `EU` name = `Ada` )
                              ( region = `EU` name = `Katherine` ) ).

" Always name the fields. A bare SORT sorts by the table's key, which for a
" STANDARD TABLE WITH EMPTY KEY means it sorts by nothing at all.
SORT lt_rows BY region ASCENDING name DESCENDING.

LOOP AT lt_rows INTO DATA(ls_row).
  WRITE: / ls_row-region, ls_row-name.
ENDLOOP.

" DELETE ADJACENT DUPLICATES compares NEIGHBOURS. On an unsorted table it
" removes some duplicates and keeps others, quietly. Sort first, by the same
" fields you then compare.
SORT lt_rows BY region name.
DELETE ADJACENT DUPLICATES FROM lt_rows COMPARING region name.
WRITE: / 'rows left', lines( lt_rows ).

" COMPARING ALL FIELDS is the honest default when you mean "identical rows".
DELETE ADJACENT DUPLICATES FROM lt_rows COMPARING ALL FIELDS.
WRITE: / 'rows left', lines( lt_rows ).
```
<!-- /snippet -->

## If you are coming from another language

- **Python.** `list.sort()` is stable, always, and `dict.fromkeys()` de-duplicates regardless of order. Both ABAP statements are less forgiving than the Python habits they resemble.
- **Rust.** `sort_by_key` (stable) and `sort_unstable_by_key`, with `dedup()` carrying the same adjacent-only rule as ABAP's — Rust's documentation says so loudly, and so does this page.
- **SQL.** `ORDER BY` and `SELECT DISTINCT`, neither of which cares what order the rows were in.

## See also

- [Changing a table](../itab_changes/README.md) — the other statements that modify a table in place
- [Internal tables](../../03_Topics/internal_tables/README.md) — sorted and hashed tables, which need neither statement
- [`LOOP AT`](../loop_at/README.md) — `GROUP BY`, which groups by value and needs no prior sort
- [Performance](../../03_Topics/performance/README.md) — when sorting is the cheap part
- [Control breaks](../at_new/README.md) — `AT NEW`, `AT END OF`, `SUM` — the older way to total per group
