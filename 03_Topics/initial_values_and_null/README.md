# Initial values and null — ABAP has no null

**Level:** 101 · newcomer

**One line:** Every ABAP variable holds its type's **initial value** from the moment it exists — `0`, blanks, `00000000`, an empty string, an unbound reference — and there is no null: `IS INITIAL` asks whether a value is that initial value, `IS BOUND` whether a reference points anywhere, and a real SQL `NULL` is something you can only meet in Open SQL, with `IS NULL`.

## The initial values

| Type | Initial value | Looks like |
|---|---|---|
| `i`, `p`, `f`, `decfloat` | zero | `0` |
| `c LENGTH n` | `n` blanks | `'   '` |
| `n LENGTH n` | `n` zeros | `'0000'` |
| `d` | `'00000000'` | not a date, and not null |
| `t` | `'000000'` | midnight, or nothing — you cannot tell |
| `string`, `xstring` | empty | an empty string |
| `x LENGTH n` | zero bytes | `00 00` |
| reference | unbound | `IS NOT BOUND`, and also `IS INITIAL` |
| structure | every component initial | |
| internal table | no rows | `lines( ) = 0` |

`CLEAR lv` resets to this. `FREE` does the same and releases memory. There is no statement that makes a variable "unset".

## The consequences

- **A date of `00000000` is a value.** It reaches the database, it sorts before every real date, and `SELECT … WHERE enddate > @sy-datum` excludes it — which is why SAP's "no end date" is `99991231`, not initial.
- **Zero and absent are the same on arrival.** An interface that sends no amount and one that sends `0` produce the same ABAP variable. If the difference matters, the payload carries a flag or the interface uses a nullable-aware format. See [JSON and XML](../json_and_xml/README.md).
- **`IS INITIAL` on a reference is `IS NOT BOUND`.** Both work; `IS BOUND` says what is meant.
- **SQL `NULL` is different.** It arises from an outer join, from a column added after rows existed, or from native SQL. Open SQL reads it into the target's *initial value* — so once it is in ABAP the distinction is gone, and the only place to test it is in the `WHERE` with `IS NULL`, or with `coalesce( )` in the column list.

<!-- snippet:z_tp_initial_values_and_null -->
*[`z_tp_initial_values_and_null.prog.abap`](snippets/z_tp_initial_values_and_null.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_tp_initial_values_and_null.

" ABAP has no null. Every variable has its type's INITIAL value from the
" moment it exists, and IS INITIAL is the test.
DATA lv_i TYPE i.
DATA lv_c TYPE c LENGTH 3.
DATA lv_d TYPE d.
DATA lv_s TYPE string.
DATA lr_r TYPE REF TO data.
DATA lt_t TYPE string_table.

WRITE: / 'i      initial?', xsdbool( lv_i IS INITIAL ), lv_i.
WRITE: / 'c      initial?', xsdbool( lv_c IS INITIAL ), '[', lv_c, ']'.
WRITE: / 'd      initial?', xsdbool( lv_d IS INITIAL ), lv_d.
WRITE: / 'string initial?', xsdbool( lv_s IS INITIAL ).
WRITE: / 'ref    initial?', xsdbool( lr_r IS INITIAL ), 'bound?', xsdbool( lr_r IS BOUND ).
WRITE: / 'table  initial?', xsdbool( lt_t IS INITIAL ).

" Initial is a VALUE, so it reaches the database as 0, '' or '00000000'. A
" real SQL NULL can only come from an outer join or a column added after the
" rows were, and Open SQL tests it with IS NULL -- a different question.
SELECT c~carrid, f~connid
  FROM scarr AS c
  LEFT OUTER JOIN sflight AS f ON f~carrid = c~carrid
  WHERE f~connid IS NULL
  INTO TABLE @DATA(lt_no_flights).
WRITE: / 'carriers with no flight rows', lines( lt_no_flights ).

" CLEAR returns a variable to its initial value. It does not make it null,
" because there is no null to make it.
lv_i = 5.
CLEAR lv_i.
WRITE: / 'after CLEAR', lv_i.

" The consequence for interfaces: "no value sent" and "zero sent" arrive
" identically. If the difference matters, the payload needs a flag.
```
<!-- /snippet -->

## If you are coming from another language

- **Go.** Zero values, exactly — Go and ABAP agree here, and both use "is it the zero value" as the idiom.
- **Java / C# / Python / JavaScript.** `null`/`None`/`undefined` exist, and their absence in ABAP is the adjustment: there is no `NullPointerException` on a value, only on a reference (`IS BOUND`), and no way to say "unknown" without an extra field.
- **SQL.** Three-valued logic stops at the Open SQL boundary; inside ABAP everything is two-valued.

## See also

- [Types at a glance](../types_at_a_glance/README.md) — every type's initial value in one program
- [Data references](../../02_Keywords/data_references/README.md) — `IS BOUND`
- [`IF` and `CASE`](../../02_Keywords/case_if/README.md) — `IS INITIAL`, `IS BOUND`, `IS ASSIGNED`
- [Open SQL](../open_sql/README.md) — outer joins and `IS NULL`
- [Dates and times](../dates_and_times/README.md) — the `00000000` and `99991231` conventions
