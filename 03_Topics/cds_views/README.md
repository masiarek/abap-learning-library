# CDS views — the data model as source code

**Level:** 201 · working knowledge

**Status:** stub — the shape is here; the worked example is not yet.

**One line:** A Core Data Services view is a SQL view defined in a text file, versioned and transported like a program, that can carry annotations, associations, authorization rules and units — so the model, its metadata and its access control live in one place instead of in every program that reads the tables.

## What it looks like

```sql
@AbapCatalog.sqlViewName: 'ZIFLIGHTS'
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flights with carrier'
define view ZI_Flights as select from sflight
  association [1..1] to scarr as _Carrier on $projection.carrid = _Carrier.carrid
{
  key carrid,
  key connid,
  key fldate,
      seatsocc,
      _Carrier.carrname
}
```

The annotations are the point. `@AccessControl` ties the view to a DCL role so the authorization check travels with the model; `@Analytics`, `@UI` and `@OData` drive Fiori and analytics without code; `@Semantics` tells consumers which field is an amount and which field holds its currency.

Associations are joins that are only executed when the consumer actually asks for the associated fields — which is the substantive difference from a classic DDIC view, not just nicer syntax.

## Why it matters even in a report

A CDS view is consumed from Open SQL like a table: `SELECT … FROM zi_flights`. So a join written once as a view is a join not repeated in eleven programs — and when the model changes, it changes in one place. That is the same argument as any other kind of reuse, with the difference that the database, not ABAP, executes it.

## What this page still needs

- [ ] a full worked view with an association, consumed from ABAP, with the generated SQL
- [ ] the annotation families, each with what it actually causes to happen
- [ ] DCL: an access-control role, and how it composes with [`AUTHORITY-CHECK`](../../02_Keywords/authority_check/README.md)
- [ ] the naming conventions (`ZI_`, `ZC_`, `ZR_`) and the VDM layers they signal
- [ ] where a CDS table function and [AMDP](../amdp_and_code_pushdown/README.md) take over

## See also

- [Open SQL](../open_sql/README.md) — how a view is consumed
- [AMDP and code pushdown](../amdp_and_code_pushdown/README.md) — when SQL is not enough
- [RAP](../rap/README.md) — where CDS views become the basis of a whole application
- [Authorizations](../authorizations/README.md) — the check declared instead of coded
- [DDIC, domains and data elements](../ddic_and_domains/README.md) — the layer underneath
