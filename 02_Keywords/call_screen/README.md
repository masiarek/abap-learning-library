# `CALL SCREEN`, `MODULE`, `PROCESS BEFORE OUTPUT` — classic screens

**Level:** 301 · deep dive

**Status:** stub — the vocabulary is here; the worked program is not yet.

**One line:** A classic screen (dynpro) is painted in the Screen Painter and driven by two flow-logic events — `PROCESS BEFORE OUTPUT` before it is shown and `PROCESS AFTER INPUT` after the user acts — each calling `MODULE`s in the program; `CALL SCREEN 100` starts one, `SET SCREEN 0` and `LEAVE SCREEN` end it, and the whole model is what Fiori replaced and what every classic transaction still runs on.

## The vocabulary

| Term | Is |
|---|---|
| Screen (dynpro) | number + layout + flow logic, belongs to a program |
| `PROCESS BEFORE OUTPUT` (PBO) | flow-logic event before display: fill fields, set status |
| `PROCESS AFTER INPUT` (PAI) | after the user's action: validate, react to `sy-ucomm` |
| `MODULE name.` (flow logic) / `MODULE name INPUT.` (program) | the callable units the events invoke |
| `FIELD f MODULE m ON INPUT.` | conditional module per field; makes the field open for correction on error |
| GUI status / title (`SET PF-STATUS`, `SET TITLEBAR`) | the toolbar and menu |
| `sy-ucomm`, `OK_CODE` | which button was pressed |
| Table control, tabstrip, subscreen, custom control (`cl_gui_custom_container`) | the compound elements |
| Module pool (`SAPMZ…`) | a program whose purpose is screens |

`CALL SCREEN 100 STARTING AT 10 5` opens it as a popup. `LEAVE TO SCREEN 0` returns to the caller.

## Why it earns a page

Not to write new ones — Fiori and RAP are where UI goes now — but because `VA01`, `ME21N`, `FB01` and every enhancement to them live in this model, and because "why does my `MODULE` not see the field's new value" has one answer (PAI transfers the field before the module runs, in flow-logic order) that nobody can guess.

## What this page still needs

- [ ] a minimal module pool: one screen, one field, one button, with the flow logic beside the program
- [ ] the field-transport order between screen and program, worked through
- [ ] a table control, and why `LOOP AT … WITH CONTROL` in flow logic is not a normal loop

## See also

- [Dynpro screens](../../03_Topics/dynpro_screens/README.md) — the topic page
- [`CALL TRANSACTION`](../call_transaction/README.md) — starting a screen-based transaction
- [Events](../events/README.md) — how GUI controls talk back
- [ALV](../../03_Topics/alv/README.md) — the control most screens exist to hold
