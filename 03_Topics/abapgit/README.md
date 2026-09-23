# abapGit — Git for ABAP

**Level:** 201 · working knowledge

**Status:** stub — the model is here; a walkthrough is not yet.

**One line:** abapGit is an open-source client, written in ABAP, that serialises repository objects into files — `zcl_thing.clas.abap`, `z_report.prog.abap` — and pushes and pulls them to any Git host, which is how ABAP code gets code review, branches, an open-source ecosystem and, for this library, examples that can be pulled straight into a system.

## The model

- **A package is a repository.** Everything under the package (and its sub-packages) is serialised; the object's type is the file infix — the naming this library's examples follow, and the reason [abaplint](https://abaplint.org) can type a file from its name.
- **Online repository:** linked to a remote; pull, push, branches, from the abapGit UI in the system.
- **Offline repository:** a zip file, for systems that cannot reach the internet.
- **Serialisation is text.** Classes become one `.abap` file per class (with test include and local definitions in separate files), a Dictionary table becomes an XML file, a message class becomes XML. Diffs are readable.
- **`.abapgit.xml`** at the root names the starting folder and the folder logic (prefix or full); `abaplint.json` beside it, if present, is picked up by the ecosystem's tooling.

Installation is one program (`zabapgit_standalone`) pasted into `SE38`, or the developer edition as a package, and the transport system is untouched — abapGit works *alongside* transports, not instead of them, unless a landscape decides otherwise.

## Why it earns a page

Because it is the bridge to every practice ABAP lacked: pull requests, CI with abaplint, a GitHub of reusable ABAP (abapGit's own organisation, `abap2xlsx`, `ajson`, the open-abap projects), and a way to keep a personal library of code across employers. And because the file naming it established is why this repository's `snippets/` can exist at all.

## What this page still needs

- [ ] installing the standalone version and linking a package to a repository, recorded
- [ ] pulling this library's `snippets/` into a system, and what does and does not arrive (no transcripts, on purpose)
- [ ] the transport-versus-Git question as landscapes actually settle it

## See also

- [Transports](../transports/README.md) — the mechanism abapGit runs beside
- [ATC and Code Inspector](../atc_and_code_inspector/README.md) — and abaplint, the CI equivalent
- [ADT and SE80](../tooling_adt_and_se80/README.md) — the editors
- [CONTRIBUTING](../../CONTRIBUTING.md) — why the files here are named the abapGit way
