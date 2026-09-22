# ALV — the grid you get for nothing

**Level:** 201 · working knowledge

**Status:** stub — the recommendation is here; the worked example is not yet.

**One line:** The ABAP List Viewer turns an internal table into a grid with sorting, filtering, totals, layouts and Excel export in a handful of lines — and `cl_salv_table` is the one to learn, not the older `REUSE_ALV_GRID_DISPLAY` that most existing code uses.

## The short version

```abap
cl_salv_table=>factory( IMPORTING r_salv_table = DATA(lo_alv)
                        CHANGING  t_table      = lt_rows ).
lo_alv->display( ).
```

Four lines, and the user gets column sorting, filtering, a layout they can save, a total row if you ask for one, and export to a spreadsheet. Compare with [`WRITE`](../../02_Keywords/write/README.md), which gives a list nobody can sort.

The column metadata — headings, widths, currency handling — comes from the [Dictionary](../ddic_and_domains/README.md) types of the table's fields, which is one more reason for a DDIC-typed structure rather than a local one.

## The three generations, because you will meet all of them

| API | Status |
|---|---|
| `REUSE_ALV_GRID_DISPLAY` and friends | function modules, everywhere in old code, still working |
| `cl_gui_alv_grid` | the control, for screens with more than a grid on them |
| `cl_salv_table` | the object-oriented wrapper to use for new work |

`cl_salv_table` covers most reporting needs and deliberately hides the control's complexity; when you need editable cells or fine-grained events, you are back to `cl_gui_alv_grid`, which is worth knowing before choosing.

## What this page still needs

- [ ] a `snippets/` program with `cl_salv_table`, columns, totals and a hotspot event
- [ ] the same report with `REUSE_ALV_GRID_DISPLAY`, for reading old code
- [ ] field catalogue building when the structure is dynamic
- [ ] what ALV does in a background job, recorded

## See also

- [`WRITE`](../../02_Keywords/write/README.md) — the list ALV replaces
- [Selection screens](../selection_screens/README.md) — what comes before the grid
- [Internal tables](../internal_tables/README.md) — what ALV is displaying
- [DDIC, domains and data elements](../ddic_and_domains/README.md) — where the column headings come from
