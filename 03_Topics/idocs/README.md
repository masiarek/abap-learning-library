# IDocs — asynchronous documents with a status trail

**Level:** 201 · working knowledge

**Status:** stub — the vocabulary is here; the worked example is not yet.

**One line:** An IDoc is a structured document that travels asynchronously between systems, stored in the database with a status history — so unlike an RFC call, a failed IDoc is still there tomorrow to be corrected and reprocessed, which is exactly why interfaces are built on it.

## The vocabulary

| Term | Is |
|---|---|
| Basic type / extension | the structure (`ORDERS05`, `INVOIC02`), and the customer-added fields |
| Segment | one record type within it, nested into a hierarchy |
| Message type | what the document means (`ORDERS`, `INVOIC`) |
| Partner profile (`WE20`) | who sends/receives it, and with which process code |
| Process code | the function module or method that actually posts it |
| Control record (`EDIDC`) | who, what, when, and the current status |
| Status | where it got to: 03/12/53 good, 51/26/29 stuck |

The transactions worth knowing on sight: `WE02`/`WE05` to look at them, `WE19` to test one, `WE20` for partner profiles, `WE57`/`WE42` for process codes, `BD87` to reprocess, `SM58` for the tRFC layer underneath.

## Why it still matters

Because the alternative to "the interface failed and nobody knows" is a document with a status. An IDoc that fails with status 51 carries its own error message, keeps its data, and can be edited and reposted — which is an operational property, not a technical one, and it is why IDocs outlived several generations of replacement.

The ABAP side of extending one is usually a BAdI or a customer function in the inbound process code. See [Enhancements and BAdIs](../enhancements_and_badis/README.md).

## What this page still needs

- [ ] an inbound process code implementation, from partner profile to posted document
- [ ] outbound: the change pointer mechanism (`BD50`…`BD64`), and when to use it
- [ ] the status codes that matter, with what each actually means operationally
- [ ] a recorded `WE19` test of one document

## See also

- [BAPIs and RFC](../bapis_and_rfc/README.md) — the synchronous alternative, and the tRFC underneath
- [Enhancements and BAdIs](../enhancements_and_badis/README.md) — where customer logic attaches
- [Background jobs](../background_jobs/README.md) — where inbound processing usually runs
- [`COMMIT WORK`](../../02_Keywords/commit_work/README.md) — the transaction boundary around a posting
