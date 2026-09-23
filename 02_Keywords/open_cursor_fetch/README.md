# `OPEN CURSOR`, `FETCH`, `SELECT … ENDSELECT` — reading in pieces

**Level:** 301 · deep dive

**Status:** stub — the shapes are here; the worked program is not yet.

**One line:** When a result set is too large to hold, `SELECT … ENDSELECT` loops over an open cursor one row at a time and `OPEN CURSOR … FETCH NEXT CURSOR … PACKAGE SIZE n` reads it in packages — both keep a database cursor open across the loop body, which is why a `COMMIT WORK` inside the loop closes it and the loop ends early.

## The shapes

```abap
SELECT carrid, connid FROM sflight INTO @DATA(ls_f).   " one row per pass
  " ...
ENDSELECT.

SELECT … INTO TABLE @DATA(lt_pkg) PACKAGE SIZE 1000.   " 1000 rows per pass
  " process lt_pkg
ENDSELECT.

OPEN CURSOR WITH HOLD @DATA(lv_cursor) FOR SELECT … .
DO.
  FETCH NEXT CURSOR @lv_cursor INTO TABLE @lt_pkg PACKAGE SIZE 1000.
  IF sy-subrc <> 0. EXIT. ENDIF.
  " process lt_pkg, COMMIT WORK allowed because of WITH HOLD
ENDDO.
CLOSE CURSOR @lv_cursor.
```

`WITH HOLD` is the difference between the two: an explicit cursor opened with it survives a commit; an implicit `SELECT … ENDSELECT` cursor does not.

## Why it earns a page

The archiving job, the mass update, the extract of a fifty-million-row table — anything where `INTO TABLE` would exhaust memory — needs this, and the commit rule catches everyone once: a `SELECT … ENDSELECT` that posts and commits per row processes exactly one row and reports success. `PACKAGE SIZE` with a commit after each package, on a `WITH HOLD` cursor, is the pattern.

`SELECT … ENDSELECT` is otherwise the slow form: one round trip per row when the whole set would fit in memory. Use it for size, not by habit.

## What this page still needs

- [ ] a `snippets/` program with all three forms
- [ ] the early-exit-on-commit behaviour recorded against a real database
- [ ] `PACKAGE SIZE` with a `FOR ALL ENTRIES`, and the interaction that surprises people

## See also

- [`SELECT`](../select/README.md) — the set-based form to prefer
- [`COMMIT WORK`](../commit_work/README.md) — what closes the cursor
- [Open SQL](../../03_Topics/open_sql/README.md) — the topic page
- [Background jobs](../../03_Topics/background_jobs/README.md) — where the big reads live
