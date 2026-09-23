# Documentation, comments and pragmas — `"!`, `##NO_TEXT`, `"#EC`

**Level:** 201 · working knowledge

**Status:** stub — the forms are here; the worked example is not yet.

**One line:** ABAP has three comment syntaxes (`*` in column one, `"` anywhere, and `"!` for ABAP Doc that tools display), a pretty printer that settles layout arguments, and two mechanisms — pragmas (`##NEEDED`) and pseudo comments (`"#EC NEEDED`) — for telling the syntax check and the Code Inspector that a finding is intentional.

## The forms

| Form | Means |
|---|---|
| `* full-line comment` | classic; the asterisk must be in column 1 |
| `" comment` | to end of line, anywhere |
| `"! ABAP Doc` | documentation shown in ADT hover and in the class documentation; before a declaration |
| `"! @parameter iv_x \| what it is` | ABAP Doc parameter description |
| `##NO_TEXT` | pragma: this literal is not user text, do not report it |
| `##NEEDED` | pragma: this unused variable/parameter is intentional |
| `##TODO`, `##NO_HANDLER` | pragma: a marker; an empty `CATCH` is intentional |
| `"#EC NEEDED`, `"#EC NOTEXT`, `"#EC CI_*` | pseudo comment: the Code Inspector's older equivalent of the pragma |
| `Shift+F1` | the pretty printer: indentation and keyword case per the settings |

Pragmas are checked by the compiler and go on the statement; pseudo comments are text the inspector reads and go at the end of the line. Newer checks want pragmas; older checks still read pseudo comments; the ATC tells you which.

## The rules worth having

- **Comment why, not what.** `" increment the counter` above `lv_n = lv_n + 1.` is noise; `" the API counts from 1, not 0` is the comment.
- **Delete commented-out code.** The version history has it; a reader cannot tell dead from disabled.
- **ABAP Doc on every public method of a global class** — it is what a caller sees in ADT without opening the class.
- **A pragma is a decision, not a silencer.** `##NEEDED` on a parameter nobody uses because the interface demands it is right; on a variable because the warning was annoying is a lie the next reader inherits.
- **Run the pretty printer before committing**, with the team's settings, so the diff is the change.

## What this page still needs

- [ ] a `snippets/` class with ABAP Doc, one pragma of each kind, and how ADT shows the documentation
- [ ] the pretty-printer settings a team should agree on, once
- [ ] the Code Inspector's list of pseudo comments, mapped to pragmas

## See also

- [Clean ABAP](../clean_abap/README.md) — the comment rules argued
- [ATC and Code Inspector](../atc_and_code_inspector/README.md) — what the pragmas talk to
- [Text elements and translation](../text_elements_and_translation/README.md) — `##NO_TEXT`'s subject
- [ADT and SE80](../tooling_adt_and_se80/README.md) — where ABAP Doc is displayed
