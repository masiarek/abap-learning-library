# `AUTHORITY-CHECK` — the check nobody does for you

**Level:** 201 · working knowledge

**Status:** stub — the shape is here; the worked program is not yet.

**One line:** Open SQL applies **no** authorization checks, so a `SELECT` returns every row the query asks for regardless of what the user may see — `AUTHORITY-CHECK` is the statement that asks, it reports through `sy-subrc`, and forgetting to check `sy-subrc` makes the statement decorative.

## What it does

```abap
AUTHORITY-CHECK OBJECT 'F_BKPF_BUK'
  ID 'BUKRS' FIELD lv_bukrs
  ID 'ACTVT' FIELD '03'.
IF sy-subrc <> 0.
  MESSAGE e001(zfin) WITH lv_bukrs.
ENDIF.
```

The object (`SU21`) names the fields; every `ID` must be supplied or explicitly given `DUMMY`, or the check is not the check you think it is. `sy-subrc = 0` means authorized; anything else means not, and the statement itself never raises.

## Why it earns a page

Three failure modes, all common:

1. **No check at all** — the report runs fine for its author, who has everything, and shows another company code's data to someone who should not see it.
2. **A check whose `sy-subrc` is not read** — the statement is present, an audit finds it, and it protects nothing.
3. **A check in the wrong place** — after the data has been selected and displayed, or inside a loop where it costs a kernel call per row when one check per company code would do.

Where the check belongs is a design question: at the entry point of the service, not scattered through the helpers. [CDS views](../../03_Topics/cds_views/README.md) can carry an access control object (DCL) so the restriction lives with the model instead of in every program that reads it, which is the direction new development goes.

## What this page still needs

- [ ] a `snippets/` program with a check, its `sy-subrc` handling, and a `DUMMY` field
- [ ] how to find the right authorization object for a table (`SU22`, and reading SAP's own code)
- [ ] `SU53` after a failed check, and what a functional colleague needs from you
- [ ] where the check belongs in a RAP behaviour definition

## See also

- [Authorizations](../../03_Topics/authorizations/README.md) — the topic page
- [`SELECT`](../select/README.md) — the statement that checks nothing
- [CDS views](../../03_Topics/cds_views/README.md) — access control declared with the model
- [ATC and Code Inspector](../../03_Topics/atc_and_code_inspector/README.md) — the checks that look for a missing check
- [`CALL TRANSACTION`](../call_transaction/README.md) — running a transaction from code
- [Security](../../03_Topics/security/README.md) — injection in dynamic SQL, code and file paths
