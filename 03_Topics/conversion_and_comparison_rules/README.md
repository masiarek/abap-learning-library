# Conversion and comparison rules — what happens between two types

**Level:** 201 · working knowledge

**One line:** Assignment between elementary types converts **silently**, following a documented table — text into `c` truncates on the right, into `n` drops non-digits, into `i` rounds — and comparison converts too, by a table of comparison types, so `n` against `c` compares as text while `n` against `i` compares as numbers, and neither warns.

## Conversion on assignment

| From → to | Rule | `'ABCDEFG'` → `c LENGTH 4` |
|---|---|---|
| text → shorter `c` | cut on the right | `ABCD` |
| text → `n` | non-digits dropped, right-aligned, zero-padded | `'12ab34'` → `1234` |
| text → `i`/`p` | must be numeric text (blanks and one sign allowed); **rounded** to the target's decimals | `'3.7'` → `4` |
| text → `d` | must be `YYYYMMDD`; no validity check | `'20261332'` accepted |
| `c` → `string` | trailing blanks removed | |
| `string` → `c` | padded, or **truncated silently** | |
| number → longer/shorter number | rounded to the target's decimals; overflow raises `CX_SY_ARITHMETIC_OVERFLOW` | |
| `p` → `i` | rounded | `1.5` → `2` |
| anything → reference | not allowed; a syntax error | |

A conversion that cannot be performed at all — `'forty-two'` into `i` — raises `CX_SY_CONVERSION_NO_NUMBER` at runtime. A conversion that can be performed with loss does not raise; [`EXACT`](../../02_Keywords/cast_conv/README.md) is how you ask it to.

## Comparison

Two operands of different types are converted to a common **comparison type** before comparing. The rules that matter:

| Pair | Compared as | So |
|---|---|---|
| `c` with `c`, `c` with `string` | text; the shorter padded with blanks | `'Ada   '` = `` `Ada` `` |
| `n` with `c` | **text** | `'0042'` ≠ `'42'` |
| `n` with `i`/`p` | **number** | `'0042'` = `42` |
| `c` with `i` | number if the `c` is numeric text; otherwise `CX_SY_CONVERSION_NO_NUMBER` | |
| `d` with `d` | text — which happens to sort chronologically | |
| `string` with `string` | text, exactly, no padding | `` `Ada ` `` ≠ `` `Ada` `` |
| `x` with `x` | bytes | |

The `n`-with-`c` row is the one that bites in code that compares a screen field with a Dictionary key: a `c` parameter holding `42` is not equal to a `NUMC` column holding `0042`. See [Conversion routines](../conversion_routines/README.md).

<!-- snippet:z_tp_conversion_and_comparison -->
*[`z_tp_conversion_and_comparison.prog.abap`](snippets/z_tp_conversion_and_comparison.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_tp_conversion_and_comparison.

" Assignment converts silently between most elementary types. What each
" conversion does with the part it cannot keep is the whole subject.
DATA lv_c4 TYPE c LENGTH 4.
DATA lv_n4 TYPE n LENGTH 4.
DATA lv_i  TYPE i.
DATA lv_p2 TYPE p LENGTH 5 DECIMALS 2.

lv_c4 = 'ABCDEFG'.              " longer text into c: cut on the right
WRITE: / 'c4 from ABCDEFG   [', lv_c4, ']'.

lv_n4 = '12ab34'.               " text into n: non-digits dropped, right-aligned
WRITE: / 'n4 from 12ab34    [', lv_n4, ']'.

lv_i = '  42 '.                 " numeric text into i: blanks tolerated
WRITE: / 'i  from "  42 "   ', lv_i.

lv_i = '3.7'.                   " decimal text into i: rounded, not truncated
WRITE: / 'i  from 3.7       ', lv_i.

lv_p2 = '1.005'.                " more decimals than the target: rounded
WRITE: / 'p2 from 1.005     ', lv_p2.

" A conversion that cannot be made at all raises at runtime.
TRY.
    lv_i = 'forty-two'.
    WRITE: / 'never reached', lv_i.
  CATCH cx_sy_conversion_no_number.
    WRITE: / 'text that is not a number: CX_SY_CONVERSION_NO_NUMBER'.
ENDTRY.

" Comparison converts too, by a table of comparison types. c against n is
" compared as TEXT, so '0042' and '42' differ; n against i as NUMBERS, so
" they do not. The program prints what your system does with each.
lv_n4 = 42.
IF lv_n4 = '42'.
  WRITE: / 'n4 = c 42 :  equal'.
ELSE.
  WRITE: / 'n4 = c 42 :  not equal (compared as text)'.
ENDIF.
IF lv_n4 = 42.
  WRITE: / 'n4 = i 42 :  equal (compared as numbers)'.
ENDIF.

" And the one everyone meets: a c field against a string ignores trailing
" blanks, so 'Ada       ' and `Ada` are equal here and unequal in strlen( ).
DATA lv_fixed TYPE c LENGTH 10 VALUE 'Ada'.
IF lv_fixed = `Ada`.
  WRITE: / 'c and string: equal, trailing blanks ignored'.
ENDIF.
```
<!-- /snippet -->

## If you are coming from another language

- **JavaScript.** Yes, this is `==` — implicit coercion with a table you have to memorise. ABAP's table is more predictable and equally silent.
- **Python / Rust.** No implicit conversion between numbers and text at all; the adjustment is that ABAP will do it, and will not tell you what it lost.
- **C.** Numeric widening and truncation on assignment are familiar; text-to-number coercion is not.

## See also

- [Types at a glance](../types_at_a_glance/README.md) — the types being converted
- [`CAST`, `CONV` and `EXACT`](../../02_Keywords/cast_conv/README.md) — refusing a lossy conversion
- [Strings and text](../strings_and_text/README.md) — the trailing-blank rule
- [Conversion routines](../conversion_routines/README.md) — the Dictionary's own conversions, on top of these
- [Numbers and currency](../numbers_and_currency/README.md) — rounding, and the decimal shift
