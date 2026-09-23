# ADT and SE80 — the two workbenches

**Level:** 101 · newcomer

**Status:** stub — the map is here; a walkthrough is not yet.

**One line:** ABAP has two development environments — the classic SAP GUI workbench (`SE80` and the `SE`-family transactions) and ABAP Development Tools in Eclipse (ADT) — and while both edit the same repository, new object types (CDS, RAP, ABAP Cloud) exist **only** in ADT, so the question is not which to learn but how soon to stop relying on the first.

## The map

| Task | SAP GUI | ADT |
|---|---|---|
| edit a program / class | `SE38`, `SE24`, `SE80` | the editor; `Ctrl+Shift+A` to open any object |
| Dictionary | `SE11` | DDIC objects, and **CDS only here** |
| function modules | `SE37` | supported, editing in the same editor |
| debugging | classic/new debugger, `/h` | the Eclipse debugger; same engine |
| unit tests | `SE38` → Unit test | `Ctrl+Shift+F10`; coverage with `Ctrl+Shift+F11` |
| ATC | `SE80` → Check → ATC | `Ctrl+Shift+F2` |
| transports | `SE09`/`SE10` | Transport Organizer view |
| RAP, behaviour definitions, service bindings | — | **only here** |
| screens (dynpros), GUI status | `SE51`, `SE41` | opens SAP GUI inside Eclipse |
| where-used | `Ctrl+Shift+F3` / button | `Ctrl+Shift+G` |
| pretty printer | `Shift+F1` | `Shift+F1`, with formatting settings |

ADT talks to the system over HTTP (the ADT ICF services, `SICF` → `/sap/bc/adt`), which is the first thing to activate when it cannot connect.

## Why it earns a page

Because a developer who knows only `SE80` cannot touch a CDS view, and one who knows only ADT will eventually need `SE51` for a dynpro or `SM30` for a table — and because the ADT shortcuts (`Ctrl+1` quick fix, `Ctrl+Space` completion, `F3` navigate, `Alt+U` unit tests) are where the productivity difference actually lives.

## What this page still needs

- [ ] the ADT installation and connection steps, once, with the `SICF` activation
- [ ] a shortcut table worth printing
- [ ] the "which system, which client" pitfalls of a project explorer with several systems

## See also

- [abapGit](../abapgit/README.md) — the third tool
- [ATC and Code Inspector](../atc_and_code_inspector/README.md) — the check both run
- [Debugging](../debugging/README.md) — the same debugger in two frames
- [Resources](../resources/README.md) — where to learn each
