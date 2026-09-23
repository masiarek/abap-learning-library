# `DO` and `WHILE` — counting loops

**Level:** 101 · newcomer

**Status:** stub — the shape is here; the worked program is not yet.

**One line:** `DO n TIMES` repeats a fixed number of times, `WHILE cond` repeats as long as a condition holds, both set `sy-index` to the current pass — and `sy-index` belongs to the *innermost* loop, which is what nested loops trip over.

## What it does

```abap
DO 5 TIMES.
  WRITE: / sy-index.
ENDDO.

WHILE lv_remaining > 0.
  lv_remaining = lv_remaining - 1.
ENDWHILE.
```

`DO` without `TIMES` loops forever until an `EXIT` — a legitimate shape for "read until there is nothing left", and the reason an accidental missing `EXIT` hangs a work process.

`sy-index` counts passes of the current loop, starting at 1. In a nested `DO`, the inner loop overwrites it, so a value needed after the inner loop must be saved before it. Note also that `LOOP AT` sets `sy-tabix`, not `sy-index` — two fields, two loops, and mixing them up is a classic.

## What this page still needs

- [ ] a `snippets/` program with nested loops showing `sy-index` being overwritten
- [ ] `DO … VARYING`, and why it is on the obsolete list
- [ ] the modern replacements: `FOR … UNTIL` in an expression, and when a loop is still clearer

## See also

- [`LOOP AT`](../loop_at/README.md) — the loop over a table, and `sy-tabix`
- [`FOR`](../for/README.md) — counting inside an expression instead
- [`CHECK`, `CONTINUE`, `EXIT`, `RETURN`](../check_continue_exit/README.md) — getting out of the loop
- [System fields](../sy_fields/README.md) — `sy-subrc`, `sy-tabix`, `sy-index` and the rest
