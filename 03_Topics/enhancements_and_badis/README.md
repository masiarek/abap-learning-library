# Enhancements and BAdIs — changing SAP without modifying SAP

**Level:** 301 · deep dive

**Status:** stub — the ladder is here; the worked example is not yet.

**One line:** SAP ships hook points so customers can add behaviour without changing SAP's code — user exits, customer exits, BAdIs, and enhancement points — and the rule that matters is to use the highest-level hook available, because a modification of SAP's own source is a debt paid at every upgrade.

## The ladder, newest first

| Mechanism | Era | Found with |
|---|---|---|
| Enhancement spots / implicit enhancements | NetWeaver 7.0+ | ADT, `SE18`/`SE19`, the source itself |
| BAdI (new, enhancement-spot based) | 7.0+ | `SE18`, `SE19` |
| BAdI (classic) | 4.6+ | `SE18`, `SE19` |
| Customer exit (`EXIT_…` function module, `CMOD`/`SMOD`) | 3.x+ | `SMOD`, `CMOD` |
| User exit (`FORM` in an SAP include, e.g. `MV45AFZZ`) | oldest | the include itself |
| Modification | last resort | `SE95`, and every upgrade |

The practical skill is **finding** the hook for a given moment in a standard transaction: a breakpoint on `CALL CUSTOMER-FUNCTION`, on `cl_exithandler=>get_instance`, or on `GET BADI`; the where-used list of the standard program; and reading the standard code around the point where the field you care about is set.

## What makes this hard in practice

- A BAdI's **filter** decides which implementation runs; two implementations with overlapping filters is a bug that only appears with the right data.
- An enhancement runs inside SAP's transaction. A [`COMMIT WORK`](../../02_Keywords/commit_work/README.md) of your own there can leave SAP's own update half-written.
- The data you want may not be in scope at the hook you found — which is where people reach for `FIELD-SYMBOLS` and `(program)` global access, and where a later support package quietly changes the variable's name.
- Enhancements are invisible from the calling code: someone reading the standard program sees nothing, and the behaviour changes anyway.

## What this page still needs

- [ ] a worked BAdI implementation, from finding the spot to activating a filter
- [ ] the debugger technique for locating the right hook, step by step
- [ ] what an upgrade does to each kind, and what `SPAU`/`SPDD` ask of you
- [ ] the ABAP Cloud story: which of these survive, and what replaces the rest

## See also

- [`CALL FUNCTION`](../../02_Keywords/call_function/README.md) — customer exits are function modules
- [`FORM` and `PERFORM`](../../02_Keywords/perform_form/README.md) — user exits are subroutines
- [Debugging](../debugging/README.md) — how the hook is found
- [LUW and locking](../luw_and_locking/README.md) — why committing inside an exit is dangerous
- [Transports](../transports/README.md) — how an enhancement travels, and what it collides with
