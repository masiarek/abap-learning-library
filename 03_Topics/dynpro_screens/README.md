# Dynpro screens — the classic GUI model

**Level:** 301 · deep dive

**Status:** stub — the model is here; the worked example is not yet.

**One line:** A dynpro is a screen painted in the Screen Painter and driven by flow logic — `PROCESS BEFORE OUTPUT` fills it, `PROCESS AFTER INPUT` reads it — with fields transported between screen and program by **name**, which is the single fact that explains most "my module does not see the value" questions.

## The model in five points

1. **A screen belongs to a program** and has a number; `CALL SCREEN 100` shows it.
2. **Flow logic** is a small language of its own: `PROCESS BEFORE OUTPUT` and `PROCESS AFTER INPUT`, each a list of `MODULE` calls and `FIELD` statements, in a separate editor from the ABAP.
3. **Field transport is by name**: a screen field `SCARR-CARRID` is copied to and from the program's global variable of the same name — which is what the obsolete `TABLES` statement was for.
4. **PAI transports before it runs modules**, in flow-logic order; `FIELD f MODULE m` transports `f` just before `m`, and a failed check inside `m` reopens only the fields named in that `FIELD` (or `CHAIN … ENDCHAIN`).
5. **`sy-ucomm` / the `OK_CODE` field** carries the function the user chose; the GUI status (`SET PF-STATUS`) defines which functions exist.

Compound elements: table controls (a scrollable grid bound to an internal table, walked with `LOOP AT … WITH CONTROL` in flow logic), tabstrips, subscreens (a screen inside a screen area), and custom containers that host [ALV](../alv/README.md) and other GUI controls, which then talk back through [events](../../02_Keywords/events/README.md).

## Why it is here

Not for new development: Fiori, RAP and OData are where a new UI goes. It is here because every classic transaction — and every enhancement to one, and every `BDC` recording — is a sequence of dynpros, and because debugging one without the transport rules in your head is guesswork.

## What this page still needs

- [ ] a minimal module pool with one screen, its flow logic shown beside the program
- [ ] the field-transport order worked through with a failing check
- [ ] a table control, and why the flow-logic `LOOP` is not an ABAP loop
- [ ] `SHDB` recording of a standard transaction, annotated

## See also

- [`CALL SCREEN`, `MODULE`, `PROCESS BEFORE OUTPUT`](../../02_Keywords/call_screen/README.md) — the statements
- [Program types](../program_types/README.md) — the module pool
- [Batch input and BDC](../batch_input/README.md) — driving screens from code
- [Events](../../02_Keywords/events/README.md) — GUI controls
- [Web Dynpro and legacy UI](../web_dynpro_and_legacy_ui/README.md) — what came between this and Fiori
