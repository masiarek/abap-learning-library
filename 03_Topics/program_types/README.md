# Program types — executable, module pool, function group, class pool

**Level:** 101 · newcomer

**Status:** stub — the table is here; the worked example is not yet.

**One line:** Every ABAP source belongs to a program of one of seven types, and the type decides what the program may contain and how it starts — an executable runs from `SUBMIT` or a transaction, a module pool only from a transaction, a function group only when one of its function modules is called, a class pool only through its class.

## The types

| Type | Attribute | Starts by | Holds |
|---|---|---|---|
| Executable program (report) | `1` | `SUBMIT`, `SE38` execute, a report transaction | event blocks, local classes, screens |
| Module pool | `M` | a dialog transaction (`SE93`) | screens and their modules; no `START-OF-SELECTION` |
| Function group | `F` | a `CALL FUNCTION` | function modules, shared global data, screens |
| Class pool | `K` | using the global class | exactly one global class |
| Interface pool | `J` | — | one global interface |
| Include | `I` | never directly | source inserted into others |
| Type pool | `T` | — | shared types and constants (obsolete since 7.02) |
| Subroutine pool | `S` | `PERFORM … IN PROGRAM` | `FORM`s (obsolete) |

An **include** is the only one that is pure text: it has no runtime existence of its own. The others are compilation units, each with its own global namespace.

## Why it matters

- A **function group's** global data is shared by all its modules and lives for the session — the mechanism behind every "buffered" SAP function module and the reason a second call can behave differently.
- A **class pool** cannot have screens or event blocks; a global class that needs a dynpro puts it in a function group and calls it.
- A **transaction** (`SE93`) is just a name bound to one of these: a report transaction to an executable, a dialog transaction to a module pool and screen, an OO transaction to a class method.

## What this page still needs

- [ ] the same small logic in an executable, a function group and a class pool, side by side
- [ ] what `SE93` asks for each transaction type
- [ ] the attribute screen in `SE38`/ADT, and what "Unicode checks active" and "fixed point arithmetic" mean

## See also

- [Report events](../../02_Keywords/report_events/README.md) — the executable's structure
- [Dynpro screens](../dynpro_screens/README.md) — the module pool's
- [Modularization](../modularization/README.md) — function groups and classes
- [`CALL TRANSACTION`](../../02_Keywords/call_transaction/README.md) — starting any of them by transaction code
