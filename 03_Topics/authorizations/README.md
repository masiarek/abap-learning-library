# Authorizations — the check nobody does for you

**Level:** 201 · working knowledge

**Status:** stub — the model is here; the worked example is not yet.

**One line:** SAP's authorization model is roles built from authorization objects with fields and values, and the part that belongs to a developer is small and non-negotiable: Open SQL checks nothing, so every program that reads or changes restricted data has to perform the check itself — and check `sy-subrc` afterwards.

## The model in four lines

- An **authorization object** (`SU21`) has up to ten fields — typically an activity (`ACTVT`) plus an organisational field like company code or plant.
- An **authorization** is values for those fields; a **role** (`PFCG`) bundles authorizations; a user has roles.
- A **transaction** is checked automatically when it starts (`S_TCODE`); nothing else is automatic.
- Everything else is [`AUTHORITY-CHECK`](../../02_Keywords/authority_check/README.md) in code, or a declared check in a [CDS view](../cds_views/README.md).

## The developer's actual job

1. Find the **right** object for the data being read — usually the one SAP's own transaction uses for the same table.
2. Check it **once, early**, not per row and not after the data has been displayed.
3. Read `sy-subrc`, and fail with a message that names what was missing.
4. When the report is generic or dynamic, check the *target*, not the entry point — see [Dynamic programming](../dynamic_programming/README.md).

When a user says "no authorization", `SU53` shows the last failed check, which is what a security colleague needs from them. If your own check failed for a reason `SU53` cannot show — because you never made one — that conversation is longer.

## What this page still needs

- [ ] a `snippets/` program with a real object, `ACTVT`, and proper `sy-subrc` handling
- [ ] how to find the right object for a table, in steps, with `SU22` and SAP's own code
- [ ] DCL access control on a CDS view, beside the classic check, doing the same job
- [ ] what `S_DEVELOP`, `S_DATASET` and debug authority imply in production

## See also

- [`AUTHORITY-CHECK`](../../02_Keywords/authority_check/README.md) — the statement
- [Open SQL](../open_sql/README.md) — which checks nothing
- [CDS views](../cds_views/README.md) — declaring the check with the model
- [ATC and Code Inspector](../atc_and_code_inspector/README.md) — the security checks that look for a missing one
