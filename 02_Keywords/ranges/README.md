# Ranges tables — `TYPE RANGE OF`, and what `SELECT-OPTIONS` really gives you

**Level:** 201 · working knowledge

**One line:** A ranges table is an internal table with four columns — `sign`, `option`, `low`, `high` — where each row is one condition, and `IN` evaluates the whole table in Open SQL and in ABAP alike; `SELECT-OPTIONS` builds one from a screen, `TYPE RANGE OF` declares one by hand, and an **empty** one means *no restriction*.

## The shape

```abap
TYPES ty_carrier_range TYPE RANGE OF scarr-carrid.

DATA(lt_carriers) = VALUE ty_carrier_range(
  ( sign = 'I' option = 'EQ' low = 'LH' )
  ( sign = 'I' option = 'BT' low = 'DL' high = 'DZ' )
  ( sign = 'E' option = 'CP' low = 'X*' ) ).

SELECT … WHERE carrid IN @lt_carriers …
IF lv_carrier IN lt_carriers.
```

`sign` is `I` (include) or `E` (exclude); `option` is a comparison — `EQ`, `NE`, `BT`, `NB`, `GT`, `GE`, `LT`, `LE`, `CP` (pattern with `*` and `+`), `NP`. The includes are OR-ed together, then the excludes are removed. That is the whole semantics, and it is more expressive than most hand-written `WHERE` clauses.

`RANGES` is the obsolete declaration statement; `TYPE RANGE OF` is the current one.

## The two things to know

**Empty means everything.** `WHERE carrid IN @lt_empty` selects every row. On a selection screen that is the feature — a blank field means "all". In code that builds a ranges table from data, an unexpectedly empty table is a full-table read, exactly like the [`FOR ALL ENTRIES`](../../03_Topics/open_sql/README.md) trap.

**Size has a limit.** A ranges table is turned into a `WHERE` clause, and a database has a maximum statement length. A ranges table with ten thousand `EQ` rows fails at runtime; the right tool for a large key list is `FOR ALL ENTRIES` or a join.

<!-- snippet:z_kw_ranges -->
*[`z_kw_ranges.prog.abap`](snippets/z_kw_ranges.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_ranges.

" A ranges table has four columns -- sign, option, low, high -- and one row
" per condition. SELECT-OPTIONS builds one for you; this builds one by hand.
TYPES ty_carrier_range TYPE RANGE OF scarr-carrid.

DATA(lt_carriers) = VALUE ty_carrier_range(
  ( sign = 'I' option = 'EQ' low = 'LH' )
  ( sign = 'I' option = 'EQ' low = 'AA' )
  ( sign = 'I' option = 'BT' low = 'DL' high = 'DZ' )
  ( sign = 'E' option = 'CP' low = 'X*' ) ).

" IN takes a ranges table in Open SQL ...
SELECT carrid, carrname
  FROM scarr
  WHERE carrid IN @lt_carriers
  INTO TABLE @DATA(lt_found).
WRITE: / 'carriers matched', lines( lt_found ).

" ... and in an ABAP condition, and in an internal table WHERE.
IF 'LH' IN lt_carriers.
  WRITE: / 'LH is inside the range'.
ENDIF.

" An EMPTY ranges table means NO restriction, not "nothing matches". On a
" selection screen that is the feature; everywhere else it is the trap.
DATA lt_none TYPE ty_carrier_range.
SELECT COUNT(*)
  FROM scarr
  WHERE carrid IN @lt_none
  INTO @DATA(lv_all).
WRITE: / 'empty range selects every carrier:', lv_all.
```
<!-- /snippet -->

## If you are coming from another language

- **SQL.** A ranges table is a serialised `WHERE` clause — `(x = 'LH' OR x BETWEEN 'DL' AND 'DZ') AND NOT x LIKE 'X%'` — as data you can build, pass and inspect.
- **Python.** A list of predicates combined with `any()`/`all()`, which ABAP evaluates for you with `IN`.

## See also

- [`PARAMETERS` and `SELECT-OPTIONS`](../parameters_select_options/README.md) — the screen that fills one
- [`SELECT`](../select/README.md) — `IN` on the database side
- [Open SQL](../../03_Topics/open_sql/README.md) — the empty-table rule's sibling
- [`IF` and `CASE`](../case_if/README.md) — `IN` as a condition in ABAP
- [Obsolete declarations](../obsolete_declarations/README.md) — `RANGES`, and the rest of the family
