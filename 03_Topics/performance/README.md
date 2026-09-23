# Performance — measure, then fix the shape

**Level:** 201 · working knowledge

**One line:** ABAP performance work is dominated by two defects — a database call inside a loop, and a nested loop over unkeyed internal tables — and by one discipline: measure with the tools before changing anything, because the line everyone suspects is rarely the line that costs.

## The two defects

**A `SELECT` inside a `LOOP`.** One database round trip per row. A thousand rows is a thousand round trips, each with its own latency, on a database shared with everyone else. The fix is to select the set once and look up in memory — which turns a network cost into a hash lookup.

**A nested `LOOP` over standard tables.** Rows × rows comparisons, growing as the square: ten by ten is instant in the test system, ten thousand by ten thousand is 100 million and takes minutes. The fix is a keyed lookup — `HASHED`, `SORTED`, or a secondary key — and it is a change to a declaration plus one read. See [Internal tables](../internal_tables/README.md).

Between them these two account for most of what gets escalated as "the report is slow".

## Then the smaller ones

- `INTO` where `ASSIGNING` would do: a full row copied per pass. Wide rows, big tables.
- `SELECT *` when four columns are needed: bytes across the network and, on a column store, work the database did not have to do.
- Reading with `line_exists( )` and then reading again: two searches where `VALUE #( … OPTIONAL )` does one.
- `SORT` on every pass of a loop instead of once outside it.
- `DELETE` inside a loop instead of one `DELETE … WHERE`.
- Dynamic access (`ASSIGN COMPONENT`) per row in a tight loop — correct, and not free.

## Measure with the tools, not with an opinion

| Tool | Answers |
|---|---|
| `SAT` (formerly `SE30`), ABAP trace | where the time went, by statement and call |
| `ST05`, SQL trace | every database call, its duration, and its execution plan |
| `ST22`, `SM50`, `SM66` | what a hanging or dumping process was doing |
| `ST12` | trace of a user's session end to end, the usual starting point for "it is slow" |
| `GET RUN TIME FIELD lv_t.` | a quick number around a suspect block, in the program itself |

The reason to insist on this is cheap to state: an index added on the basis of a trace fixes the query; an index added on a hunch adds write cost to every insert forever.

## The rule that comes first

Correct, then clear, then fast — and *then* measured. A tuned version of the wrong answer is still the wrong answer, and most ABAP that is genuinely slow is slow by shape rather than by detail. Fixing the shape is usually a smaller change than the micro-optimisations people reach for first.

<!-- snippet:z_tp_performance -->
*[`z_tp_performance.prog.abap`](snippets/z_tp_performance.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_tp_performance.

TYPES: BEGIN OF ty_order,
         id       TYPE i,
         customer TYPE i,
       END OF ty_order.
TYPES: BEGIN OF ty_customer,
         id   TYPE i,
         name TYPE string,
       END OF ty_customer.

TYPES ty_orders TYPE STANDARD TABLE OF ty_order WITH EMPTY KEY.
" The same rows, twice: once with no key at all, once with one. That difference
" is the whole experiment -- the code around them is identical.
TYPES ty_unkeyed TYPE STANDARD TABLE OF ty_customer WITH EMPTY KEY.
TYPES ty_keyed   TYPE HASHED   TABLE OF ty_customer WITH UNIQUE KEY id.

DATA lt_orders  TYPE ty_orders.
DATA lt_unkeyed TYPE ty_unkeyed.
DATA lt_keyed   TYPE ty_keyed.

DO 1000 TIMES.
  APPEND VALUE #( id = sy-index customer = sy-index ) TO lt_orders.
  APPEND VALUE #( id = sy-index name = |Customer { sy-index }| ) TO lt_unkeyed.
  INSERT VALUE #( id = sy-index name = |Customer { sy-index }| ) INTO TABLE lt_keyed.
ENDDO.

" The shape to avoid: with no key to search on, the inner LOOP walks the whole
" inner table for every row of the outer one -- 1000 x 1000 row comparisons
" here, growing as the square while a ten-row test system stays instant.
DATA lv_slow TYPE i.
LOOP AT lt_orders INTO DATA(ls_order).
  LOOP AT lt_unkeyed INTO DATA(ls_walk) WHERE id = ls_order-customer.
    lv_slow = lv_slow + 1.
  ENDLOOP.
ENDLOOP.

" The same answer, with the key doing the work: one hash lookup per order.
DATA lv_fast TYPE i.
LOOP AT lt_orders INTO DATA(ls_o).
  IF line_exists( lt_keyed[ id = ls_o-customer ] ).
    lv_fast = lv_fast + 1.
  ENDIF.
ENDLOOP.

WRITE: / 'matches found by the nested loop', lv_slow.
WRITE: / 'matches found by the keyed read ', lv_fast.
WRITE: / 'Measure it yourself: SE30 / SAT, or GET RUN TIME FIELD.'.
```
<!-- /snippet -->

## If you are coming from another language

- **Any ORM.** The `SELECT`-in-a-loop defect is the N+1 query problem, written out where a review can see it.
- **Python / Java.** Big-O reasoning transfers directly, and ABAP's internal table kinds are where the constants live. What does not transfer is the assumption that the CPU is the bottleneck — here it is usually the database.

## See also

- [Internal tables](../internal_tables/README.md) — the keys that make a lookup cheap
- [Open SQL](../open_sql/README.md) — what belongs on the database
- [`LOOP AT`](../../02_Keywords/loop_at/README.md) — `INTO` against `ASSIGNING`, and `USING KEY`
- [Debugging](../debugging/README.md) — the neighbouring skill, and some of the same transactions
- [ATC and Code Inspector](../atc_and_code_inspector/README.md) — the checks that catch the two defects before a transport does
- [Asking what time it is](../../02_Keywords/get_time/README.md) — `GET TIME`, `GET RUN TIME`, and the `WAIT` that commits
- [HANA specifics](../hana_specifics/README.md) — what changes on a column store
- [Parallel processing](../parallel_processing/README.md) — `STARTING NEW TASK`, bgRFC, server groups
- [How ABAP runs](../how_abap_runs/README.md) — work processes and dialog steps
