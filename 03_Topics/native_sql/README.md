# Native SQL — when Open SQL is not enough, and what it costs

**Level:** 301 · deep dive

**Status:** stub — the trade is here; the worked example is not yet.

**One line:** Native SQL — `EXEC SQL` or the ADBC classes — sends a statement to the database as written, which is the only way to reach a vendor-specific feature and also gives up everything Open SQL was doing for you: the client column, the syntax check, portability, the table buffer, and the escaping that stops SQL injection.

## What you lose, exactly

| Open SQL did this | Native SQL does not |
|---|---|
| added `MANDT = sy-mandt` to every access | you write it, or you read every client |
| checked syntax and column names at compile time | errors arrive at runtime, as `CX_SQL_EXCEPTION` |
| translated to each database's dialect | the statement runs on the one it was written for |
| used the SAP table buffer where configured | the buffer is bypassed, and stale for later readers |
| escaped host variables (`@lv`) | a string built from input is an injection |
| was analysed by the ATC | the statement is opaque text to every tool |

## When it is right

- A HANA feature Open SQL and CDS do not expose — and [AMDP](../amdp_and_code_pushdown/README.md) should be considered first, because it is at least structured.
- DDL in a migration or installation tool.
- A hint the optimiser needs, where `%_HINTS` in Open SQL cannot express it.
- Reading a non-SAP database through a secondary connection (`DBCON`), which is the one case with no alternative.

ADBC (`cl_sql_connection`, `cl_sql_statement`, `cl_sql_result_set`) is the current API and takes bound parameters, which is how injection is avoided. `EXEC SQL` is obsolete and gone in ABAP Cloud.

## What this page still needs

- [ ] a `snippets/` program with an ADBC query, parameters bound, the client handled, the result read
- [ ] the secondary-connection case with `DBCON`
- [ ] the SQL trace of a native statement, recorded, beside an equivalent Open SQL one

## See also

- [`EXEC SQL` and ADBC](../../02_Keywords/exec_sql/README.md) — the statements
- [Open SQL](../open_sql/README.md) — what is being bypassed
- [AMDP and code pushdown](../amdp_and_code_pushdown/README.md) — the structured alternative
- [Security](../security/README.md) — SQL injection
- [HANA specifics](../hana_specifics/README.md) — the usual reason to want native SQL
