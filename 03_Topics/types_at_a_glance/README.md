# Types at a glance — every elementary type, and what each one is for

**Level:** 101 · newcomer

**One line:** ABAP has twelve elementary types — five fixed-length character-like (`c`, `n`, `d`, `t`, `x`), five numeric (`i`, `int8`, `p`, `f`, `decfloat16/34`), and two variable-length (`string`, `xstring`) — and choosing between the ones that look alike (`c` versus `string`, `p` versus `f`, `n` versus `i`) is where most type bugs begin.

## The table

| Type | Holds | Length | Initial | Reach for it when |
|---|---|---|---|---|
| `c` | text | fixed, blank-padded | blanks | a Dictionary field says so; otherwise `string` |
| `n` | digits | fixed, zero-padded | zeros | an identifier that is numeric text: a document number, a `MATNR` |
| `d` | `YYYYMMDD` | 8 | `00000000` | dates — see [Dates and times](../dates_and_times/README.md) |
| `t` | `HHMMSS` | 6 | `000000` | times |
| `x` | bytes | fixed | `00…` | fixed-size binary: a hash, a GUID |
| `i` | integer | 4 bytes | 0 | counting, indexing |
| `int8` | integer | 8 bytes | 0 | counters past two billion (7.54+) |
| `p` | packed decimal | 1–16 bytes, 0–14 decimals | 0 | **money**, quantities, anything a person checks |
| `f` | binary float | 8 bytes | 0 | science; never amounts |
| `decfloat16`, `decfloat34` | decimal float | 8 / 16 bytes | 0 | exact decimal with wide range; calculations that mix scales |
| `string` | text | variable | empty | text whose length you do not know |
| `xstring` | bytes | variable | empty | files, payloads, anything encoded |

`b` and `s` (1- and 2-byte integers) exist and are for Dictionary compatibility, not for you. `utclong` (7.54+) is the newer timestamp type.

## The three confusions

- **`c` versus `string`.** `c` is padded to its length forever and truncates silently; `string` grows. Converting between them adds or removes trailing blanks. See [Strings and text](../strings_and_text/README.md).
- **`p` versus `f` versus `decfloat`.** `f` cannot hold `0.1`; `p` and `decfloat` can. `p` has a fixed number of decimals; `decfloat` floats them. Money is `p` with the currency's decimals, or `decfloat34` in a calculation that will be rounded at the end. See [Numbers and currency](../numbers_and_currency/README.md).
- **`n` versus `i`.** `n` is *text* made of digits: it sorts and compares as text, pads with zeros, and cannot be added to without conversion. An `i` is a number. A material number is `n`; a quantity is never.

Every one of these is a *built-in* type; the Dictionary wraps them in [domains and data elements](../ddic_and_domains/README.md) that add labels, checks and conversion routines. Prefer the Dictionary type wherever one exists.

<!-- snippet:z_tp_types_at_a_glance -->
*[`z_tp_types_at_a_glance.prog.abap`](snippets/z_tp_types_at_a_glance.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_tp_types_at_a_glance.

" One variable of each elementary type, so the table on the page is backed
" by a program and not recited.
DATA lv_c   TYPE c LENGTH 4.             " text, fixed length, blank-padded
DATA lv_n   TYPE n LENGTH 4.             " digits only, fixed, zero-padded
DATA lv_d   TYPE d.                      " YYYYMMDD, eight characters
DATA lv_t   TYPE t.                      " HHMMSS, six characters
DATA lv_x   TYPE x LENGTH 2.             " raw bytes, fixed
DATA lv_i   TYPE i.                      " 32-bit integer
DATA lv_i8  TYPE int8.                   " 64-bit integer
DATA lv_p   TYPE p LENGTH 8 DECIMALS 2.  " packed decimal, exact
DATA lv_f   TYPE f.                      " binary float -- not for money
DATA lv_df  TYPE decfloat34.             " decimal float, exact, 34 digits
DATA lv_s   TYPE string.                 " text, variable length
DATA lv_xs  TYPE xstring.                " bytes, variable length

lv_c  = 'ab'.
lv_n  = 42.
lv_d  = sy-datum.
lv_t  = sy-uzeit.
lv_x  = 'FF01'.
lv_i  = -7.
lv_i8 = 9000000000.
lv_p  = '1234.56'.
lv_f  = '0.1'.
lv_df = '0.1'.
lv_s  = `ab`.
lv_xs = 'FF01'.

WRITE: / 'c    [', lv_c, ']'.
WRITE: / 'n    [', lv_n, ']'.
WRITE: / 'd     ', lv_d.
WRITE: / 't     ', lv_t.
WRITE: / 'x     ', lv_x.
WRITE: / 'i     ', lv_i.
WRITE: / 'int8  ', lv_i8.
WRITE: / 'p     ', lv_p.
WRITE: / 'f     ', lv_f.
WRITE: / 'df34  ', lv_df.
WRITE: / 's    [', lv_s, ']'.
WRITE: / 'xs    ', lv_xs.

" The same digits in c and in n are different values: n compares as a
" number, c as text -- and as text, '9' sorts after '10'.
DATA lv_text_nine TYPE c LENGTH 2 VALUE '9'.
DATA lv_text_ten  TYPE c LENGTH 2 VALUE '10'.
IF lv_text_nine > lv_text_ten.
  WRITE: / 'as text, 9 sorts after 10'.
ENDIF.

" 0.1 is exact in decfloat34 and not in f. The program prints both; the page
" says which one a finance colleague will accept.
WRITE: / 'f    0.1 * 3 =', lv_f * 3.
WRITE: / 'df34 0.1 * 3 =', lv_df * 3.

DESCRIBE FIELD lv_p LENGTH DATA(lv_bytes) IN BYTE MODE.
WRITE: / 'p LENGTH 8 occupies bytes', lv_bytes.
```
<!-- /snippet -->

## If you are coming from another language

- **C.** `char[n]`, `int`, `double` and no decimal type: ABAP's `p` and `decfloat` are the ones you have been missing.
- **Python.** `str`, `int`, `float`, `Decimal`, `bytes` — with `Decimal` being the one ABAP makes a first-class citizen.
- **SQL.** `CHAR(n)`, `NUMERIC(p,s)`, `DATE`, `VARBINARY` — the closest family, and the reason ABAP's types look the way they do.

## See also

- [`DATA` — and `DATA( )`](../../02_Keywords/data/README.md) — declaring one
- [Conversion and comparison rules](../conversion_and_comparison_rules/README.md) — what happens between them
- [Initial values and null](../initial_values_and_null/README.md) — the third column, explained
- [DDIC, domains and data elements](../ddic_and_domains/README.md) — the Dictionary layer on top
