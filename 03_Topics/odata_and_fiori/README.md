# OData, SAP Gateway and Fiori — how ABAP reaches a browser

**Level:** 201 · working knowledge

**Status:** stub — the map is here; the worked example is not yet.

**One line:** A Fiori app talks OData; SAP Gateway turns an ABAP implementation into an OData service — hand-written in `SEGW` for classic development, generated from CDS annotations and a RAP service binding for new development — and the annotations on the CDS view are what make a Fiori Elements app appear without UI code.

## The two paths

| | Classic Gateway (`SEGW`) | RAP |
|---|---|---|
| Model | defined in the project, or imported from DDIC/CDS | the CDS view |
| Implementation | `…_DPC_EXT` class: `GET_ENTITYSET`, `CREATE_ENTITY`… | behaviour definition and implementation |
| Transaction | yours to manage in the DPC methods | the framework's |
| Service registration | `/IWFND/MAINT_SERVICE` | service definition + binding, published from ADT |
| OData version | V2 | V2 or V4 |
| Fiori Elements | with annotations from the MPC or CDS | from CDS `@UI` annotations |

The Gateway itself can be *embedded* (same system) or a *hub* (a separate system fronting several back ends), which decides where the service is registered and where the ICF node lives.

## Why it earns a page

Because OData is the boundary where the [JSON casing](../json_and_xml/README.md) rules, the [initial-versus-null](../initial_values_and_null/README.md) rules and the [authorization](../authorizations/README.md) rules all bite at once — and because `$filter`, `$expand`, `$top` and `$skip` are what the `GET_ENTITYSET` implementation has to honour by hand in the classic path and gets free in RAP. Testing goes through `/IWFND/GW_CLIENT`, which is the tool to learn first.

## What this page still needs

- [ ] a `SEGW` service with one entity set, read-only, tested in the Gateway client
- [ ] the same entity through a RAP service binding, for comparison
- [ ] `@UI` annotations on a CDS view and the Fiori Elements list they produce
- [ ] the error log (`/IWFND/ERROR_LOG`) and the first three things it usually says

## See also

- [RAP](../rap/README.md) — the modern path
- [CDS views](../cds_views/README.md) — the model, and the annotations
- [JSON and XML](../json_and_xml/README.md) — the payload
- [HTTP client](../http_client/README.md) — the other direction: ABAP calling out
- [Web Dynpro and legacy UI](../web_dynpro_and_legacy_ui/README.md) — what came before
