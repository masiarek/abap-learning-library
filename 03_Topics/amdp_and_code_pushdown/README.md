# AMDP and code pushdown — SQLScript inside an ABAP class

**Level:** 301 · deep dive

**Status:** stub — the shape and the caution are here; the worked example is not yet.

**One line:** An ABAP Managed Database Procedure is a method whose body is SQLScript, executed by HANA rather than by the application server — the last resort of code pushdown, after Open SQL and [CDS views](../cds_views/README.md), and the first thing to tie your code to one database.

## What it looks like

```abap
CLASS zcl_totals DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.
    CLASS-METHODS totals_by_carrier
      EXPORTING VALUE(et_totals) TYPE tt_totals.
ENDCLASS.

CLASS zcl_totals IMPLEMENTATION.
  METHOD totals_by_carrier BY DATABASE PROCEDURE FOR HDB
                           LANGUAGE SQLSCRIPT
                           USING sflight.
    et_totals = SELECT carrid, SUM( seatsocc ) AS occupied
                FROM sflight GROUP BY carrid;
  ENDMETHOD.
ENDCLASS.
```

`USING` lists every database object the method touches — get it wrong and activation fails. The method body is not ABAP: no ABAP debugger, no ABAP syntax check, and a different set of rules about types and nulls.

## The ladder, in order

1. **Open SQL** — portable, checked, optimised. Handles most of it.
2. **CDS view** — reusable, annotated, still portable.
3. **CDS table function + AMDP** — when the logic genuinely needs procedural SQL: iterative calculations, hierarchies, window functions not exposed elsewhere.

Going straight to step 3 buys a HANA-only implementation, code that the ATC checks less thoroughly, and a debugging story that involves a second tool. It is the right answer when the calculation is genuinely set-based and large; it is a poor answer for "this loop felt slow".

## What this page still needs

- [ ] a worked AMDP with a CDS table function in front of it, consumed from ABAP
- [ ] how to debug one, and what the ABAP debugger cannot show
- [ ] the null semantics difference between SQLScript and ABAP, which is where the bugs are
- [ ] a measured comparison against the same logic in Open SQL, on real volumes

## See also

- [Open SQL](../open_sql/README.md) — step one of the ladder, and usually enough
- [CDS views](../cds_views/README.md) — step two
- [Performance](../performance/README.md) — measure before climbing
- [ABAP Cloud](../abap_cloud/README.md) — what is allowed in the restricted model
