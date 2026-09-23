# Classic reports — lists, pages and interactive reporting

**Level:** 201 · working knowledge

**Status:** stub — the model is here; the worked example is not yet.

**One line:** A classic report writes a list with `WRITE`, breaks it into pages with `TOP-OF-PAGE`, and reacts to a click with `AT LINE-SELECTION` and the `HIDE` area — a complete UI model from the 1990s that ALV replaced for display and that still explains how thousands of shipped reports behave.

## The model

| Piece | Does |
|---|---|
| `WRITE`, `ULINE`, `SKIP`, `FORMAT`, `NEW-PAGE` | build the list |
| `TOP-OF-PAGE`, `END-OF-PAGE`, `LINE-COUNT`, `LINE-SIZE` | page structure, from the `REPORT` statement |
| `HIDE lv_field.` | remembers the field's value **for this line**, so a click can bring it back |
| `AT LINE-SELECTION` | fires on double-click; the `HIDE`d values of that line are restored |
| `AT USER-COMMAND` | fires on a toolbar button; `sy-ucomm` says which |
| `sy-lsind` | the list level — a click opens a *detail list* one level deeper, up to 20 |
| `SET PF-STATUS`, `SET TITLEBAR` | the toolbar and title of the list |
| `WRITE … AS CHECKBOX`, `HOTSPOT ON` | interactive elements on a line |

The list itself is a spool object: it can be printed, saved, sent by email, and read back from memory by another program (see [`SUBMIT`](../../02_Keywords/submit/README.md)).

## Why it is still worth understanding

Because `HIDE` and `sy-lsind` are how drill-down was done for two decades, and because the `WRITE` formatting rules — right-justified numbers, the sign on the right, DDIC output lengths — are what a user of an old report expects. New reports use [ALV](../alv/README.md); a maintainer of old ones needs this page.

## What this page still needs

- [ ] a `snippets/` report with `HIDE`, `AT LINE-SELECTION` and a second list level
- [ ] a recorded list showing the formatting rules, especially the trailing sign
- [ ] how the list appears in the spool of a background job

## See also

- [`WRITE`](../../02_Keywords/write/README.md) — the statement, and its formatting
- [Report events](../../02_Keywords/report_events/README.md) — where each of these blocks fits
- [ALV](../alv/README.md) — the replacement
- [Background jobs](../background_jobs/README.md) — the spool
