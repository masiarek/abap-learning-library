# `FILTER` — a subset, if the table has the right key

**Level:** 301 · deep dive

**One line:** `FILTER #( itab USING KEY k WHERE … )` returns the rows that match, `EXCEPT` inverts it, and the catch is in the requirement: the condition must be on a **key** of the source table, so `FILTER` is unavailable on exactly the ad-hoc tables where a filter is most tempting.

## The shape

```abap
DATA(lt_eu)     = FILTER #( lt_rows USING KEY by_region WHERE region = `EU` ).
DATA(lt_not_eu) = FILTER #( lt_rows EXCEPT USING KEY by_region WHERE region = `EU` ).
```

The source table needs a sorted or hashed key covering the condition's fields — either its primary key, or a secondary key declared for the purpose:

```abap
TYPES ty_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY
             WITH NON-UNIQUE SORTED KEY by_region COMPONENTS region.
```

That is the real cost of `FILTER`: it is not a function you can apply to any table, it is an operation a table must be *declared* to support. When the declaration is already there for other reasons, `FILTER` is the shortest and fastest way to take a subset. When it is not, adding a secondary key to enable one filter is paying maintenance cost on every insert for the life of the table.

## The alternatives, and when each wins

| Form | Needs | Good for |
|---|---|---|
| `FILTER #( … )` | a key on the filtered fields | a subset taken repeatedly, on a table that already has the key |
| `VALUE #( FOR … WHERE ( … ) )` | nothing | any table, any condition an internal-table `WHERE` allows |
| `LOOP AT … WHERE … APPEND` | nothing | when each row needs work as well as selection |

`FILTER` also has a second form that filters against **another table** — `FILTER #( lt_rows IN lt_keys WHERE id = key_id )` — which is the in-memory equivalent of a semi-join, and a genuinely good reason to reach for it.

## Do not filter what you should not have selected

A `FILTER` over a table that came straight from the database is a `WHERE` clause that was left out of the `SELECT`. The database can do the filtering with an index, over rows it never sends; this does it in application memory, over rows already transferred. See [Open SQL](../../03_Topics/open_sql/README.md).

<!-- snippet:z_kw_filter -->
*[`z_kw_filter.prog.abap`](snippets/z_kw_filter.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_filter.

TYPES: BEGIN OF ty_row,
         region TYPE string,
         active TYPE abap_bool,
         name   TYPE string,
       END OF ty_row.
" FILTER needs a key it can search on, so the source table is declared with one.
TYPES ty_tab TYPE STANDARD TABLE OF ty_row WITH NON-UNIQUE SORTED KEY by_region
                                           COMPONENTS region.

DATA(lt_rows) = VALUE ty_tab( ( region = `EU` active = abap_true  name = `Ada` )
                              ( region = `US` active = abap_false name = `Grace` )
                              ( region = `EU` active = abap_false name = `Mary` ) ).

" FILTER keeps the rows that match a condition on the named key.
DATA(lt_eu) = FILTER #( lt_rows USING KEY by_region WHERE region = `EU` ).
WRITE: / 'eu rows', lines( lt_eu ).

" EXCEPT inverts it: keep what does NOT match.
DATA(lt_not_eu) = FILTER #( lt_rows EXCEPT USING KEY by_region WHERE region = `EU` ).
WRITE: / 'other rows', lines( lt_not_eu ).

" The same job written as a loop, for comparison. FILTER is shorter; it is also
" limited to conditions on a key, which is why LOOP never goes away.
DATA lt_manual TYPE ty_tab.
LOOP AT lt_rows INTO DATA(ls_row) WHERE region = `EU`.
  APPEND ls_row TO lt_manual.
ENDLOOP.
WRITE: / 'manual  ', lines( lt_manual ).
```
<!-- /snippet -->

## If you are coming from another language

- **Python.** `[r for r in rows if …]` works on anything. ABAP's equivalent of that generality is `VALUE #( FOR … WHERE … )`; `FILTER` is the specialised, indexed version with no Python counterpart.
- **Rust.** `.filter()` on an iterator is the general case; `FILTER` is closer to a range query on a `BTreeMap`.
- **SQL.** The two-table form is a semi-join, and the single-table form is a `WHERE` on an indexed column.

## See also

- [`FOR`](../for/README.md) — the general-purpose filter, on any table
- [Internal tables](../../03_Topics/internal_tables/README.md) — secondary keys, and what they cost on every write
- [`LOOP AT`](../loop_at/README.md) — `USING KEY`, the same idea in the statement form
- [Performance](../../03_Topics/performance/README.md) — when a key earns its keep
