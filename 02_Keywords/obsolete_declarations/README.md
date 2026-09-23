# Obsolete declarations — `TABLES`, `OCCURS`, `WITH HEADER LINE`, `RANGES`, `TYPE-POOLS`

**Level:** 201 · working knowledge

**Status:** stub — for recognition; the worked example is deliberately absent.

**One line:** Five declaration forms that ABAP no longer recommends and never removed: a `TABLES` work area shared with the screen, an internal table declared `OCCURS n`, one `WITH HEADER LINE` that is a table *and* a structure under one name, `RANGES` for a ranges table, and `TYPE-POOLS` to load a type pool that modern releases load on their own.

## Recognition table

| You read | It means | Write instead |
|---|---|---|
| `TABLES scarr.` | a global structure `scarr` shared with any screen field of that name | a `DATA` structure; nothing, in a class |
| `DATA lt TYPE TABLE OF … OCCURS 10.` | a standard table (the 10 was a memory hint, long ignored) | `TYPE STANDARD TABLE OF … WITH EMPTY KEY` |
| `DATA lt … WITH HEADER LINE.` | `lt` is a table **and** a structure; `lt-field` reads the header, `lt[]` names the table | separate table and work area |
| `RANGES r FOR scarr-carrid.` | a ranges table | `TYPE RANGE OF` — see [Ranges tables](../ranges/README.md) |
| `TYPE-POOLS abap.` | loads the type pool | nothing since 7.02; pools load on use |
| `DATA lv(10) TYPE c.` | length in parentheses | `TYPE c LENGTH 10` |
| `LIKE` in a `DATA` (referring to a table field) | old spelling of `TYPE` for Dictionary fields | `TYPE` |

The **header line** is the one that costs. `LOOP AT lt.` with no `INTO` reads each row into the header line silently; `APPEND lt.` appends the header line; `CLEAR lt` clears the *header*, `REFRESH lt` the *table*, and `lt[]` in a call passes the table while `lt` passes the structure. A whole class of bug in old reports is a header line used as a row. Classes forbid header lines outright, which is one more argument for putting code in one.

## What this page still needs

- [ ] a short old-style program shown (not linted — abaplint's `obsolete_statement` rule refuses several of these, which is the point) beside its modern rewrite
- [ ] the ATC findings each form produces, recorded
- [ ] `TABLES` and its screen coupling, worked through on a dynpro

## See also

- [Ranges tables](../ranges/README.md) — `TYPE RANGE OF`
- [`FORM` and `PERFORM`](../perform_form/README.md) — the obsolete unit these usually live in
- [`MOVE`, `ADD`, `COMPUTE`](../move_add_compute/README.md) — the obsolete statements, same shelf
- [Internal tables](../../03_Topics/internal_tables/README.md) — the modern declaration
- [Modern versus classic](../../03_Topics/modern_vs_classic/README.md) — the whole rewrite table
