# Numbers and currency — `i` rounds, `p` is exact, `f` lies

**Level:** 201 · working knowledge

**Status:** stub — the type table is here; the worked example is not yet.

**One line:** ABAP's numeric types are not interchangeable — `i` is an integer whose division **rounds** rather than truncating, `p` is packed decimal and the only safe type for money, `decfloat34` is exact decimal arithmetic with room to spare, and `f` is binary floating point that cannot represent `0.1` and has no place in financial code.

## The types

| Type | Is | Use for |
|---|---|---|
| `i` / `int8` | 32-bit / 64-bit integer | counters, indexes, quantities of things |
| `p LENGTH n DECIMALS d` | packed decimal, exact | money, quantities, anything a person will check with a calculator |
| `decfloat16` / `decfloat34` | IEEE decimal floating point, exact for decimals | calculations needing range *and* decimal exactness |
| `f` | binary floating point | physics, statistics — never money |

Two rules that catch people:

- **Integer division rounds.** `3 / 2` in `i` arithmetic is `2`, not `1`. ABAP uses commercial rounding, so this is not truncation and not what most other languages do. Reach for `DIV` and `MOD` when you want integer division and a remainder.
- **The type of an expression comes from its operands**, so `DATA(x) = lv_i / 2.` is integer arithmetic no matter what `x` was going to be used for. See [`DATA`](../../02_Keywords/data/README.md).

## Amounts are not just numbers

A `CURR` field in the Dictionary has **two** decimals in the database regardless of currency, and the real number of decimals comes from `TCURX` for the currency. For JPY (no decimals) and for the handful of three-decimal currencies, an amount displayed without that shift is out by a factor of 100 or 10. The same applies to quantities and their unit (`MEINS`), and to the `CURRENCY` addition on [`WRITE`](../../02_Keywords/write/README.md), which applies the shift for you.

A currency amount also needs its currency key beside it in any table that stores one. An amount without a currency is not a number, it is a rumour.

## What this page still needs

- [ ] a `snippets/` program showing `i` rounding, `p` exactness and `f` failing to represent `0.1`
- [ ] a recorded run of a `TCURX` currency (JPY and a three-decimal one) through display and storage
- [ ] rounding rules: `ROUND`, `CEIL`, `FLOOR`, and what SAP's own rounding function does at `.5`
- [ ] overflow: what `CX_SY_ARITHMETIC_OVERFLOW` actually says, recorded

## See also

- [`DATA` — and `DATA( )`](../../02_Keywords/data/README.md) — how an inferred type becomes integer arithmetic by accident
- [`CAST`, `CONV` and `EXACT`](../../02_Keywords/cast_conv/README.md) — converting without losing information quietly
- [Open SQL](../open_sql/README.md) — amounts coming back in database format
- [DDIC, domains and data elements](../ddic_and_domains/README.md) — where `CURR`, `QUAN` and their reference fields are declared
- The [math learning library](https://masiarek.github.io/math-learning-library/) — floating point in general, with programs that were run
