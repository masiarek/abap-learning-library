# `SELECT` — the database, from ABAP

**Level:** 201 · working knowledge

**One line:** Open SQL is SQL that runs on any supported database and speaks ABAP's types, and the three things that separate working code from good code are the `@` escaping every host variable, doing the joining and aggregating on the database rather than in a loop, and never issuing a `SELECT` inside a `LOOP`.

## The modern syntax, and the `@`

```abap
SELECT carrid, connid, fldate
  FROM sflight
  WHERE carrid = @p_carr
  ORDER BY fldate DESCENDING
  INTO TABLE @DATA(lt_flights)
  UP TO 10 ROWS.
```

Since 7.40 SP05 the column list is comma-separated and every **ABAP** variable is prefixed with `@` — the escape that tells the compiler "this name is mine, not the database's". In the strict syntax it is mandatory, and it is also the fastest way to tell modern ABAP from old ABAP at a glance. `INTO TABLE @DATA(lt)` declares the target table from the column list, so the structure cannot drift from the query.

The old syntax — `SELECT * FROM sflight INTO TABLE lt_flights WHERE carrid = p_carr.` — still compiles on an on-premise system. It is worth reading fluently and not worth writing.

## `SELECT SINGLE` needs the full key

`SELECT SINGLE` returns one row and does not say which one if the `WHERE` does not identify it. With a full primary key it is exact; without one it is a coin toss that happens to be stable in test and not in production. And on a miss, the target keeps its previous contents — `sy-subrc` is the only report, so check it.

## Let the database do the work

```abap
SELECT f~carrid, c~carrname, SUM( f~seatsocc ) AS occupied
  FROM sflight AS f
  INNER JOIN scarr AS c ON c~carrid = f~carrid
  GROUP BY f~carrid, c~carrname
  INTO TABLE @DATA(lt_totals).
```

A join and an aggregate replace a second `SELECT` and a loop. Every non-aggregated column of the result must appear in `GROUP BY`; a condition **on** an aggregate is `HAVING`, not `WHERE`. An outer join keeps unmatched left rows and fills the right-hand columns with initial values — which afterwards look exactly like real zeroes, so the query has to be read with that in mind.

## The two rules that decide performance

**Never `SELECT` inside a `LOOP`.** One round trip per row is the single most common performance defect in ABAP. Read the set once, then look up in memory with a sorted or hashed table.

**`FOR ALL ENTRIES` has two silent traps.** An **empty** driver table does not select nothing — it drops the condition and selects everything. And the result is de-duplicated on the selected columns, so rows vanish unless the key is in the field list. Guard the first with `IF lt_driver IS NOT INITIAL`, and the second by selecting the key.

Both are worked through on [Open SQL](../../03_Topics/open_sql/README.md), with [Performance](../../03_Topics/performance/README.md) for the measuring.

## What `SELECT` will not check

Open SQL does **not** apply authorization checks. The database will hand over any row the query asks for, whatever the user is allowed to see. The [`AUTHORITY-CHECK`](../authority_check/README.md) is yours to write — or the CDS view's to declare, which is one of the reasons [CDS views](../../03_Topics/cds_views/README.md) exist.

<!-- snippet:z_kw_select -->
*[`z_kw_select.prog.abap`](snippets/z_kw_select.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_select.

" The flight demo tables ship with most training and sandbox systems. Swap them
" for your own; the shape of each statement is the point.
PARAMETERS p_carr TYPE scarr-carrid DEFAULT 'LH'.

START-OF-SELECTION.

  " One row, named columns. SINGLE without a full key is a coin toss, so give
  " it the key -- and check sy-subrc, because a miss leaves the target initial.
  SELECT SINGLE carrid, carrname
    FROM scarr
    WHERE carrid = @p_carr
    INTO @DATA(ls_carrier).
  IF sy-subrc = 0.
    WRITE: / 'carrier', ls_carrier-carrname.
  ENDIF.

  " Many rows, straight into an internal table the compiler declares for you.
  SELECT carrid, connid, fldate, seatsocc
    FROM sflight
    WHERE carrid = @p_carr
    ORDER BY fldate DESCENDING
    INTO TABLE @DATA(lt_flights)
    UP TO 10 ROWS.
  WRITE: / 'flights', lines( lt_flights ).

  " A join and an aggregate: work the database is built for, and a loop in ABAP
  " is not. Every non-aggregated column has to appear in GROUP BY.
  SELECT f~carrid, c~carrname, SUM( f~seatsocc ) AS occupied
    FROM sflight AS f
    INNER JOIN scarr AS c ON c~carrid = f~carrid
    WHERE f~carrid = @p_carr
    GROUP BY f~carrid, c~carrname
    INTO TABLE @DATA(lt_totals).

  LOOP AT lt_totals INTO DATA(ls_total).
    WRITE: / ls_total-carrname, ls_total-occupied.
  ENDLOOP.

  " Reading inside a loop is the classic performance bug. Read once, then look
  " up in memory -- a sorted or hashed table makes the lookup cheap.
  SELECT carrid, carrname
    FROM scarr
    INTO TABLE @DATA(lt_names).
  LOOP AT lt_flights INTO DATA(ls_flight).
    DATA(ls_name) = VALUE #( lt_names[ carrid = ls_flight-carrid ] OPTIONAL ).
    WRITE: / ls_flight-fldate, ls_name-carrname.
  ENDLOOP.
```
<!-- /snippet -->

## If you are coming from another language

- **SQL you already know.** Most of it transfers. The differences worth knowing: `~` instead of `.` for table aliases in the classic syntax, client handling is automatic (`MANDT` is added for you), and `INTO` is part of the statement rather than a cursor API.
- **Python / Java.** There is no ORM here and no connection to manage. The statement *is* the API, the result is a typed internal table, and there is no object-relational mapping layer to fight.

## See also

- [Open SQL](../../03_Topics/open_sql/README.md) — joins, aggregates, `FOR ALL ENTRIES`, and what belongs on the database
- [Internal tables](../../03_Topics/internal_tables/README.md) — where the result lands, and how to read it afterwards
- [CDS views](../../03_Topics/cds_views/README.md) — the same query, defined once and reused
- [`COMMIT WORK`](../commit_work/README.md) — the other half of talking to the database
- [`AUTHORITY-CHECK`](../authority_check/README.md) — the check `SELECT` does not do
- [Database writes](../db_writes/README.md) — `INSERT`, `UPDATE`, `MODIFY`, `DELETE` on a table, and `sy-dbcnt`
- [`WITH`](../with_cte/README.md) — common table expressions in Open SQL (7.51)
- [Cursors](../open_cursor_fetch/README.md) — `OPEN CURSOR`, `FETCH`, `SELECT … ENDSELECT` for sets too big to hold
- [Native SQL statements](../exec_sql/README.md) — `EXEC SQL` and ADBC
- [HANA specifics](../../03_Topics/hana_specifics/README.md) — what changes on a column store
