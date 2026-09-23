# `EXEC SQL` and ADBC — native SQL

**Level:** 301 · deep dive

**Status:** stub — the shapes are here; the worked program is not yet.

**One line:** Native SQL bypasses Open SQL and sends a statement to the database as written — through `EXEC SQL … ENDEXEC` (static, obsolete) or `cl_sql_statement` (ADBC, the current way) — which unlocks database-specific features and gives up portability, client handling, the buffer, the syntax check and the authorization checks in one move.

## The shapes

```abap
EXEC SQL.                                         " obsolete, but everywhere
  SELECT count(*) INTO :lv_count FROM sflight WHERE mandt = :sy-mandt
ENDEXEC.

DATA(lo_stmt) = NEW cl_sql_statement( ).           " ADBC
DATA(lo_result) = lo_stmt->execute_query( |SELECT count(*) FROM sflight WHERE mandt = '{ sy-mandt }'| ).
lo_result->set_param( REF #( lv_count ) ).
lo_result->next( ).
lo_result->close( ).
```

Two things Open SQL did silently are now yours: the **client** (`MANDT`) column, which native SQL does not add, and the **schema**, which on some databases has to be named. Forgetting the client is the classic native-SQL bug: a count across every client, returned as if it were yours.

## Why it earns a page, and when to reach for it

Native SQL exists for the cases Open SQL cannot express — a HANA-specific function, a hint, a database-vendor feature, a DDL statement in a migration tool. For everything else it is a step backwards: no syntax check until runtime, no portability, an ATC finding, and the [SQL injection](../../03_Topics/security/README.md) surface that Open SQL's host-variable escaping was protecting you from. A string template building a query from user input is a vulnerability, not a technique.

`EXEC SQL` is obsolete and forbidden in ABAP Cloud; ADBC is the released form on-premise. [AMDP](../../03_Topics/amdp_and_code_pushdown/README.md) is the structured way to write database-specific code when the reason is HANA.

## What this page still needs

- [ ] a `snippets/` program with an ADBC query, parameters bound safely, and the client handled
- [ ] the injection example, shown and refused
- [ ] what the SQL trace shows for a native statement versus an Open SQL one

## See also

- [Native SQL](../../03_Topics/native_sql/README.md) — the topic page
- [`SELECT`](../select/README.md) — what you are giving up
- [AMDP and code pushdown](../../03_Topics/amdp_and_code_pushdown/README.md) — the structured alternative for HANA
- [Security](../../03_Topics/security/README.md) — SQL injection
