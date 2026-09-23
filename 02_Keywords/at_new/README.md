# `AT NEW`, `AT END OF`, `SUM` — control breaks

**Level:** 201 · working knowledge

**One line:** Control-break statements inside a `LOOP AT` fire when a component's value changes from the previous row (`AT NEW`), is about to change (`AT END OF`), or at the first and last row — with `SUM` filling the numeric fields with group totals — and every one of them assumes the table is **sorted by the break fields**, which nothing enforces.

## The shape

```abap
SORT lt_rows BY region city.
LOOP AT lt_rows INTO DATA(ls_row).
  AT NEW region.            " first row of a new region value
  ENDAT.
  AT END OF region.         " last row of that value
    SUM.                    " numeric fields now hold the region totals
  ENDAT.
ENDLOOP.
```

`AT FIRST` and `AT LAST` bracket the whole loop. `SUM` inside `AT LAST` gives the grand total. It all reads naturally, and the rules underneath are why [`GROUP BY`](../loop_at/README.md) exists:

- **Adjacency, not value.** A break fires when the value *differs from the previous row's*. An unsorted table produces a break per change, not per group.
- **The break field and everything to its left.** `AT NEW city` fires when `city` **or any component before it** changes. Component order in the structure is part of the logic.
- **Masking.** Inside `AT NEW`/`AT END OF`, every component *after* the break field is overwritten with asterisks in the work area. Reading `ls_row-city` inside `AT NEW region` gives `**********`, not the city.
- **`SUM` needs a work area**: `INTO`, not `ASSIGNING`, and it sums *all* numeric components — including an `id` you did not mean to add up.

## What replaced it

`LOOP AT … GROUP BY` (7.40) groups by value, needs no sort, masks nothing, and totals with a `REDUCE` over the group members. Read `AT NEW` fluently — it is in every report older than 2015 — and write `GROUP BY`.

<!-- snippet:z_kw_at_new -->
*[`z_kw_at_new.prog.abap`](snippets/z_kw_at_new.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_at_new.

TYPES ty_amount TYPE p LENGTH 9 DECIMALS 2.
TYPES: BEGIN OF ty_row,
         region TYPE c LENGTH 2,
         city   TYPE c LENGTH 10,
         amount TYPE ty_amount,
       END OF ty_row.
TYPES ty_rows TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

DATA(lt_rows) = VALUE ty_rows( ( region = 'EU' city = 'Paris'  amount = '10.00' )
                               ( region = 'US' city = 'Boston' amount = '20.00' )
                               ( region = 'EU' city = 'Rome'   amount = '30.00' ) ).

" A control break compares with the PREVIOUS row, so the table must be sorted
" by the break fields, in that order, or the breaks fire at random.
SORT lt_rows BY region city.

LOOP AT lt_rows INTO DATA(ls_row).
  AT FIRST.
    WRITE: / 'start'.
  ENDAT.

  AT NEW region.
    " Inside AT NEW, every component AFTER the break field is masked with
    " asterisks in the work area: ls_row-city is not readable here.
    WRITE: / 'region', ls_row-region.
  ENDAT.

  WRITE: / '  ', ls_row-city, ls_row-amount.

  AT END OF region.
    " SUM fills the numeric components of the work area with the group totals.
    SUM.
    WRITE: / '  subtotal', ls_row-amount.
  ENDAT.

  AT LAST.
    SUM.
    WRITE: / 'grand total', ls_row-amount.
  ENDAT.
ENDLOOP.
```
<!-- /snippet -->

## If you are coming from another language

- **SQL.** `GROUP BY` with `SUM( )` — and the `AT NEW` model is what a report writer did before the database could do it.
- **Python.** `itertools.groupby`, which has exactly the same adjacency rule and the same "sort first" footnote.
- **awk.** The pattern `$1 != prev { … } { prev = $1 }` is `AT NEW` written by hand.

## See also

- [`LOOP AT`](../loop_at/README.md) — `GROUP BY`, the replacement
- [`COLLECT`](../collect/README.md) — totals by key without a loop at all
- [`SORT` and adjacent duplicates](../sort/README.md) — the other statement family that assumes a matching sort
- [Classic reports](../../03_Topics/classic_reports/README.md) — where control breaks came from
