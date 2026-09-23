# Web Dynpro ABAP, BSP and the UIs in between

**Level:** 201 · working knowledge

**Status:** stub — for orientation; no worked example is planned.

**One line:** Between the classic dynpro and Fiori, SAP shipped two browser UI frameworks — Business Server Pages (BSP) and Web Dynpro ABAP (WDA) — and while neither is where new development goes, WDA underlies a great deal of shipped HR, procurement and workflow UI, and the Floorplan Manager (FPM) on top of it is what many "Web GUI" screens actually are.

## The lineage

| UI | Era | Model | Status |
|---|---|---|---|
| Dynpro (SAP GUI) | R/3 | screens and flow logic | maintained; the transactions |
| BSP | 6.20 | server pages, HTML with ABAP | legacy; CRM WebClient UI was built on it |
| Web Dynpro ABAP | 7.0 | components, views, contexts, MVC | maintained, no new features; much of it in use |
| Floorplan Manager | 7.0 EhP | configurable WDA applications | same |
| SAPUI5 / Fiori | 7.4 | OData + JavaScript client | current |

## What a maintainer needs to know

A WDA component has **views** (layout), a **context** (a tree of data nodes the UI binds to), **controllers** (component, view, window, custom), and **navigation** by plugs. The debugging entry point is the component controller's `WDDOINIT`; the data is in the context, not in variables; and an enhancement is done with the same enhancement framework as anywhere else. FPM adds configuration on top — a feeder class supplies data, and the layout is customized rather than coded.

Any of it can be run from a browser through the ICF, which is also where a "page not found" is diagnosed (`SICF`, node inactive).

## What this page still needs

- [ ] a WDA component's structure in one diagram
- [ ] the FPM feeder-class contract, since that is what gets enhanced
- [ ] `SICF` activation, once, with the error it fixes

## See also

- [Dynpro screens](../dynpro_screens/README.md) — the ancestor
- [OData, Gateway and Fiori](../odata_and_fiori/README.md) — the successor
- [Enhancements and BAdIs](../enhancements_and_badis/README.md) — how a WDA screen is changed
- [Workflow](../workflow/README.md) — where much WDA UI is used
