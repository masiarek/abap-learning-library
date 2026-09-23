# Transports — how code moves between systems

**Level:** 201 · working knowledge

**Status:** stub — the mechanics are here; the worked example is not yet.

**One line:** Every change to a repository object is recorded in a transport request, which is released in development and imported into test and production in order — and the two things that go wrong are objects left in someone else's request, and dependencies that arrive in the wrong sequence.

## The mechanics

A **package** (formerly development class) decides an object's transport layer. A **transport request** holds tasks, one per developer, each holding object entries. `SE09`/`SE10` is where you see yours; `SE01` for the full picture; `STMS` is the import queue.

Two kinds of entry behave differently: a **workbench** request carries repository objects (programs, classes, Dictionary), a **customizing** request carries client-dependent configuration. A change that needs both and is split across two requests imported in different orders is a broken test system.

`SE03` finds objects in requests, which is the tool for "who has my class locked".

## What goes wrong

- **Dependencies out of order.** A program importing before the Dictionary type it uses fails activation. Importing as a group, in sequence, is the answer.
- **Objects nobody released.** A transport that "was imported" and still shows old behaviour usually left an object behind in an unreleased task.
- **Data that is not an object.** Number ranges, some customizing, and anything created at runtime do not travel. Neither does test data.
- **Cross-client versus client-specific.** Repository objects are cross-client; configuration usually is not, and the difference explains most "it works in 100 but not in 200".

## What this page still needs

- [ ] a walk-through of one change from task to production import, with what each transaction shows
- [ ] the import log read properly: return codes 4 and 8, and what each means
- [ ] abapGit beside this, since it is how the examples in this library would actually reach a system
- [ ] what a transport of copies is for, and when to refuse one

## See also

- [Modularization](../modularization/README.md) — packages, and what belongs together
- [ATC and Code Inspector](../atc_and_code_inspector/README.md) — the gate before release
- [DDIC, domains and data elements](../ddic_and_domains/README.md) — Dictionary changes and activation
- [Which release am I writing for?](../releases_and_syntax_levels/README.md) — a downport caught at import instead of at coding time
- [Packages and namespaces](../packages_and_namespaces/README.md) — where an object lives, and who may use it
- [abapGit](../abapgit/README.md) — Git for ABAP
