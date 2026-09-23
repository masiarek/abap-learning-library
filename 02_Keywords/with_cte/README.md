# `WITH` — common table expressions in Open SQL

**Level:** 301 · deep dive

**One line:** Since 7.51, `WITH +name AS ( SELECT … ) SELECT … FROM +name …` names a subquery once and uses it like a table in the main query — which replaces a temporary internal table and a second `SELECT` with one round trip the database can optimise as a whole.

## The shape

```abap
WITH
  +busy AS ( SELECT carrid, connid, seatsocc FROM sflight WHERE seatsocc > 0 ),
  +per_carrier AS ( SELECT carrid, COUNT(*) AS flights FROM +busy GROUP BY carrid )
  SELECT p~carrid, s~carrname, p~flights
    FROM +per_carrier AS p
    INNER JOIN scarr AS s ON s~carrid = p~carrid
    INTO TABLE @DATA(lt_result).
```

Every CTE name starts with `+`. Each may use the ones before it. The final `SELECT` is an ordinary one with an `INTO`, and the whole thing is a single statement ending in one period.

## When it earns its place

- **A subquery used twice.** Without `WITH` it is written twice or materialised into an internal table between two `SELECT`s.
- **A staged aggregate** — filter, then group, then join the grouped result — where the staging is clearer as named steps than as nested subqueries.
- **Avoiding the round trip.** Two `SELECT`s with an internal table between them transfer the intermediate rows to the application server and back; the CTE keeps them on the database.

What it is **not** is a substitute for a [CDS view](../../03_Topics/cds_views/README.md). A CTE lives in one program; a view is reusable, annotated, and can carry access control. A CTE is the right tool when the intermediate result is genuinely local to one query.

Release matters here more than usual: `WITH` needs 7.51, and a program using it does not compile on 7.50 or below. See [Which release am I writing for?](../../03_Topics/releases_and_syntax_levels/README.md)

<!-- snippet:z_kw_with_cte -->
*[`z_kw_with_cte.prog.abap`](snippets/z_kw_with_cte.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_with_cte.

" WITH (7.51+) names a subquery once and uses it like a table in the main
" SELECT -- Open SQL's common table expression. Each name starts with +.
WITH
  +busy AS (
    SELECT carrid, connid, fldate, seatsocc
      FROM sflight
      WHERE seatsocc > 0 ),
  +per_carrier AS (
    SELECT carrid, COUNT(*) AS flights, SUM( seatsocc ) AS occupied
      FROM +busy
      GROUP BY carrid )
  SELECT p~carrid, s~carrname, p~flights, p~occupied
    FROM +per_carrier AS p
    INNER JOIN scarr AS s ON s~carrid = p~carrid
    ORDER BY p~carrid
    INTO TABLE @DATA(lt_result).

LOOP AT lt_result INTO DATA(ls_r).
  WRITE: / ls_r-carrid, ls_r-carrname, ls_r-flights, ls_r-occupied.
ENDLOOP.
WRITE: / 'carriers with busy flights', lines( lt_result ).
```
<!-- /snippet -->

## If you are coming from another language

- **SQL.** It is the standard `WITH` clause, with `+` on the names and ABAP's `@` host-variable rules inside. Recursive CTEs are not supported in Open SQL.

## See also

- [`SELECT`](../select/README.md) — the statement the CTE feeds
- [Open SQL](../../03_Topics/open_sql/README.md) — pushing work to the database
- [CDS views](../../03_Topics/cds_views/README.md) — the reusable alternative
- [Which release am I writing for?](../../03_Topics/releases_and_syntax_levels/README.md) — 7.51 and up
