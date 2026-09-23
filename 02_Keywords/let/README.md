# `LET` — a local name inside an expression

**Level:** 301 · deep dive

**Status:** stub — the shape is here; the worked program is not yet.

**One line:** `LET name = value IN …` declares a helper inside a `VALUE`, `COND`, `REDUCE` or `FOR` expression, so a sub-expression is written once instead of three times — and the name exists only until the expression's closing parenthesis.

## What it does

```abap
DATA(lt_tagged) = VALUE ty_names( LET lv_tag = `order` IN
                                  FOR ls_t IN lt_orders ( |{ lv_tag } { ls_t-id }| ) ).

DATA(lv_label) = COND string( LET lv_total = lv_a + lv_b IN
                              WHEN lv_total > 100 THEN |large: { lv_total }|
                              ELSE |small: { lv_total }| ).
```

Several names can be declared in one `LET`, separated by spaces, and each may use the ones before it. The scope is the expression, which makes `LET` the narrowest scope ABAP has — narrower than anything `DATA` can give you.

## Why it earns a page

Two reasons, one of them a warning:

- **It removes repetition inside an expression**, where there is no other way to introduce a temporary. Without `LET`, `lv_a + lv_b` has to be written in both branches, and the day one is changed and the other is not is a matter of time.
- **It makes long expressions longer.** A `VALUE` with a `LET`, a `FOR`, a `WHERE` and a nested `COND` has become a small program with no statement boundaries, no place to put a breakpoint, and no line the debugger can stop on usefully. The moment that happens, statements are the better tool.

## What this page still needs

- [ ] a `snippets/` program with `LET` in `VALUE`, `COND` and `REDUCE`
- [ ] whether a `LET` expression is evaluated once or per iteration inside a `FOR`, verified on a real system
- [ ] a before/after pair showing where the expression should have stayed a statement

## See also

- [`VALUE`](../value/README.md) and [`FOR`](../for/README.md) — where `LET` usually appears
- [`REDUCE`](../reduce/README.md) — `INIT`, which is a `LET` with a job
- [`COND` and `SWITCH`](../cond_switch/README.md) — the other common host
- [Clean ABAP](../../03_Topics/clean_abap/README.md) — the readability limit these constructs share
- [Constructor expressions](../../03_Topics/constructor_expressions/README.md) — the `VALUE`/`NEW`/`COND` family as a family
