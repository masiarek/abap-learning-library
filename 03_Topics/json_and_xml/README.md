# JSON and XML — serialising ABAP data

**Level:** 201 · working knowledge

**Status:** stub — the tools are here; the worked example is not yet.

**One line:** ABAP serialises to XML and JSON with `CALL TRANSFORMATION` (including the built-in `id` transformation) and with `/ui2/cl_json` in most SAP systems — and the recurring surprise is **name casing**: ABAP component names are upper case, and the JSON everyone else expects is not.

## The tools

| Tool | Good for |
|---|---|
| `CALL TRANSFORMATION id SOURCE … RESULT XML …` | the built-in, lossless ABAP-to-XML form |
| A Simple Transformation (`STRANS`) | a specific XML shape you control, both directions |
| XSLT | transforming XML that is already not yours |
| `/ui2/cl_json=>serialize/deserialize` | pragmatic JSON, with a `pretty_name` option for casing |
| `cl_sxml_*` readers/writers | streaming, when the document is too big to hold |
| `xco_cp_json` (newer systems) | the released, cloud-ready option |

## The three recurring problems

- **Casing.** `MATERIAL_NUMBER` is not `materialNumber`. `/ui2/cl_json`'s `pretty_name = pretty_mode-camel_case` handles the common case; a mapping table handles the rest. Deserialising with the wrong casing silently produces empty fields, not an error.
- **Empty versus absent.** ABAP has no null, so a missing JSON field and one sent as `""` both arrive as an initial value. Where the difference matters, the payload needs an explicit flag.
- **Numbers and dates.** A packed amount becomes a JSON number and may lose its decimals; a `d` field is `"20260922"` unless something converts it to `"2026-09-22"`. Both are decisions to make deliberately at the boundary. See [Dates and times](../dates_and_times/README.md).

## What this page still needs

- [ ] a `snippets/` program round-tripping a nested structure through `/ui2/cl_json` and through `id`
- [ ] a Simple Transformation for a fixed schema, both directions
- [ ] what each tool does with an unknown field on deserialisation
- [ ] `xco_cp_json` as the cloud-ready replacement, with the same round trip

## See also

- [Strings and text](../strings_and_text/README.md) — what the payload is made of
- [Dates and times](../dates_and_times/README.md) — the conversion at the boundary
- [BAPIs and RFC](../bapis_and_rfc/README.md) — the other integration shape
- [File handling](../file_handling/README.md) — writing the result somewhere
- [`CALL TRANSFORMATION`](../../02_Keywords/call_transformation/README.md) — ABAP to XML and JSON
- [HTTP client](../http_client/README.md) — calling a REST API
- [OData, Gateway and Fiori](../odata_and_fiori/README.md) — how ABAP reaches a browser
