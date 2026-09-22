# Dates and times — eight characters you can subtract

**Level:** 201 · working knowledge

**One line:** `TYPE d` is a `CHAR(8)` holding `YYYYMMDD` and arithmetic on it counts **days**, `TYPE t` is a `CHAR(6)` holding `HHMMSS` counting seconds, both can hold values that are not dates at all, and the moment a time zone is involved neither of them is enough.

## Dates are text you can do arithmetic on

```abap
DATA(lv_today) = sy-datum.
DATA(lv_in_30) = CONV d( lv_today + 30 ).
DATA(lv_days)  = lv_in_30 - lv_today.       " 30
```

Adding to a date adds days, and subtracting two dates gives days — month ends, leap years and all. That is genuinely convenient and it is also the source of the type's weakness: the underlying storage is characters, so `lv_date = '20261332'` is accepted and only fails later, somewhere else.

Offsets work for the same reason: `lv_today(4)` is the year, `lv_today+4(2)` the month. Reaching for them is normal ABAP; the alternative is a conversion function, not a nicer accessor.

The initial value of a date is `'00000000'` — not a null, because ABAP has none. Test with `IS INITIAL`, not against a literal, and be aware that a "no end date" convention in SAP data is usually `'99991231'` rather than an initial value.

## `sy-datum` is a *local* date

`sy-datum` and `sy-uzeit` are the application server's date and time **in the user's time zone**. Two users in different zones running the same report at the same moment can get different dates, and a job running at 23:00 in one system posts to a different day than the same job in another.

A timestamp is the unambiguous type: `TIMESTAMP` (`P` of 14 digits, `YYYYMMDDHHMMSS`) or `TIMESTAMPL` with fractional seconds, both in UTC.

```abap
GET TIME STAMP FIELD DATA(lv_stamp).
CONVERT TIME STAMP lv_stamp TIME ZONE sy-zonlo
        INTO DATE DATA(lv_date) TIME DATA(lv_time).
```

The zone has to be named to get back to a date, and *which* zone is a business decision: the user's, the plant's, the company code's, or UTC. Getting it wrong is a whole class of month-end bug that only appears near midnight.

## The factory calendar exists for a reason

"Thirty days from now" is arithmetic. "Thirty **working** days from now" is not: it needs the factory calendar, which knows the holidays for a plant and a country. `FIMA_DATE_CREATE`, `DATE_CONVERT_TO_FACTORYDATE` and the `CL_SCAL_*` classes are the usual doors. Anything that computes a due date, a payment term or a delivery date and does not mention a calendar is almost certainly wrong somewhere.

<!-- snippet:z_tp_dates -->
*[`z_tp_dates.prog.abap`](snippets/z_tp_dates.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_tp_dates.

" TYPE d is eight characters, YYYYMMDD, and arithmetic on it counts DAYS.
DATA(lv_today) = sy-datum.
DATA(lv_in_30) = CONV d( lv_today + 30 ).
DATA(lv_days)  = lv_in_30 - lv_today.

WRITE: / 'today     ', lv_today.
WRITE: / 'in 30 days', lv_in_30.
WRITE: / 'difference', lv_days.

" Offsets work because the type is really a character field. This is also why
" a date can hold nonsense: nothing stops you writing '20261332' into it.
WRITE: / 'year      ', lv_today(4).
WRITE: / 'month     ', lv_today+4(2).
WRITE: / 'day       ', lv_today+6(2).

" sy-datum is the application server's date in the user's time zone; a
" timestamp is the unambiguous one, and it needs a zone to become a date again.
GET TIME STAMP FIELD DATA(lv_stamp).
CONVERT TIME STAMP lv_stamp TIME ZONE sy-zonlo
        INTO DATE DATA(lv_local_date) TIME DATA(lv_local_time).
WRITE: / 'stamp     ', lv_stamp.
WRITE: / 'local date', lv_local_date.
WRITE: / 'local time', lv_local_time.

" The initial value of a date is '00000000' -- not a null, and not a date. Test
" for it with IS INITIAL rather than comparing to a literal.
DATA lv_empty TYPE d.
IF lv_empty IS INITIAL.
  WRITE: / 'an unset date is initial, not null'.
ENDIF.
```
<!-- /snippet -->

## If you are coming from another language

- **Python.** `datetime.date` refuses to hold `2026-13-32`; ABAP's `d` accepts it. Python's `timedelta` is ABAP's plain integer arithmetic.
- **Java.** `LocalDate` versus `Instant` is exactly ABAP's `d` versus `TIMESTAMP`, including the rule that the second one needs a zone to become the first.
- **SQL.** A `DATE` column is validated by the database; ABAP's type is not, which is why invalid dates survive in tables that have been through an old interface.

## See also

- [Numbers and currency](../numbers_and_currency/README.md) — the other family of types with hidden conventions
- [Open SQL](../open_sql/README.md) — date ranges in a `WHERE`, and `SELECT-OPTIONS`
- [Background jobs](../background_jobs/README.md) — where "today" is decided by the server, not the user
- [`PARAMETERS` and `SELECT-OPTIONS`](../../02_Keywords/parameters_select_options/README.md) — date ranges on a selection screen
