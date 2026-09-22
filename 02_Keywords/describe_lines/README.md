# `DESCRIBE` and `lines( )` — how many rows, and what type is this

**Level:** 101 · newcomer

**Status:** stub — the shape is here; the worked program is not yet.

**One line:** `lines( itab )` is the modern way to count rows and can be used inside any expression, while `DESCRIBE TABLE itab LINES lv_n.` is the statement that predates it — and `DESCRIBE FIELD` still answers questions about a variable's type that the function has no equivalent for.

## What it does

```abap
DATA(lv_count) = lines( lt_rows ).                  " expression
DESCRIBE TABLE lt_rows LINES DATA(lv_also).         " statement
DESCRIBE FIELD lv_x TYPE DATA(lv_type) LENGTH DATA(lv_len) IN CHARACTER MODE.
```

`lines( )` is preferred wherever it fits, because it composes: `IF lines( lt ) > 100.` needs no helper variable, and `DESCRIBE` does.

`DESCRIBE TABLE … KIND` still answers which table kind a generic table turned out to be, and `DESCRIBE FIELD` reports a variable's type letter, length and decimals — the old, statement-shaped ancestor of run-time type identification. For anything beyond that, RTTI (`cl_abap_typedescr` and friends) is the real tool. See [Dynamic programming](../../03_Topics/dynamic_programming/README.md).

## The trap worth naming

Counting rows to decide whether a table is empty is wasteful on a large table: `IF lt_rows IS INITIAL.` asks the question directly. The habit matters because `lines( )` on a table that is not held in memory contiguously is not free, and because `IS INITIAL` says what is meant.

## What this page still needs

- [ ] a `snippets/` program comparing `lines( )`, `DESCRIBE TABLE` and `IS INITIAL`
- [ ] `DESCRIBE FIELD`'s type letters, with the RTTI equivalent beside each
- [ ] what `DESCRIBE TABLE … OCCURS` reports and why it is meaningless now

## See also

- [Internal tables](../../03_Topics/internal_tables/README.md) — the tables being counted
- [Dynamic programming](../../03_Topics/dynamic_programming/README.md) — RTTI, the modern answer to "what type is this"
- [`LOOP AT`](../loop_at/README.md) — `sy-tabix` and the other count
