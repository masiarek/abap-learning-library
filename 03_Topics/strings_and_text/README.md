# Strings and text — `string` grows, `c` is padded forever

**Level:** 201 · working knowledge

**One line:** ABAP has two text types and they behave differently in every way that matters: `string` is variable-length and dynamically allocated, `c LENGTH n` is fixed and blank-padded to `n` for as long as it exists — and the conversions between them silently add or remove trailing blanks.

## The two types

| | `string` | `c LENGTH n` |
|---|---|---|
| Length | grows and shrinks | fixed forever |
| Unused space | none | blanks |
| Initial value | empty | `n` blanks |
| Literal | `` `backticks` `` | `'quotes'` |
| Assigning something longer | grows | **truncated, silently** |

The literal quoting is not cosmetic: `'abc '` (a text field literal) has its **trailing blanks removed** by the compiler, while `` `abc ` `` (a string literal) keeps them. Two spellings of the same characters, two different values.

Converting a `c` field to a `string` removes trailing blanks; converting a `string` into a `c` field pads or truncates it. Neither reports anything. That single rule is behind most "the length changed and nobody touched it" investigations — and [How long is a string?](../../01_Foundations/how_long_is_a_string/README.md) is the page that takes the length question further, into what a character even is.

## The function library

Modern ABAP has real string functions, which return values and therefore compose:

`strlen`, `xstrlen`, `substring`, `substring_before`, `substring_after`, `to_upper`, `to_lower`, `condense`, `reverse`, `repeat`, `replace`, `find`, `count`, `matches`, `segment`, `concat_lines_of`, `escape`, `shift_left`, `shift_right`, `translate`.

The older statements — `CONDENSE`, `TRANSLATE`, `SHIFT`, `OVERLAY`, `REPLACE … IN` — change a variable **in place**, which is why they cannot appear inside an expression and why the function versions exist. Both are current ABAP; the function is usually the clearer one.

Offsets and lengths work on both types: `lv_text(4)` is the first four characters, `lv_text+4(2)` is two characters from position four. They are not bounds-checked at compile time, so an offset past the end is a runtime dump.

## Comparison rules that surprise people

`'Ada'` in a `c LENGTH 10` compares **equal** to the string `` `Ada` ``: trailing blanks are ignored when comparing text. But `strlen( )` of the two differs, `IS INITIAL` differs, and what arrives at a database column differs. Comparison being forgiving is exactly what hides the difference until something else exposes it.

<!-- snippet:z_tp_strings -->
*[`z_tp_strings.prog.abap`](snippets/z_tp_strings.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_tp_strings.

DATA(lv_text) = `  Ada Lovelace, Analytical Engine  `.

" The built-in functions return a value, so they nest and compose. The old
" statements (CONDENSE, TRANSLATE, SHIFT) change a variable in place instead,
" which is why they cannot appear inside an expression.
WRITE: / 'condensed [', condense( lv_text ), ']'.
WRITE: / 'upper     ', to_upper( lv_text ).
WRITE: / 'length    ', strlen( condense( lv_text ) ).

" Offsets count from zero and are not bounds-checked by the compiler.
DATA(lv_name) = condense( lv_text ).
WRITE: / 'first 3   ', lv_name(3).
WRITE: / 'substring ', substring( val = lv_name off = 0 len = 3 ).

" Searching: find( ) returns the offset or -1, and never raises.
DATA(lv_at) = find( val = lv_name sub = `Engine` ).
WRITE: / 'found at  ', lv_at.

" Splitting into a table, then joining back with a separator of your choice.
SPLIT lv_name AT `,` INTO TABLE DATA(lt_parts).
WRITE: / 'parts     ', lines( lt_parts ).
DATA(lv_joined) = concat_lines_of( table = lt_parts sep = ` | ` ).
WRITE: / 'joined    ', lv_joined.

" replace( ) returns a new string; REPLACE ... IN changes one in place.
WRITE: / 'replaced  ', replace( val = lv_name sub = `Ada` with = `Grace` ).

" A string grows as needed; a c field is padded to its length forever, and
" comparing the two is the oldest source of surprise in ABAP.
DATA lv_fixed TYPE c LENGTH 10 VALUE 'Ada'.
DATA(lv_string) = `Ada`.
IF lv_fixed = lv_string.
  WRITE: / 'c and string compare equal -- trailing blanks are ignored here'.
ENDIF.
WRITE: / 'c strlen     ', strlen( lv_fixed ).
WRITE: / 'string strlen', strlen( lv_string ).
```
<!-- /snippet -->

## If you are coming from another language

- **C.** `c LENGTH n` is `char[n]` — fixed, padded, and truncating — except that ABAP has no terminator and pads with blanks rather than zeros. `string` is the managed type C does not have.
- **Python / Java.** `string` is the familiar one. The `c` type has no equivalent; its closest relative is a fixed-width column in a file format.
- **Rust.** `String` and `&str` are both variable-length; ABAP's `c` is nearer `[u8; N]` with blank padding, and Rust would never silently truncate into it.

## See also

- [How long is a string?](../../01_Foundations/how_long_is_a_string/README.md) — the recorded-run page on what a length counts
- [String templates](../../02_Keywords/string_templates/README.md) — building text, with formatting
- [`CONCATENATE` and `SPLIT`](../../02_Keywords/concatenate_split/README.md) — the statement forms
- [Regular expressions](../regular_expressions/README.md) — searching with patterns
- [`CAST`, `CONV` and `EXACT`](../../02_Keywords/cast_conv/README.md) — converting without losing information quietly
- [In-place string statements](../../02_Keywords/condense_translate_shift/README.md) — `CONDENSE`, `TRANSLATE`, `SHIFT` and their function twins
- [Unicode and code pages](../unicode_and_code_pages/README.md) — characters, bytes, and naming the code page
- [Conversion and comparison rules](../conversion_and_comparison_rules/README.md) — what happens between two types
