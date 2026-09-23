# `COLLECT` — summing rows into a table by key

**Level:** 201 · working knowledge

**One line:** `COLLECT wa INTO itab` finds the row whose non-numeric components match `wa` and **adds** every numeric component into it, inserting a new row only when there is no match — an aggregation in one statement, with the rule that the table's key must be exactly those non-numeric components.

## What it does

```abap
ls_row = VALUE #( region = `EU` amount = '10.00' count = 1 ).
COLLECT ls_row INTO lt_totals.
ls_row = VALUE #( region = `EU` amount = '30.00' count = 1 ).
COLLECT ls_row INTO lt_totals.       " one EU row: amount 40.00, count 2
```

The split is by type, not by name: every component that is not numeric is key, every component that is (`i`, `p`, `f`, `decfloat`) is summed. A `count TYPE i` column set to `1` in each row therefore counts rows for free — the idiom that makes `COLLECT` a one-line "group by".

## The rule that bites

On a **standard** table `COLLECT` builds a hidden hash index to find the key row quickly — and any other change to the table (`APPEND`, `INSERT`, `MODIFY`, `DELETE`, `SORT`) invalidates it, after which the next `COLLECT` falls back to a linear search or, in older releases, misbehaves. Mixing `COLLECT` with other statements on the same standard table is the classic way to get wrong totals that pass a small test.

The declaration that makes the intent unmistakable is a **hashed table with a unique key on the non-numeric components**: the key is explicit, duplicates are impossible, and `COLLECT` is the only sensible way to add to it. The program below does that.

## When `COLLECT` and when not

| Grouping is… | Reach for |
|---|---|
| exactly the table's key, all other columns summed | `COLLECT` |
| a subset of columns, or needs a non-sum (max, first, concatenation) | [`LOOP AT … GROUP BY`](../loop_at/README.md) or [`REDUCE`](../reduce/README.md) |
| on rows that came from the database | `SUM( )` and `GROUP BY` in the [`SELECT`](../select/README.md) — do not transfer rows to add them up here |

<!-- snippet:z_kw_collect -->
*[`z_kw_collect.prog.abap`](snippets/z_kw_collect.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_collect.

TYPES ty_amount TYPE p LENGTH 9 DECIMALS 2.
TYPES: BEGIN OF ty_total,
         region TYPE string,
         amount TYPE ty_amount,
         count  TYPE i,
       END OF ty_total.

" COLLECT splits a row into key and numbers: the non-numeric components are
" the key, every numeric component is summed into the row with that key. A
" hashed table declared on exactly those key fields says so out loud.
TYPES ty_totals TYPE HASHED TABLE OF ty_total WITH UNIQUE KEY region.

DATA lt_totals TYPE ty_totals.
DATA ls_row    TYPE ty_total.

ls_row = VALUE #( region = `EU` amount = '10.00' count = 1 ).
COLLECT ls_row INTO lt_totals.
ls_row = VALUE #( region = `US` amount = '20.00' count = 1 ).
COLLECT ls_row INTO lt_totals.
ls_row = VALUE #( region = `EU` amount = '30.00' count = 1 ).
COLLECT ls_row INTO lt_totals.

" Two rows, not three: the second EU row was added into the first.
LOOP AT lt_totals INTO DATA(ls_total).
  WRITE: / ls_total-region, ls_total-amount, ls_total-count.
ENDLOOP.

" The same fold as an expression, for comparison. COLLECT is shorter when the
" table's key already IS the grouping; REDUCE or GROUP BY when it is not.
DATA(lv_grand) = REDUCE ty_amount( INIT s = 0
                                   FOR ls_t IN lt_totals
                                   NEXT s = s + ls_t-amount ).
WRITE: / 'grand total', lv_grand.
```
<!-- /snippet -->

## If you are coming from another language

- **SQL.** `INSERT … ON CONFLICT DO UPDATE SET amount = amount + …` — an upsert with addition, on a table in memory.
- **Python.** `collections.Counter` or `defaultdict(int)` accumulation, with the row's non-numeric fields as the key.
- **Rust.** `entry(key).or_default()` on a `HashMap`, then `+=` on the value — which is also the honest description of what `COLLECT` does internally.

## See also

- [`LOOP AT`](../loop_at/README.md) — `GROUP BY`, when the grouping is not the key
- [`REDUCE`](../reduce/README.md) — folding to a single value instead of a table
- [`AT NEW`, `AT END OF`, `SUM`](../at_new/README.md) — the older control-break way to total per group
- [Internal tables](../../03_Topics/internal_tables/README.md) — why the hashed declaration makes the key explicit
- [Changing a table](../itab_changes/README.md) — the statements that invalidate `COLLECT`'s index
