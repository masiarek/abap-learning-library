# Forms and printing — SAPscript, Smart Forms, Adobe Forms, spool

**Level:** 201 · working knowledge

**Status:** stub — the map is here; the worked example is not yet.

**One line:** Printed output — invoices, order confirmations, delivery notes — comes from one of three form technologies layered over twenty years (SAPscript, Smart Forms, Adobe Forms), each with its own designer and its own way of being called from ABAP, and all of them ending in the spool (`SP01`), where the document waits for a printer or a PDF.

## The three, and how each is called

| Technology | Era | Designed in | Called by |
|---|---|---|---|
| SAPscript | R/3 | `SE71` | `OPEN_FORM`, `WRITE_FORM`, `CLOSE_FORM` |
| Smart Forms | 4.6C | `SMARTFORMS` | a generated function module, found via `SSF_FUNCTION_MODULE_NAME` |
| Adobe Forms (Interactive Forms) | NetWeaver 7.0 | `SFP` (Adobe LiveCycle Designer) | `FP_JOB_OPEN`, the generated function module, `FP_JOB_CLOSE`; needs ADS |
| Fiori / OData-based output | S/4HANA | Output Management, `BRF+` rules | the framework |

Output control — *which* form for *which* document, on *which* printer, *when* — is configuration (`NACE`, output determination) rather than code, which is why "the invoice did not print" is usually a customizing question before it is an ABAP one.

## Why it earns a page

Because a form's data comes from an ABAP print program, which is a report shaped by the form's interface: read the document, fill the interface structures, call the form. Enhancing a standard form usually means enhancing that program. And because Adobe Forms need the Adobe Document Services (ADS) Java stack, which is the first thing to check when an Adobe form fails and a Smart Form does not.

## What this page still needs

- [ ] a Smart Form and its print program, minimal, with the generated function module call
- [ ] the spool: `SP01`, `SPAD`, and converting a spool to PDF (`CONVERT_OTFSPOOLJOB_2_PDF`)
- [ ] `NACE` output determination in enough detail to find why nothing printed

## See also

- [Text elements and translation](../text_elements_and_translation/README.md) — the texts on the form
- [Background jobs](../background_jobs/README.md) — where the spool goes
- [Email from ABAP](../email_from_abap/README.md) — sending the PDF instead of printing it
- [`CALL FUNCTION`](../../02_Keywords/call_function/README.md) — the generated modules
