# `WRITE` — list output

**Level:** 101 · newcomer

**Status:** stub — the shape is here; the worked program is not yet.

**One line:** `WRITE` puts text on a classical list — still the fastest way to see a number during development, still formatting things behind your back — and it is not a user interface: anything a user will look at belongs in [ALV](../../03_Topics/alv/README.md).

## What it does

```abap
WRITE: / 'label', lv_value.
WRITE: /(20) lv_text, lv_amount CURRENCY 'USD', lv_date DD/MM/YYYY.
WRITE: / lv_number NO-ZERO LEFT-JUSTIFIED.
```

The `/` starts a new line; `(20)` sets a width; the additions after a field format it. Two behaviours surprise everyone at least once:

- **Numbers are right-justified and padded**, and a negative number's sign goes on the **right** — `42-`, not `-42`. That is the classic list convention, not a bug.
- **A field is written with its DDIC output length and conversion routine**, so a value can appear on the list in a form it does not have in memory. An amount stored with two decimals may print with three, or none, depending on the currency.

`WRITE … TO lv_target` is a different statement that formats into a variable and does not touch the list. In modern code, [string templates](../string_templates/README.md) do that better.

## Where it still belongs

A quick check during development, a debugging line, a background job's log, a throwaway one-off report. For anything with a reader, `cl_salv_table` gives sorting, filtering, totals and Excel export for about five lines of code, and does not need a screen painted. See [ALV](../../03_Topics/alv/README.md).

## What this page still needs

- [ ] a `snippets/` program with the formatting additions, and a recorded run showing the sign placement
- [ ] `WRITE` against `cl_demo_output` and against `cl_salv_table`, side by side
- [ ] what happens to `WRITE` output in a background job, and where to find it

## See also

- [ALV](../../03_Topics/alv/README.md) — what to use when someone is reading
- [String templates](../string_templates/README.md) — formatting into a variable instead
- [`PARAMETERS` and `SELECT-OPTIONS`](../parameters_select_options/README.md) — the screen in front of the list
- [Background jobs](../../03_Topics/background_jobs/README.md) — where the list goes when nobody is watching
- [Classic reports](../../03_Topics/classic_reports/README.md) — lists, pages, `HIDE` and `AT LINE-SELECTION`
- [Report events](../report_events/README.md) — the blocks a report is made of, in order
