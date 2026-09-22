# RAP — the RESTful Application Programming model

**Level:** 301 · deep dive

**Status:** stub — the vocabulary is here; the worked example is not yet.

**One line:** RAP is SAP's current way to build a transactional application: [CDS views](../cds_views/README.md) define the model, a **behaviour definition** declares what may be created, updated and deleted along with validations and actions, and a generated OData service exposes it to Fiori — with the framework, not your code, owning the transaction.

## The vocabulary

| Term | Is |
|---|---|
| Interface view (`ZI_…`) | the model over the tables |
| Projection view (`ZC_…`) | the consumption-facing subset, with UI annotations |
| Behaviour definition (`.bdef`) | what is allowed: `create`, `update`, `delete`, `action`, `validation`, `determination`, `draft` |
| Behaviour implementation (`zbp_…`) | the ABAP class behind those declarations |
| Service definition / binding | which entities are exposed, and as what (OData V2/V4) |

Two flavours: **managed**, where the framework handles persistence, and **unmanaged**, where you wrap existing logic — typically a legacy function module that must keep being the single writer.

The mental shift is the transaction. In a classic program you decide when to [`COMMIT WORK`](../../02_Keywords/commit_work/README.md); in RAP the framework runs a transactional buffer, calls your determinations and validations at defined points, and saves. Code that commits on its own inside that cycle is a bug with a wide blast radius.

## What this page still needs

- [ ] a complete managed scenario, from CDS through behaviour definition to a running service
- [ ] the RAP phases — interaction, save sequence — with what may be done in each
- [ ] draft handling, and why it is not optional for most Fiori use cases
- [ ] how ABAP Unit tests a behaviour implementation
- [ ] a straight comparison with BOPF for people maintaining one

## See also

- [CDS views](../cds_views/README.md) — the layer RAP is built on
- [LUW and locking](../luw_and_locking/README.md) — the transaction model RAP takes over
- [ABAP Cloud](../abap_cloud/README.md) — the environment RAP assumes
- [Object-oriented ABAP](../oo_abap/README.md) — the behaviour implementation is a class like any other
