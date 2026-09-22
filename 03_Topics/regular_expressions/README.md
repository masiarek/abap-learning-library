# Regular expressions — PCRE since 7.55

**Level:** 201 · working knowledge

**One line:** ABAP has two regex engines — the older POSIX one behind `REGEX`, and PCRE from 7.55, which SAP now recommends and which is the dialect the rest of the world writes — and they are different enough that a pattern moved between them without a test is a bug looking for the right input.

## The statements and the functions

```abap
FIND FIRST OCCURRENCE OF PCRE `(\d{4})-(\d{2})-(\d{2})` IN lv_line
     SUBMATCHES DATA(lv_y) DATA(lv_m) DATA(lv_d).

FIND ALL OCCURRENCES OF PCRE `\d+` IN lv_line RESULTS DATA(lt_hits).

DATA(lv_masked) = replace( val = lv_line pcre = `(\d{4})\d{4}` with = `$1****` occ = 0 ).
IF matches( val = lv_id pcre = `^\d{8}$` ).
```

The statements report through `sy-subrc` and can fill `SUBMATCHES` (capture groups straight into variables) or `RESULTS` (a table of offset and length per match). The functions — `find`, `count`, `matches`, `replace`, `substring_from`, `substring_after` — take a `pcre =` parameter and return values, so they work inside a condition or an expression. `occ = 0` means every occurrence.

For anything stateful, `cl_abap_matcher` and `cl_abap_regex` give an object with the match, its groups and its position — the right tool when one pass has to yield several pieces of information.

## Why the engine matters

Before 7.55, `REGEX` used SAP's POSIX implementation. It lacks constructs PCRE has, treats some escapes differently, and is slower. SAP's documentation now marks it obsolete in favour of `PCRE`, and the ATC will say so.

Practically: a pattern copied from a web answer is a PCRE pattern. On a 7.5x system with `PCRE` available it usually just works; with `REGEX` it may parse and mean something subtly different — a lazy quantifier, a lookahead, a shorthand class — which is worse than failing.

## The part that is not about ABAP

Two rules carry over from everywhere else, and both are worth stating because ABAP code breaks them often:

- **Do not parse structured formats with a regex.** XML, JSON and CSV with quoted separators have parsers; see [JSON and XML](../json_and_xml/README.md).
- **Watch the catastrophic case.** Nested quantifiers over a long string — `(a+)+b` against a few dozen characters — can take exponential time, and a work process that hangs in a regex looks exactly like one that hangs in a database read.

<!-- snippet:z_tp_regex -->
*[`z_tp_regex.prog.abap`](snippets/z_tp_regex.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_tp_regex.

DATA(lv_line) = `Order 4711 for customer 10001973 on 2026-09-22`.

" PCRE is the syntax to use from 7.55 onward: it is the flavour the rest of the
" world writes, and it is faster than the POSIX engine behind FIND REGEX.
FIND FIRST OCCURRENCE OF PCRE `(\d{4})-(\d{2})-(\d{2})` IN lv_line
     SUBMATCHES DATA(lv_year) DATA(lv_month) DATA(lv_day).
IF sy-subrc = 0.
  WRITE: / 'date parts', lv_year, lv_month, lv_day.
ENDIF.

" Counting, as an expression rather than a statement.
DATA(lv_numbers) = count( val = lv_line pcre = `\d+` ).
WRITE: / 'number groups', lv_numbers.

" A test that reads as a condition.
IF matches( val = `10001973` pcre = `^\d{8}$` ).
  WRITE: / 'that is an eight digit number'.
ENDIF.

" Replacing, with $1 naming the first capture group.
DATA(lv_masked) = replace( val  = lv_line
                           pcre = `customer (\d{4})\d{4}`
                           with = `customer $1****`
                           occ  = 0 ).
WRITE: / 'masked   ', lv_masked.

" ALL OCCURRENCES ... RESULTS gives every match with its offset and length,
" which is what you need when the matches must be processed, not just counted.
FIND ALL OCCURRENCES OF PCRE `\d+` IN lv_line RESULTS DATA(lt_hits).
LOOP AT lt_hits INTO DATA(ls_hit).
  WRITE: / 'hit at', ls_hit-offset, 'length', ls_hit-length.
ENDLOOP.
```
<!-- /snippet -->

## If you are coming from another language

- **Python / JavaScript / Perl.** PCRE is close to what you already write. Named groups, lookarounds and lazy quantifiers all work; the wrapper is `FIND`/`replace( )` rather than a `re` module.
- **The sibling library.** The [regex learning library](https://masiarek.github.io/regex-learning-library/) asks one regex question at a time across engines, which is the place to settle a dialect difference rather than guessing.

## See also

- [`FIND` and `REPLACE`](../../02_Keywords/find_replace/README.md) — the statements, including the non-regex forms
- [Strings and text](../strings_and_text/README.md) — the functions that do not need a pattern
- [JSON and XML](../json_and_xml/README.md) — the formats a regex should not be parsing
