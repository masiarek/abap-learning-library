# Report events — `INITIALIZATION`, `AT SELECTION-SCREEN`, `START-OF-SELECTION`

**Level:** 101 · newcomer

**One line:** An executable program is not run top to bottom — it is a set of **event blocks** the runtime calls in a fixed order, and which block a statement sits in decides whether it runs before the screen, after input, per field, once per page, or never.

## The order

| Event | Fires | Put here |
|---|---|---|
| `LOAD-OF-PROGRAM` | when the program is loaded | almost nothing |
| `INITIALIZATION` | once, before the selection screen | defaults that need code |
| `AT SELECTION-SCREEN OUTPUT` | before each display of the screen | hide, show, grey out fields |
| `AT SELECTION-SCREEN ON <field>` | after input, per field | single-field validation |
| `AT SELECTION-SCREEN ON VALUE-REQUEST FOR <field>` | on F4 | a custom search help |
| `AT SELECTION-SCREEN` | after input, once | cross-field validation |
| `START-OF-SELECTION` | when the screen is accepted | the work |
| `GET <node>` | per record of a logical database | legacy |
| `END-OF-SELECTION` | after the work | totals, output |
| `TOP-OF-PAGE`, `END-OF-PAGE` | per list page | headers, footers |
| `AT LINE-SELECTION`, `AT USER-COMMAND` | on a list interaction | interactive reporting |

Blocks are written in any order in the source; the runtime, not the file, decides when each runs. A statement that sits **after the declarations and before the first event keyword** belongs to `START-OF-SELECTION` implicitly — which works, and hides the structure from the next reader.

## The one that costs

A validation in the wrong block. `MESSAGE … TYPE 'E'` inside `AT SELECTION-SCREEN ON p_x` returns to the screen with that field open; the same message inside `START-OF-SELECTION` ends the program and sends the user back to the transaction code. See [Selection screens](../../03_Topics/selection_screens/README.md).

The other is the report that is really a class. Everything in the table above is a hook; the work in `START-OF-SELECTION` should be one call into a [local class](../class/README.md), because nothing in an event block can be unit tested.

<!-- snippet:z_kw_report_events -->
*[`z_kw_report_events.prog.abap`](snippets/z_kw_report_events.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_report_events.

PARAMETERS p_qty TYPE i DEFAULT 1.

DATA gv_checked TYPE abap_bool.

INITIALIZATION.
  " Once, before the selection screen appears. A default that needs code --
  " last month, the user's company code -- goes here, not in DEFAULT.
  p_qty = 5.

AT SELECTION-SCREEN ON p_qty.
  " After input, for this one field. An E message here returns to the screen
  " with the field open for correction; the same message later would not.
  IF p_qty < 0.
    MESSAGE 'Quantity cannot be negative' TYPE 'E'.
  ENDIF.

AT SELECTION-SCREEN.
  " After input, once, for checks that involve more than one field.
  gv_checked = abap_true.

START-OF-SELECTION.
  " The report proper. Statements after the declarations and before the first
  " event keyword ALSO land here, implicitly -- write the keyword.
  WRITE: / 'processing quantity', p_qty.
  WRITE: / 'validated', gv_checked.

END-OF-SELECTION.
  " After START-OF-SELECTION has finished (and, with a logical database, after
  " it has delivered its last record).
  WRITE: / 'done'.

TOP-OF-PAGE.
  " Before the first line of each list page -- the place for a page header.
  WRITE: / 'Report events, in the order they fire'.
  ULINE.
```
<!-- /snippet -->

## If you are coming from another language

- **GUI frameworks.** These are lifecycle callbacks — `onCreate`, `onSubmit`, `onValidate` — for a form the framework draws for you.
- **Scripts.** There is no `main` that runs top to bottom. The nearest is a script whose functions are invoked by a harness in a documented order.

## See also

- [`PARAMETERS` and `SELECT-OPTIONS`](../parameters_select_options/README.md) — what the screen is made of
- [Selection screens](../../03_Topics/selection_screens/README.md) — the topic page, with variants
- [Classic reports](../../03_Topics/classic_reports/README.md) — `TOP-OF-PAGE`, `AT LINE-SELECTION`, and the list
- [`CHECK`, `CONTINUE`, `EXIT`, `RETURN`](../check_continue_exit/README.md) — leaving an event block early
- [Logical databases](../../03_Topics/logical_databases/README.md) — where `GET` comes from
