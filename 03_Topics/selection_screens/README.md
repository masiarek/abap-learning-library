# Selection screens — the free UI, and its events

**Level:** 101 · newcomer

**Status:** stub — the event list is here; the worked example is not yet.

**One line:** Every report gets a selection screen from its `PARAMETERS` and `SELECT-OPTIONS` declarations — labels, type checks, F4 help and saveable variants included — and the part that has to be learned is the **event order**, because validation written in the wrong event produces a screen the user cannot correct.

## The events, in order

| Event | Runs | Good for |
|---|---|---|
| `INITIALIZATION` | once, before the screen appears | defaults that need code |
| `AT SELECTION-SCREEN OUTPUT` | before each display (PBO) | showing/hiding fields, greying them out |
| `AT SELECTION-SCREEN ON <field>` | after input, per field | validating one field |
| `AT SELECTION-SCREEN ON VALUE-REQUEST FOR <field>` | when the user presses F4 | a custom search help |
| `AT SELECTION-SCREEN` | after input, once | cross-field validation |
| `START-OF-SELECTION` | when the screen is accepted | the actual work |
| `END-OF-SELECTION` | after it | totals, final output |

A `MESSAGE … TYPE 'E'` in a selection-screen event returns to the screen with the field ready for correction. The same message in `START-OF-SELECTION` ends the report, leaving the user to start again. That is the whole reason the event order matters.

## Variants, and why they constrain you

A user can save a set of selection values as a variant, and a background job usually *runs* a variant. So renaming or removing a parameter breaks saved variants and the jobs that use them — a selection screen is a published interface, not a form.

## What this page still needs

- [ ] a `snippets/` program exercising every event with an output line, and a recorded run showing the order
- [ ] `SELECTION-SCREEN BEGIN OF BLOCK`, tabbed screens, and text elements for labels
- [ ] a custom F4 with `F4IF_INT_TABLE_VALUE_REQUEST`
- [ ] how a variant stores a `SELECT-OPTIONS` range, and what a dynamic date variant does

## See also

- [`PARAMETERS` and `SELECT-OPTIONS`](../../02_Keywords/parameters_select_options/README.md) — the declarations
- [`MESSAGE`](../../02_Keywords/message/README.md) — which type returns to the screen
- [Background jobs](../background_jobs/README.md) — where the variant is the only input
- [ALV](../alv/README.md) — what happens after `START-OF-SELECTION`
- [Report events](../../02_Keywords/report_events/README.md) — the blocks a report is made of, in order
- [Ranges tables](../../02_Keywords/ranges/README.md) — `TYPE RANGE OF`, and the empty table that means everything
- [`SUBMIT`](../../02_Keywords/submit/README.md) — running another report
