# ABAP Cloud — released APIs only

**Level:** 301 · deep dive

**Status:** stub — the rules are here; the worked example is not yet.

**One line:** ABAP Cloud is a restricted development model — the language version `ABAP for Cloud Development` — in which only **released** APIs and released database tables may be used, which rules out a large part of classic ABAP regardless of how recent your release is.

## What stops compiling

| Out | Why, and what replaces it |
|---|---|
| Direct reads of unreleased SAP tables | use the released CDS view instead |
| `CALL FUNCTION` on unreleased modules | use the released class or API |
| `FORM` / `PERFORM` | methods |
| Classic Dynpros, `WRITE` lists, ALV GUI | Fiori, RAP, OData |
| `OPEN DATASET` | released file APIs or cloud storage services |
| Modifications and classic user exits | released extension points, BAdIs marked for cloud |

"Released" is a formal state, visible in ADT and in the API state of the object. An object that is not released may change or disappear in an upgrade — which is the whole reason for the rule: the three-tier extensibility model exists so that customer code cannot be broken by SAP changing its own internals.

The same model is increasingly applied on-premise through the `ABAP for Cloud Development` language version and the corresponding ATC check variant, which is how a landscape prepares for a move without one.

## What this page still needs

- [ ] a worked conversion of a small classic report into a cloud-ready form
- [ ] how to find the released successor of an unreleased API, reliably
- [ ] the tiers — cloud, cloud API enabled, classic — stated precisely with their rules
- [ ] the ATC cloud-readiness check over an existing object, with a recorded finding list

## See also

- [Which release am I writing for?](../releases_and_syntax_levels/README.md) — the other axis of "will this compile"
- [RAP](../rap/README.md) — the application model the cloud assumes
- [CDS views](../cds_views/README.md) — the released way to read SAP's data
- [ATC and Code Inspector](../atc_and_code_inspector/README.md) — the check variant that enforces all of this
