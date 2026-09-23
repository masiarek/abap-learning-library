# Open SQL — the database is not a file

**Level:** 201 · working knowledge

**One line:** Open SQL is SQL that runs on any database SAP supports and speaks ABAP's types — and nearly every performance problem in an ABAP system is one of three things: a `SELECT` inside a loop, joining or aggregating in ABAP instead of on the database, or `FOR ALL ENTRIES` used without its two guards.

## Push the work down

The database has indexes, statistics and a query optimiser. A `LOOP` in an application server has none of those, and every row it works on had to cross the network first. So:

- Join on the database, not with a second `SELECT` and a `READ TABLE`.
- Aggregate on the database — `SUM( )`, `COUNT( )`, `MAX( )`, `GROUP BY` — not with a `REDUCE` over a table you transferred.
- Filter on the database. A `DELETE itab WHERE …` after a `SELECT` is a `WHERE` clause that was left out.
- Sort on the database with `ORDER BY` when the order is what you need.

The counter-rule is real too: a huge aggregate over a table with no suitable index can hurt the database everyone else is sharing. "Push it down" is not "push everything down"; it is "do not transfer rows in order to discard them".

## `FOR ALL ENTRIES` — two silent traps

```abap
IF lt_driver IS NOT INITIAL.        " guard 1
  SELECT carrid, connid, fldate     " key included -- guard 2
    FROM sflight
    FOR ALL ENTRIES IN @lt_driver
    WHERE carrid = @lt_driver-carrid
    INTO TABLE @DATA(lt_flights).
ENDIF.
```

1. **An empty driver table selects everything.** The condition is dropped, not evaluated as false. On a large table in production this is the classic outage.
2. **The result is de-duplicated on the selected columns.** Rows that differ only in a column you did not select collapse into one. Select the key.

It is also not a join: the kernel splits it into several statements against the database. Where a real join is possible, the join is usually better.

## `SELECT SINGLE`, `UP TO n ROWS`, and the cursor

`SELECT SINGLE` without a full primary key returns *an* arbitrary row. `UP TO n ROWS` without `ORDER BY` returns *an* arbitrary n. Both are stable enough in test to look correct.

`SELECT … ENDSELECT` loops row by row over an open cursor — still useful for a table too large to hold in memory, and a mistake for anything else, because it keeps a cursor open across whatever the loop body does.

## Amounts, quantities and the client

Open SQL adds the client field to every access automatically; `CLIENT SPECIFIED` turns that off and is almost always a mistake. Currency amounts come back in database format — a `CURR` field's decimals depend on the currency, and displaying one without the shift is how an amount gains or loses a factor of a hundred. See [Numbers and currency](../numbers_and_currency/README.md).

<!-- snippet:z_tp_open_sql -->
*[`z_tp_open_sql.prog.abap`](snippets/z_tp_open_sql.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_tp_open_sql.

START-OF-SELECTION.

  SELECT carrid, connid, fldate, seatsocc
    FROM sflight
    INTO TABLE @DATA(lt_flights)
    UP TO 20 ROWS.

  " FOR ALL ENTRIES has two traps and both are silent.
  " 1) An EMPTY driver table does not select nothing -- it drops the WHERE
  "    condition and selects EVERYTHING. Guard it.
  " 2) The result is de-duplicated on the selected columns, so rows you expected
  "    can vanish unless the key is in the field list.
  IF lt_flights IS NOT INITIAL.
    SELECT carrid, carrname
      FROM scarr
      FOR ALL ENTRIES IN @lt_flights
      WHERE carrid = @lt_flights-carrid
      INTO TABLE @DATA(lt_carriers).
    WRITE: / 'carriers', lines( lt_carriers ).
  ENDIF.

  " Aggregates come back from the database; every non-aggregated column of the
  " result must be listed in GROUP BY, and a condition ON an aggregate is
  " HAVING, not WHERE.
  SELECT carrid, COUNT(*) AS flights, SUM( seatsocc ) AS occupied
    FROM sflight
    GROUP BY carrid
    HAVING SUM( seatsocc ) > 0
    ORDER BY carrid
    INTO TABLE @DATA(lt_totals).

  LOOP AT lt_totals INTO DATA(ls_total).
    WRITE: / ls_total-carrid, ls_total-flights, ls_total-occupied.
  ENDLOOP.

  " An outer join keeps the left rows that have no partner, and fills the right
  " side with initial values -- which look exactly like real zeroes later on.
  SELECT c~carrid, c~carrname, f~connid
    FROM scarr AS c
    LEFT OUTER JOIN sflight AS f ON f~carrid = c~carrid
    INTO TABLE @DATA(lt_left)
    UP TO 20 ROWS.
  WRITE: / 'left join rows', lines( lt_left ).
```
<!-- /snippet -->

## If you are coming from another language

- **SQL you already know.** The dialect is close to standard SQL, with `~` for aliases in the classic syntax and `@` escaping ABAP variables in the modern one. There is no explicit connection, cursor API or ORM.
- **Python / Java.** The nearest habit to unlearn is the ORM's lazy loading, which is exactly the `SELECT`-in-a-loop pattern this page warns about — here it is written out, and therefore visible in review.

## See also

- [`SELECT`](../../02_Keywords/select/README.md) — the statement in detail, with the `@`
- [CDS views](../cds_views/README.md) — defining the query once, in the data model
- [Performance](../performance/README.md) — measuring, and the SQL trace
- [Internal tables](../internal_tables/README.md) — where the rows land afterwards
- [`AUTHORITY-CHECK`](../../02_Keywords/authority_check/README.md) — the check the database does not do
- [Database writes](../../02_Keywords/db_writes/README.md) — `INSERT`, `UPDATE`, `MODIFY`, `DELETE` on a table, and `sy-dbcnt`
- [`WITH`](../../02_Keywords/with_cte/README.md) — common table expressions in Open SQL (7.51)
- [Cursors](../../02_Keywords/open_cursor_fetch/README.md) — `OPEN CURSOR`, `FETCH`, `SELECT … ENDSELECT` for sets too big to hold
- [Native SQL](../native_sql/README.md) — when Open SQL is not enough, and what it costs
- [HANA specifics](../hana_specifics/README.md) — what changes on a column store
- [Initial values and null](../initial_values_and_null/README.md) — ABAP has no null
