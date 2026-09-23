# SAP Business Workflow — tasks, agents and the business object behind them

**Level:** 301 · deep dive

**Status:** stub — the vocabulary is here; the worked example is not yet.

**One line:** Workflow routes a business object through steps — approve, release, complete — to **agents** found by rule, with each step a task bound to a method of a business object (BOR or ABAP class), and the ABAP developer's share is the object methods, the events that start a workflow, and the agent-determination rules.

## The vocabulary

| Term | Is |
|---|---|
| Workflow template (`WS…`) | the flow: steps, conditions, loops, deadlines (`SWDD`) |
| Task (`TS…`) | one step, bound to an object method; standard or single |
| Business object | BOR type (`SWO1`) or an ABAP class implementing `IF_WORKFLOW` |
| Event | what starts or continues a workflow; raised by the application or by `SWE_EVENT_CREATE` |
| Agent | who gets the work item; found by rule (`PFAC`), org unit, or expression |
| Work item | one instance of a task in someone's inbox (`SBWP`, Fiori My Inbox) |
| Container | the data passed between steps |
| Flexible workflow | the S/4HANA successor: scenario-based, configured in Fiori, fewer templates |

Monitoring: `SWI1` (work items), `SWI2_*` (selection reports), `SWEL` (event trace, switched on with `SWELS`), `SWU3` (basic customizing check — the first thing to run when nothing starts).

## The developer's part

Raising the **event** at the right moment inside the application (or configuring change documents / status changes to raise it), implementing the **methods** the tasks call, and writing the **rule** that finds the approver. Everything else is a modeler's job in `SWDD`, and the boundary between the two is where most workflow projects go wrong.

## What this page still needs

- [ ] an ABAP class implementing `IF_WORKFLOW` with one event and one method, bound to a task
- [ ] the event trace of one workflow start, recorded
- [ ] flexible workflow beside the classic template, with what a developer still has to write

## See also

- [Events](../../02_Keywords/events/README.md) — object events, the ABAP-level cousin
- [Web Dynpro and legacy UI](../web_dynpro_and_legacy_ui/README.md) — where much workflow UI lives
- [BAPIs and RFC](../bapis_and_rfc/README.md) — BOR methods are often BAPIs
- [Change documents](../change_documents/README.md) — one way an event gets raised
