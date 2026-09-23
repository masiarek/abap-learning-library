# Change documents — who changed what, and when

**Level:** 201 · working knowledge

**Status:** stub — the mechanism is here; the worked example is not yet.

**One line:** A change document records the old and new value of every logged field of a business object, with user and timestamp, in `CDHDR`/`CDPOS` — written by the standard transactions automatically and by your own code only if you generate the change document object (`SCDO`) and call its function modules, which a direct database `UPDATE` never does.

## The mechanism

1. Mark the field's data element as *change document* relevant.
2. Create a change document object in `SCDO` for the table(s); it generates function modules `ZOBJECT_WRITE_DOCUMENT` and friends.
3. In your code, after the change and before the commit, call the generated module with the before and after images.
4. Read them back with `CHANGEDOCUMENT_READ`, or in the transaction's *Environment → Changes* menu, or straight from `CDHDR` and `CDPOS`.

## Why it earns a page

Because auditors ask, and because the answer to "who set this credit limit" is only there if something wrote it. A BAPI writes change documents; a standard transaction writes them; a [direct database write](../../02_Keywords/db_writes/README.md) to the same table does not, and neither does a BAdI that quietly adjusts a field after the standard has already logged it. `CDPOS` is also one of the largest tables in most systems, which is a fact about archiving as much as about logging.

## What this page still needs

- [ ] a change document object generated for a demo table, and the call that writes it
- [ ] `CDHDR`/`CDPOS` rows for one change, recorded
- [ ] how a RAP business object gets change documents

## See also

- [Database writes](../../02_Keywords/db_writes/README.md) — what skips them
- [BAPIs and RFC](../bapis_and_rfc/README.md) — what writes them
- [Application log](../application_log/README.md) — the other trail
- [DDIC, domains and data elements](../ddic_and_domains/README.md) — the flag on the data element
