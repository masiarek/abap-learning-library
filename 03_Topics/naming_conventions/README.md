# Naming conventions — `Z`, `Y`, namespaces and prefixes

**Level:** 101 · newcomer

**Status:** stub — the rules are here; the argument is on the Clean ABAP page.

**One line:** Customer objects start with `Z` or `Y` (or live in a registered `/NAMESPACE/`), which keeps them out of SAP's way on upgrade; inside the code, the classic prefixes encode scope and kind (`lv_`, `lt_`, `ls_`, `lo_`, `gv_`, `mv_`, `iv_`…), Clean ABAP argues against most of them, and the only wrong choice is inconsistency with the code around you.

## The repository level

| Convention | Rule |
|---|---|
| `Z*`, `Y*` | the customer namespace for every repository object: programs, classes, tables, function groups, message classes… |
| `/ABC/*` | a registered namespace, for partners and for customers who want one; needs a namespace key |
| `SAP*`, everything else | SAP's; changing it is a modification |
| Local classes `LCL_*`, `LTCL_*` (tests), interfaces `LIF_*` | local to one program; abaplint's `errorNamespace` in this repository follows the same pattern |
| Packages `Z…` with a structure (`ZFIN`, `ZFIN_AR`…) | decides the transport layer, and makes the where-used list useful |

An object outside the customer namespace in a customer system is created only with an object key (`SSCR`) — deliberately painful.

## Inside the code

| Prefix | Means | Example |
|---|---|---|
| `lv_`, `gv_`, `mv_`, `sv_` | local / global / member / static variable | `lv_total` |
| `lt_`, `ls_`, `lr_`, `lo_` | table / structure / data reference / object reference | `lt_rows`, `lo_alv` |
| `iv_`, `ev_`, `cv_`, `rv_` | importing / exporting / changing / returning parameter; `it_`, `et_`… for tables | `iv_bukrs`, `rt_result` |
| `ty_`, `ts_`, `tt_` | type, structure type, table type | `ty_row` |
| `gc_`, `lc_` | constant | `gc_status` |
| `<ls_>`, `<lv_>` | field symbols, same shapes | `<ls_row>` |
| `p_`, `s_` | parameter, select-option on a selection screen | `p_bukrs`, `s_date` |

Clean ABAP's position: the compiler knows the type, so `total` beats `lv_total`. Most existing code disagrees, at scale. The rule that survives contact: **match the file you are in**, and settle the convention per project, once, in writing.

## What this page still needs

- [ ] the namespace registration steps, once
- [ ] a real project convention document, anonymised, as an example of "settled once"

## See also

- [Clean ABAP](../clean_abap/README.md) — the argument against prefixes
- [Packages and namespaces](../packages_and_namespaces/README.md) — the package side
- [`DATA` — and `DATA( )`](../../02_Keywords/data/README.md) — naming, briefly, on the keyword page
- [Transports](../transports/README.md) — why the package matters
