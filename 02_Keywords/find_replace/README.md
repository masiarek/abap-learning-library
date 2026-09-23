# `FIND` and `REPLACE` — searching, with and without regular expressions

**Level:** 201 · working knowledge

**Status:** stub — the shape is here; the worked program is not yet.

**One line:** `FIND` and `REPLACE` work on plain substrings by default and on regular expressions with `PCRE` (7.55+) or the older `REGEX`, they report through `sy-subrc`, and their expression cousins — `find( )`, `replace( )`, `count( )`, `matches( )` — do the same jobs inside a larger expression.

## What it does

```abap
FIND FIRST OCCURRENCE OF `Engine` IN lv_text MATCH OFFSET DATA(lv_off).
FIND ALL OCCURRENCES OF PCRE `\d+` IN lv_text RESULTS DATA(lt_hits).
REPLACE ALL OCCURRENCES OF `old` IN lv_text WITH `new`.
```

`SUBMATCHES` pulls capture groups straight into variables; `RESULTS` returns a table of offsets and lengths, which is what you need when the matches have to be processed rather than counted. `IN TABLE` searches an internal table of lines instead of one string.

The expression forms return values instead of setting `sy-subrc`: `find( val = … sub = … )` gives the offset or `-1`, `count( )` the number of matches, `matches( val = … pcre = … )` a boolean. They never raise, which makes them safe inside a condition.

## `PCRE`, `REGEX`, and which to write

Since 7.55 `PCRE` is the addition to use: it is the flavour the rest of the world writes, and SAP's own documentation calls the older POSIX engine behind `REGEX` deprecated. On an older system `REGEX` is what you have. The two are not the same dialect, and a pattern moved between them without testing is a bug waiting for a data set that exercises it.

## What this page still needs

- [ ] a `snippets/` program covering `SUBMATCHES`, `RESULTS`, and `occ = 0`
- [ ] the `sy-subrc` and `sy-fdpos` values each form leaves behind
- [ ] a worked case-insensitive search, and the `IGNORING CASE` versus `(?i)` choice

## See also

- [Regular expressions](../../03_Topics/regular_expressions/README.md) — the topic page, with a program
- [Strings and text](../../03_Topics/strings_and_text/README.md) — the non-regex string functions
- [`CONCATENATE` and `SPLIT`](../concatenate_split/README.md) — cutting text apart without a pattern
- [In-place string statements](../condense_translate_shift/README.md) — `CONDENSE`, `TRANSLATE`, `SHIFT` and their function twins
