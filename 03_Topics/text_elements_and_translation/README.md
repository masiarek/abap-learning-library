# Text elements and translation — nothing a user reads belongs in a literal

**Level:** 101 · newcomer

**Status:** stub — the rule is here; the worked example is not yet.

**One line:** Every piece of text a user sees — a message, a selection-screen label, a column heading, a list title — has a home that can be translated (`SE63`) and none of them is a string literal in the code; text symbols (`TEXT-001`), selection texts, message classes and Dictionary labels are those homes.

## Where each kind of text lives

| Text | Lives in | Written as |
|---|---|---|
| a message | a message class (`SE91`) | `MESSAGE e001(zfin)` |
| a label on a `PARAMETERS` field | selection texts (Goto → Text elements) | automatic from the field name |
| a fixed string in a report | text symbols | `TEXT-001`, or `'Total'(001)` |
| a column heading, F1 help | the data element | automatic from the type |
| a list heading | list headings (text elements) | automatic |
| a form's text | SAPscript / Smart Forms / Adobe Forms | the form |
| a Fiori label | CDS `@EndUserText` annotations | the view |

The `'Total'(001)` form is the one to know: the literal is the default and `001` the text symbol, so the code reads naturally *and* the text is translatable. A bare `'Total'` is a finding in any code inspection and a broken screen in the first non-English logon.

## Why it earns a page

Because the pragma `##NO_TEXT` exists precisely to mark the literals that are *not* user-facing — a technical constant, a field name — and its presence in review is the question "should this have been a text element?". And because translation (`SE63`) happens later, by other people, who can only translate what has a home.

## What this page still needs

- [ ] a `snippets/` report with a text symbol, a selection text and a message, and what each looks like in `SE63`
- [ ] the logon-language rule: which language a background job uses, and `sy-langu`
- [ ] how CDS and RAP texts reach the Fiori app

## See also

- [`MESSAGE`](../../02_Keywords/message/README.md) — message classes
- [`PARAMETERS` and `SELECT-OPTIONS`](../../02_Keywords/parameters_select_options/README.md) — selection texts
- [Documentation and pragmas](../documentation_and_pragmas/README.md) — `##NO_TEXT`
- [DDIC, domains and data elements](../ddic_and_domains/README.md) — labels from the type
