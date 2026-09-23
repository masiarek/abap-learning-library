# `PARAMETERS` and `SELECT-OPTIONS` — the free selection screen

**Level:** 101 · newcomer

**Status:** stub — the shape is here; the worked program is not yet.

**One line:** `PARAMETERS` puts one input field on a report's selection screen and `SELECT-OPTIONS` puts a whole range widget there — and what `SELECT-OPTIONS` actually gives you is an internal table of `SIGN`/`OPTION`/`LOW`/`HIGH` rows that Open SQL understands directly through `IN`.

## What it does

```abap
PARAMETERS     p_carr TYPE scarr-carrid DEFAULT 'LH' OBLIGATORY.
SELECT-OPTIONS s_date FOR sflight-fldate.

SELECT * FROM sflight
  WHERE carrid = @p_carr AND fldate IN @s_date
  INTO TABLE @DATA(lt_flights).
```

Declaring the parameter is the whole UI: field, label, F4 help, type check, and an entry in the user's saved variants — all from the DDIC type it refers to. There is no screen to paint.

A `SELECT-OPTIONS` table is a **ranges table**: each row has `SIGN` (`I`/`E`), `OPTION` (`EQ`, `BT`, `GT`, `CP`…), `LOW` and `HIGH`. An **empty** ranges table in an `IN` condition means *no restriction* — the same shape as the [`FOR ALL ENTRIES`](../../03_Topics/open_sql/README.md) trap, and worth the same guard when the emptiness is unexpected.

## The events around it

`INITIALIZATION` sets defaults before the screen appears, `AT SELECTION-SCREEN` validates after input, `AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_x` supplies a custom F4, and `START-OF-SELECTION` is where the actual work starts. Validation in the wrong event produces a report that rejects input the user cannot correct.

## What this page still needs

- [ ] a `snippets/` program building a ranges table by hand and using it in `IN`
- [ ] `SELECTION-SCREEN BEGIN OF BLOCK`, and the text elements that give labels
- [ ] the full event order, recorded from a real run
- [ ] `OBLIGATORY`, `NO-DISPLAY`, `AS CHECKBOX`, `RADIOBUTTON GROUP`

## See also

- [Selection screens](../../03_Topics/selection_screens/README.md) — the topic page
- [`SELECT`](../select/README.md) — where the parameters end up
- [`WRITE`](../write/README.md) — the list the report produces
- [ALV](../../03_Topics/alv/README.md) — what to show instead of a list
- [Ranges tables](../ranges/README.md) — `TYPE RANGE OF`, and the empty table that means everything
- [Report events](../report_events/README.md) — the blocks a report is made of, in order
- [`SUBMIT`](../submit/README.md) — running another report
