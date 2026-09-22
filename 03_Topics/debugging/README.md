# Debugging — breakpoints that survive, and watching a value change

**Level:** 201 · working knowledge

**Status:** stub — the techniques are here; the worked example is not yet.

**One line:** The ABAP debugger does more than step through code: a **watchpoint** stops when a variable changes, a **dynamic breakpoint on a statement** stops inside SAP's own code you cannot edit, and an **external breakpoint** catches a request that arrives from outside the GUI — which is how most real problems are actually found.

## The techniques worth knowing before stepping

| Technique | Answers |
|---|---|
| Watchpoint on a variable | *where* does this field get that value |
| Breakpoint at statement (`CALL CUSTOMER-FUNCTION`, `GET BADI`, `MESSAGE`) | which exit runs, where this message comes from |
| Breakpoint at message (`ID` + number) | who raises this error |
| External / HTTP breakpoint | debugging OData, RFC or a background call |
| `/h` before pressing a button | getting into the dialog at all |
| Layer-aware debugging | skipping framework code to the layer you care about |
| `JDBG` from `SM37` | debugging a finished job's step |

A breakpoint set in ADT is user-specific and survives; one set with the `BREAK-POINT` statement is in the source and will be transported if you forget it. `BREAK-POINT ID`-style checkpoint groups (`SAAB`) are the way to leave debugging aids in code without leaving landmines.

## When the debugger is the wrong tool

Data that is wrong *already* is a database question, not a stepping question: `SE16N`, an SQL trace, and the change documents. A performance problem is a [measurement](../performance/README.md) question. The debugger is for causality — which branch ran, what the value was at that moment — and it is slow for everything else.

## What this page still needs

- [ ] a worked watchpoint session against a real field, with screenshots or a transcript
- [ ] the new debugger's layout, and which tools sit where
- [ ] debugging an update task and a background job, step by step
- [ ] what to do when the authorization to debug is not there, which is common in production

## See also

- [Performance](../performance/README.md) — the neighbouring skill, and the shared transactions
- [Enhancements and BAdIs](../enhancements_and_badis/README.md) — finding the hook with a breakpoint
- [`ASSERT`](../../02_Keywords/assert/README.md) — checkpoint groups, and assertions you can switch on
- [Background jobs](../background_jobs/README.md) — debugging something you cannot start by hand
