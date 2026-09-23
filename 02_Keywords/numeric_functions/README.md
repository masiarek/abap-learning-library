# Numeric functions and operators — `abs`, `round`, `nmax`, `DIV`, `MOD`

**Level:** 201 · working knowledge

**One line:** ABAP's numeric functions return values and nest freely; `round( )` needs its **mode** spelled out to be predictable; `DIV` and `MOD` are the integer operators and `/` is not — with integer operands it still rounds — and `MOD` never returns a negative number.

## The functions

| Function | Returns |
|---|---|
| `abs( x )`, `sign( x )` | magnitude; -1, 0 or 1 |
| `ceil( x )`, `floor( x )`, `trunc( x )`, `frac( x )` | the integer above, below, towards zero; the fractional part |
| `round( val = x dec = n mode = … )` | rounded to `n` decimals in a named mode |
| `rescale( )` | a `decfloat` at a given precision |
| `nmax( val1 = … val2 = … )`, `nmin( )` | larger, smaller — any number of arguments |
| `ipow( base = … exp = … )` | integer power; `**` is the float operator |
| `sqrt`, `exp`, `log`, `log10`, `sin`, `cos`, `tan`, … | the float functions |

`round( )` without `mode` uses `ROUND_HALF_UP` — commercial rounding — and the `cl_abap_math=>round_*` constants name the others (`ROUND_HALF_EVEN`, `ROUND_DOWN`, `ROUND_CEILING`…). Financial code that must match another system's rounding should name the mode even when the default happens to match; a reader cannot tell "default because it is right" from "default because nobody thought about it".

## The operators

| Operator | Integer operands | Note |
|---|---|---|
| `/` | **rounds** the result | `7 / 2` into an `i` is `4` |
| `DIV` | integer division, towards minus infinity | `7 DIV 2` is `3` |
| `MOD` | remainder, always `>= 0` | `-7 MOD 2` is `1`, not `-1` |
| `**` | float power | `2 ** 10` is a float |

The `MOD` rule differs from C, Java, JavaScript and Rust, all of which return a negative remainder for a negative dividend. A hash bucket or a "every third row" computed with `MOD` on a value that can go negative works in ABAP and breaks when ported — or the reverse.

<!-- snippet:z_kw_numeric_functions -->
*[`z_kw_numeric_functions.prog.abap`](snippets/z_kw_numeric_functions.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_numeric_functions.

DATA(lv_x) = CONV decfloat34( '-7.5' ).

" Each of these returns a value, so they nest and sit inside expressions.
WRITE: / 'abs  ', abs( lv_x ).
WRITE: / 'sign ', sign( lv_x ).
WRITE: / 'ceil ', ceil( lv_x ).
WRITE: / 'floor', floor( lv_x ).
WRITE: / 'trunc', trunc( lv_x ).
WRITE: / 'frac ', frac( lv_x ).

" round( ) takes the decimals and the MODE, spelled out. Leave the mode out
" and you get commercial rounding, which is not what every reader assumes.
WRITE: / 'round half up  ', round( val = lv_x dec = 0 mode = cl_abap_math=>round_half_up ).
WRITE: / 'round half even', round( val = lv_x dec = 0 mode = cl_abap_math=>round_half_even ).

WRITE: / 'nmax', nmax( val1 = 3 val2 = 9 ).
WRITE: / 'nmin', nmin( val1 = 3 val2 = 9 ).
WRITE: / 'ipow', ipow( base = 2 exp = 10 ).

" DIV and MOD are the integer operators. The slash is not: with integer
" operands it still ROUNDS, so 7 / 2 lands on 4, not 3.
DATA(lv_div) = 7 DIV 2.
DATA(lv_mod) = 7 MOD 2.
DATA(lv_sla) = 7 / 2.
WRITE: / '7 DIV 2', lv_div.
WRITE: / '7 MOD 2', lv_mod.
WRITE: / '7 / 2  ', lv_sla.

" MOD of a negative number is never negative in ABAP -- unlike C's %.
DATA(lv_neg) = -7 MOD 2.
WRITE: / '-7 MOD 2', lv_neg.
```
<!-- /snippet -->

## If you are coming from another language

- **Python.** `//` and `%` behave like `DIV` and `MOD` (floor division, non-negative remainder for a positive divisor) — Python is the one mainstream language that agrees with ABAP here. `round()` uses half-to-even, which ABAP does only if asked.
- **C / Java / Rust.** `/` truncates and `%` follows the dividend's sign. Both differ from ABAP.

## See also

- [Numbers and currency](../../03_Topics/numbers_and_currency/README.md) — which numeric type to reach for, and why `f` is not for money
- [`DATA` — and `DATA( )`](../data/README.md) — how an inferred type makes `/` integer arithmetic by accident
- [`CAST`, `CONV` and `EXACT`](../cast_conv/README.md) — refusing a lossy conversion
- [Types at a glance](../../03_Topics/types_at_a_glance/README.md) — every elementary type, with a program
