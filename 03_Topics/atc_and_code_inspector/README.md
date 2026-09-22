# ATC and Code Inspector — the checks your transport is judged by

**Level:** 201 · working knowledge

**Status:** stub — the shape is here; the worked example is not yet.

**One line:** The ABAP Test Cockpit runs a configured set of Code Inspector checks — performance, security, syntax against a target release, naming, obsolete statements — over your objects, and in most landscapes a transport with errors will not be released, so the checks are part of the definition of done rather than an optional extra.

## What it checks, roughly

- **Performance** — `SELECT` inside a loop, missing `WHERE`, nested loops, `SELECT *`.
- **Security** — dynamic SQL from user input, missing authority checks, hard-coded credentials.
- **Robustness** — unhandled exceptions, `CATCH cx_root`, division without a guard.
- **Syntax and release** — checking source against a *target* release, which is how a downport is caught before transport.
- **Obsolete statements** — the list that grows every release.
- **Naming and style** — whatever the landscape has configured, which varies enormously.

`SCI` is the older front end and `ATC` the current one, with `SE80`/ADT integration. Exemptions are requested and approved rather than simply suppressed — deliberately, because an exemption is a decision someone owns.

## Its relationship with this library

The checks abaplint runs here are the same *kind* of check, run on a laptop and in CI instead of in a system: parse, syntax-check against a named release, refuse obsolete statements. See [Keywords](../../02_Keywords/README.md#what-the-machine-checks-here-and-what-it-cannot) for exactly what that does and does not prove, and note that the ATC — with the real system behind it — sees everything abaplint cannot: the SAP class library, the Dictionary, the authorization objects.

## What this page still needs

- [ ] a real ATC run over a small object, with the finding list recorded
- [ ] how to configure a check variant, and which checks are worth switching on first
- [ ] the ABAP Cloud check variant, and what it flags in ordinary old code
- [ ] the exemption workflow, and how teams keep it from becoming a rubber stamp

## See also

- [Clean ABAP](../clean_abap/README.md) — the style side of the same argument
- [ABAP Cloud](../abap_cloud/README.md) — the strictest check variant of all
- [Performance](../performance/README.md) — most ATC performance findings in one place
- [Transports](../transports/README.md) — where the check gate actually sits
