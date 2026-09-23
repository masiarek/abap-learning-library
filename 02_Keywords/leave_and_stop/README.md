# `LEAVE` and `STOP` — `LEAVE PROGRAM`, `LEAVE TO SCREEN`, `LEAVE LIST-PROCESSING`, and the exit that is not `RETURN`

**Level:** 201 · working knowledge

**Status:** stub — the table is here; the worked program is not yet.

**One line:** Beyond [`RETURN` and `EXIT`](../check_continue_exit/README.md), ABAP has a family of statements that leave a **screen, a list, a transaction or the program** — each ending something different, and `STOP` jumping straight to `END-OF-SELECTION` from anywhere in a report.

## The table

| Statement | Leaves | Lands |
|---|---|---|
| `LEAVE PROGRAM.` | the whole program | the caller (`SUBMIT … AND RETURN`), or the menu |
| `LEAVE TO TRANSACTION 'X'.` | the whole program *and* the call stack | transaction X, no way back |
| `LEAVE TO SCREEN n.` / `SET SCREEN n. LEAVE SCREEN.` | the current dynpro | screen n (0 = back to the caller of `CALL SCREEN`) |
| `LEAVE LIST-PROCESSING.` | the list | the screen that called it |
| `LEAVE TO LIST-PROCESSING.` | a dynpro | a list, from inside a module pool |
| `STOP.` | `START-OF-SELECTION` | `END-OF-SELECTION`, immediately |
| `EXIT.` (outside a loop) | the processing block | the next event |

`STOP` is the odd one: a report that finds nothing to do can `STOP` and still run its `END-OF-SELECTION` output. In a class it is meaningless, and a `RETURN` is what was meant.

## Why it earns a page

Because `LEAVE PROGRAM` inside a function module or a class ends the *caller's* program too, which is never what a method should do — and because `LEAVE TO TRANSACTION` discards the whole stack including any unsaved data the calling transaction held. Both belong in the top-level program that owns the session, and nowhere lower.

## What this page still needs

- [ ] a `snippets/` report demonstrating `STOP` reaching `END-OF-SELECTION`
- [ ] the dynpro forms on a two-screen module pool
- [ ] what each does to an open LUW, recorded

## See also

- [`CHECK`, `CONTINUE`, `EXIT`, `RETURN`](../check_continue_exit/README.md) — the ordinary exits
- [Report events](../report_events/README.md) — where `STOP` lands
- [`CALL SCREEN`](../call_screen/README.md) — what `LEAVE TO SCREEN` is leaving
- [`CALL TRANSACTION`](../call_transaction/README.md) — the one-way `LEAVE TO TRANSACTION`
