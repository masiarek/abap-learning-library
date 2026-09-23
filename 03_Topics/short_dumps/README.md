# Short dumps — reading `ST22`

**Level:** 201 · working knowledge

**Status:** stub — the reading order is here; annotated dumps are not yet.

**One line:** A runtime error ends the program with a **short dump**: a document in `ST22` that names the error (`CX_SY_ZERODIVIDE`, `ITAB_LINE_NOT_FOUND`, `TIME_OUT`), the line, the call stack, every variable in scope and a *How to correct the error* section — and reading it in the right order answers most incidents without a debugger.

## Reading order

1. **Runtime error and exception class** at the top. The name is the diagnosis: `CONVT_NO_NUMBER`, `DBIF_RSQL_SQL_ERROR`, `MEMORY_NO_MORE_PAGING`, `CALL_FUNCTION_NOT_FOUND`…
2. **What happened / What can you do / Error analysis** — SAP's own prose, often exact.
3. **Source code extract** — the failing line, marked `>>>>>`, with fifteen lines either side.
4. **Active calls / events** — the stack, top frame first; the first `Z` entry is usually where to look.
5. **Chosen variables** — the values in scope at the moment of the error, which is what the debugger would have shown.
6. **Information on where terminated** — program, include, line, and whether it ran in dialog or in a job (`SM37` links back).

Dumps are kept for a configurable time (`rsts_*` / `RSSNAPDL` housekeeping), and `ST22` searches by user, date, program and error name across the system.

## The ones you will see most

| Dump | Usually means |
|---|---|
| `CX_SY_ITAB_LINE_NOT_FOUND` | `itab[ … ]` with no such row and no `OPTIONAL` |
| `CX_SY_REF_IS_INITIAL` / `OBJECTS_OBJREF_NOT_ASSIGNED` | `->` on an unbound reference |
| `CX_SY_ZERODIVIDE` | division by a variable that was zero |
| `CX_SY_CONVERSION_NO_NUMBER` | text into a number |
| `CX_SY_OPEN_SQL_DB` / `DBIF_RSQL_*` | the database refused the statement; the SQL error is in the text |
| `TIME_OUT` | a dialog step past `rdisp/max_wp_run_time` — a job, or a fix |
| `TSV_TNEW_PAGE_ALLOC_FAILED` | out of memory — an internal table that should have been a cursor |
| `CALL_FUNCTION_CONFLICT_TYPE` | a parameter type mismatch across an RFC |
| `ASSERTION_FAILED` | an [`ASSERT`](../../02_Keywords/assert/README.md) — the program said so on purpose |
| `RAISE_EXCEPTION` | a classic exception nobody listed in `EXCEPTIONS` |

## What this page still needs

- [ ] three real dumps, anonymised, annotated section by section
- [ ] the debugger's *jump to dump* feature, and `ST22` → debug-at-line replay
- [ ] `RAISE SHORTDUMP`'s attributes in the analysis, recorded

## See also

- [Exceptions](../exceptions/README.md) — the classes behind the names
- [`TRY`, `CATCH`, `RAISE`](../../02_Keywords/try_catch/README.md) — catching them instead
- [Debugging](../debugging/README.md) — when reading is not enough
- [`RAISE SHORTDUMP`](../../02_Keywords/raise_shortdump/README.md) — a dump on purpose
- [How ABAP runs](../how_abap_runs/README.md) — `TIME_OUT` and memory limits
