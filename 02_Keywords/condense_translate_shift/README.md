# `CONDENSE`, `TRANSLATE`, `SHIFT` — the in-place string statements

**Level:** 201 · working knowledge

**One line:** These statements change a variable **where it stands** and return nothing — which is why they cannot appear inside an expression, and why each has a function twin (`condense( )`, `to_upper( )`, `shift_left( )`) that returns a value instead.

## The three, and their twins

| Statement | Does | Function form |
|---|---|---|
| `CONDENSE lv.` | strips leading blanks, squeezes runs to one; `NO-GAPS` removes all | `condense( val = … del = … )` |
| `TRANSLATE lv TO UPPER CASE.` | case change; `USING 'AXPY'` maps character pairs | `to_upper( )`, `to_lower( )`, `translate( val = … from = … to = … )` |
| `SHIFT lv LEFT/RIGHT [BY n PLACES] [DELETING LEADING/TRAILING …] [CIRCULAR].` | moves characters, filling with blanks | `shift_left( )`, `shift_right( )` |

`OVERLAY`, `REPLACE … IN` and `SPLIT` are the same family. All are current ABAP; none is obsolete.

## Which to write

The function, nearly always. `DATA(lv_key) = to_upper( condense( lv_input ) ).` is one line; the statement form is a helper variable and three lines, and the helper is then visible for the rest of the program. The statement wins only when the in-place change *is* the point — a large `c` field being normalised before a `MODIFY`, where a copy would be waste.

A subtlety on fixed-length fields: `SHIFT … RIGHT DELETING TRAILING space` on a `c LENGTH 10` right-aligns the value in the field, which is how old code right-justified a number for a list. The string functions have no notion of a field width, so that trick has no function twin — a [string template](../string_templates/README.md) with `ALIGN = RIGHT WIDTH = 10` is the modern spelling.

<!-- snippet:z_kw_condense_translate_shift -->
*[`z_kw_condense_translate_shift.prog.abap`](snippets/z_kw_condense_translate_shift.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_condense_translate_shift.

" These statements change the variable IN PLACE and return nothing, which is
" why none of them can appear inside an expression.
DATA lv_text TYPE string VALUE `  Ada   Lovelace  `.

CONDENSE lv_text.                      " leading blanks gone, runs of blanks to one
WRITE: / '[', lv_text, ']'.
CONDENSE lv_text NO-GAPS.              " every blank gone
WRITE: / '[', lv_text, ']'.

DATA lv_word TYPE string VALUE `abap`.
TRANSLATE lv_word TO UPPER CASE.
WRITE: / lv_word.
TRANSLATE lv_word USING 'AXPY'.        " pairs, in order: A becomes X, P becomes Y
WRITE: / lv_word.

DATA lv_num TYPE c LENGTH 10 VALUE '42'.
SHIFT lv_num RIGHT DELETING TRAILING space.
WRITE: / '[', lv_num, ']'.
SHIFT lv_num LEFT DELETING LEADING space.
WRITE: / '[', lv_num, ']'.
SHIFT lv_num BY 1 PLACES LEFT.
WRITE: / '[', lv_num, ']'.

" The function form of each returns a value and leaves the original alone --
" the shape to prefer whenever the result feeds an expression.
DATA(lv_orig) = `  keep me  `.
DATA(lv_new)  = condense( lv_orig ).
WRITE: / '[', lv_orig, ']'.
WRITE: / '[', lv_new, ']'.
WRITE: / to_upper( shift_left( val = lv_orig sub = ` ` ) ).
```
<!-- /snippet -->

## If you are coming from another language

- **Python.** `str.strip()`, `str.upper()`, `str.translate()` — every one of them returns a new string, so Python only has the function form.
- **C.** In-place modification of a `char[]` is the C default; ABAP's statements are that style, and its functions are the managed-string style layered on top.

## See also

- [Strings and text](../../03_Topics/strings_and_text/README.md) — the function library in full
- [`CONCATENATE` and `SPLIT`](../concatenate_split/README.md) — the same statement-versus-expression story for joining and cutting
- [String templates](../string_templates/README.md) — alignment and padding without `SHIFT`
- [`FIND` and `REPLACE`](../find_replace/README.md) — search and replace, both forms
