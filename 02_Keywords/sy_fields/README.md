# System fields — `sy-subrc`, `sy-tabix`, `sy-index` and friends

**Level:** 101 · newcomer

**One line:** `sy` is a structure the kernel keeps up to date — the current user, client, date, the last return code, the current loop row — and the three fields that cause bugs are `sy-subrc` (overwritten by the next statement that sets one), `sy-tabix` (the `LOOP AT` row) and `sy-index` (the `DO` pass), the last two of which are regularly confused.

## The ones you will read

| Field | Holds | Set by |
|---|---|---|
| `sy-subrc` | return code of the last statement that sets one; `0` is success | most statements |
| `sy-tabix` | current row index | `LOOP AT`, `READ TABLE` |
| `sy-index` | current pass number | `DO`, `WHILE` |
| `sy-dbcnt` | rows affected | Open SQL |
| `sy-datum`, `sy-uzeit` | date and time, user's zone, at program start | `GET TIME` refreshes |
| `sy-uname`, `sy-mandt`, `sy-langu` | user, client, logon language | logon |
| `sy-repid`, `sy-cprog` | this program; the calling program | runtime |
| `sy-batch` | `X` in a background job | runtime |
| `sy-msgid`, `sy-msgno`, `sy-msgty`, `sy-msgv1…4` | the last message, in pieces | `MESSAGE`, function modules |
| `sy-sysid`, `sy-host` | system ID, application server | runtime |
| `sy-fdpos` | offset of a `CS`/`CA` match | comparison operators |

`sy-uzeit` is worth a second look: it is set when the program starts and does **not** tick. A job that logs `sy-uzeit` after two hours of work logs the start time. See [`GET TIME`](../get_time/README.md).

## The rules

- **Read `sy-subrc` immediately.** A `WRITE`, a method call, a `SELECT` — nearly anything can reset it. Copy it into a variable when there is anything between the statement and the test.
- **Never assign to a `sy` field.** It compiles. It also lies to every statement that reads the field afterwards.
- **`sy-subrc = 0` after a statement that does not set it means nothing.** A `LOOP AT` sets it (`4` if the table was empty); an assignment does not.
- `sy-tabix` inside a nested `LOOP` belongs to the **inner** loop, and a `READ TABLE` inside the loop overwrites it too.

<!-- snippet:z_kw_sy_fields -->
*[`z_kw_sy_fields.prog.abap`](snippets/z_kw_sy_fields.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_sy_fields.

" The fields nearly every program reads. The kernel sets them; assign to one
" yourself and you are lying to the next statement that reads it.
WRITE: / 'user     ', sy-uname.
WRITE: / 'client   ', sy-mandt.
WRITE: / 'language ', sy-langu.
WRITE: / 'program  ', sy-repid.
WRITE: / 'system   ', sy-sysid.
WRITE: / 'date/time', sy-datum, sy-uzeit.
WRITE: / 'batch?   ', sy-batch.

TYPES ty_ints TYPE STANDARD TABLE OF i WITH EMPTY KEY.
DATA(lt_n) = VALUE ty_ints( ( 10 ) ( 20 ) ( 30 ) ).

" sy-tabix: the row index inside LOOP AT, and after a READ TABLE.
LOOP AT lt_n INTO DATA(lv_n).
  WRITE: / 'tabix', sy-tabix, lv_n.
ENDLOOP.

" sy-index: the pass counter of DO and WHILE. A different field, and the
" one people read in a LOOP by mistake.
DO 2 TIMES.
  WRITE: / 'index', sy-index.
ENDDO.

" sy-subrc: the return code of the LAST statement that sets one. Copy it
" straight away -- almost any statement in between can overwrite it.
READ TABLE lt_n INTO lv_n INDEX 99.
DATA(lv_rc) = sy-subrc.
WRITE: / 'read past the end ->', lv_rc.

" sy-dbcnt: rows affected by the last Open SQL statement.
SELECT carrid FROM scarr INTO TABLE @DATA(lt_carriers).
WRITE: / 'rows selected', sy-dbcnt, lines( lt_carriers ).

" sy-msg*: the last message, in pieces. See the MESSAGE page.
WRITE: / 'last message type [', sy-msgty, ']'.
```
<!-- /snippet -->

## If you are coming from another language

- **C.** `errno`, with the same "read it now" rule and the same silent overwriting — except that ABAP sets it on success as well.
- **Shell.** `$?` is `sy-subrc`; `$USER`, `$HOSTNAME` and `date` are the rest of the structure.

## See also

- [`READ TABLE` and table expressions](../read_table/README.md) — the statement most often followed by a forgotten `sy-subrc` check
- [`LOOP AT`](../loop_at/README.md) and [`DO` and `WHILE`](../do_while/README.md) — `sy-tabix` and `sy-index`, one each
- [`MESSAGE`](../message/README.md) — the `sy-msg…` fields
- [`GET TIME`](../get_time/README.md) — refreshing `sy-datum` and `sy-uzeit`
- [Background jobs](../../03_Topics/background_jobs/README.md) — `sy-batch`
