# String templates — `|text { expression }|`

**Level:** 201 · working knowledge

**One line:** A string template is text between bars with expressions in braces, converted and formatted on the spot — `|Hello, { lv_name }!|` — and its formatting options (`WIDTH`, `ALIGN`, `DATE`, `TIME`, `CASE`, `NUMBER`) do work that would otherwise be five statements.

## The literal

```abap
DATA(lv_msg) = |Hello, { lv_name }! You have { lv_count } message(s).|.
```

Everything between the bars is literal text; everything in braces is an expression whose value is converted to text. The result is always a `string`.

Three characters have to be escaped inside a template: `\|`, `\{`, `\}`, and the backslash itself as `\\`.

## Formatting is part of the syntax

```abap
|{ lv_count WIDTH = 5 ALIGN = RIGHT PAD = '0' }|
|{ sy-datum DATE = USER }|
|{ lv_name CASE = UPPER }|
|{ lv_amount NUMBER = USER }|
```

`DATE = USER` and `NUMBER = USER` respect the user's own settings, which is what a screen or a printed document should do. `DATE = ISO` is what an interface file should do. The choice between them is a business decision that looks like formatting — a date written `01/02/2026` means two different days on two continents, and the code that picked `USER` for a file is the reason.

## The three ways to join text, and why two of them are not the same

| | |
|---|---|
| `\|{ a } { b }\|` | template — converts, formats, and produces a `string` |
| `a && b` | concatenation operator — operands must already be text |
| `CONCATENATE a b INTO c.` | the statement — needs a target, and has its own rules about trailing blanks |

`CONCATENATE` is not obsolete, but for building text out of values the template has replaced it in practice. The trailing-blank question is the reason: a `c` field carries its padding, and what happens to that padding differs between the statement and the operator. See [`CONCATENATE` and `SPLIT`](../concatenate_split/README.md).

## Where a template bites

A template always produces a `string`. Assigning one to a fixed-length `c` field **truncates without a word** — no exception, no `sy-subrc`, just a shorter value. When the target has a length, either check first or use [`EXACT`](../cast_conv/README.md), which raises instead.

The other cost is invisible in the source: a template is evaluated at runtime and a long one inside a loop over 100,000 rows is 100,000 conversions. That is fine in nearly all code and not fine in the one place it is not.

<!-- snippet:z_kw_string_templates -->
*[`z_kw_string_templates.prog.abap`](snippets/z_kw_string_templates.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_string_templates.

DATA(lv_name)  = `Ada`.
DATA(lv_count) = 7.

" Everything between the bars is literal text; everything inside braces is an
" expression, converted to text on the spot.
DATA(lv_msg) = |Hello, { lv_name }! You have { lv_count } message(s).|.
WRITE: / lv_msg.

" Formatting options live inside the braces, after the expression.
WRITE: / |padded: [{ lv_count WIDTH = 5 ALIGN = RIGHT PAD = '0' }]|.
WRITE: / |upper : { lv_name CASE = UPPER }|.
WRITE: / |date  : { sy-datum DATE = USER }|.
WRITE: / |time  : { sy-uzeit TIME = USER }|.
WRITE: / |number: { CONV decfloat34( '1234.5' ) NUMBER = USER }|.

" A bar, a brace or a backslash inside a template has to be escaped.
WRITE: / |a pipe \| and a brace \{ are escaped with a backslash|.

" && joins strings; it is not the same as the old CONCATENATE, which needed a
" target and had its own rules about trailing blanks.
DATA(lv_joined) = lv_name && ` and ` && `Grace`.
WRITE: / lv_joined.

" A template always produces a string. Writing one into a fixed-length field
" truncates without a word.
DATA lv_short TYPE c LENGTH 5.
lv_short = |{ lv_joined }|.
WRITE: / 'truncated:', lv_short.
```
<!-- /snippet -->

## If you are coming from another language

- **Python.** This is the f-string, including format specifiers inside the braces. ABAP's spellings are words (`WIDTH = 5 ALIGN = RIGHT`) rather than mini-language (`:>5`).
- **JavaScript.** Template literals, with `|` where the backtick is — and ABAP has no tagged templates.
- **C#.** `$"…{x}…"`, the closest match of all, including the alignment option.
- **Rust.** `format!("{x:>5}")`. Rust checks the format string at compile time; ABAP checks the template's syntax but not that the value suits the option.

## See also

- [`CONCATENATE` and `SPLIT`](../concatenate_split/README.md) — the statement forms and what they still do
- [Strings and text](../../03_Topics/strings_and_text/README.md) — `string` versus `c`, and the function library
- [How long is a string?](../../01_Foundations/how_long_is_a_string/README.md) — what a length means once the text is not ASCII
- [`CAST`, `CONV` and `EXACT`](../cast_conv/README.md) — refusing a truncation instead of accepting it
