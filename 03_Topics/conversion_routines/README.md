# Conversion routines — `ALPHA`, and why the material number has leading zeros

**Level:** 201 · working knowledge

**One line:** A conversion routine is a pair of function modules — `CONVERSION_EXIT_XXXX_INPUT` towards storage, `_OUTPUT` towards display — attached to a domain, so a value is stored in one form (`000000000000004711`) and shown in another (`4711`); the screen applies them automatically, your code does not, and a `SELECT` with the display form finds nothing.

## The mechanism

| Direction | Called | Does (for `ALPHA`) |
|---|---|---|
| `INPUT` | screen field → program, or by you | pads numeric text with leading zeros to the field length |
| `OUTPUT` | program → screen or `WRITE` | strips them |

`ALPHA` is the famous one (material, customer, vendor numbers); others include `CUNIT` (units of measure: `ST` ↔ `PC`), `ISOLA` (language keys), `PERI` (periods), `MATN1` (material numbers with a display template), and `TSTMP` (timestamps). The domain's *convers. routine* field names it.

Three ways to call one:

```abap
lv_stored = |{ lv_input ALPHA = IN }|.                  " string template, 7.40+
CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT' EXPORTING input = lv_input IMPORTING output = lv_stored.
WRITE lv_stored USING EDIT MASK '==ALPHA'.              " list output only
```

## Where it goes wrong

- **A `SELECT` with the unconverted value.** `WHERE matnr = '4711'` finds nothing, because the row holds `000000000000004711`. Quiet, and the commonest ALPHA bug.
- **An interface file with the stored form.** The partner receives eighteen-character material numbers and asks why.
- **Double conversion.** `INPUT` on a value that was already converted is harmless for `ALPHA` and not for every routine.
- **A `Z` routine of your own.** The function modules must handle every input, including blanks and already-converted values, because the screen will send them all.

<!-- snippet:z_tp_conversion_routines -->
*[`z_tp_conversion_routines.prog.abap`](snippets/z_tp_conversion_routines.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_tp_conversion_routines.

" A material number is stored with leading zeros and shown without them. The
" ALPHA conversion routine is the bridge, and a string template can apply it.
DATA lv_stored TYPE c LENGTH 18.

lv_stored = |{ '4711' ALPHA = IN }|.
WRITE: / 'in  (towards storage) [', lv_stored, ']'.

DATA(lv_shown) = |{ lv_stored ALPHA = OUT }|.
WRITE: / 'out (towards display) [', lv_shown, ']'.

" The function module form, which is what older code -- and most SAP code --
" calls. Every conversion routine XXXX has CONVERSION_EXIT_XXXX_INPUT/OUTPUT.
DATA lv_via_fm TYPE c LENGTH 18.
CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
  EXPORTING
    input  = '4711'
  IMPORTING
    output = lv_via_fm.
WRITE: / 'via the function module [', lv_via_fm, ']'.

" The trap: a value typed on a screen ('4711') and the value in the table
" ('000000000000004711') are not equal until one side is converted -- and a
" SELECT with the unconverted one finds nothing, quietly.
IF lv_stored = '4711'.
  WRITE: / 'equal without conversion'.
ELSE.
  WRITE: / 'NOT equal until converted -- the classic ALPHA bug'.
ENDIF.
```
<!-- /snippet -->

## If you are coming from another language

- **Any ORM with a column type converter** — the same idea, applied at the UI boundary rather than the database one, which is exactly the surprise: the database holds the *converted* form.

## See also

- [DDIC, domains and data elements](../ddic_and_domains/README.md) — where the routine is attached
- [String templates](../../02_Keywords/string_templates/README.md) — the `ALPHA = IN` option
- [`SELECT`](../../02_Keywords/select/README.md) — the statement that finds nothing
- [Strings and text](../strings_and_text/README.md) — `n` and `c`, padding and stripping
