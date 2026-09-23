# `CALL TRANSFORMATION` — ABAP to XML and JSON, and back

**Level:** 201 · working knowledge

**Status:** stub — the shape is here; the worked program is not yet.

**One line:** `CALL TRANSFORMATION id SOURCE … RESULT XML …` serialises ABAP data to XML (or, through `sXML` writers, JSON) with the built-in identity transformation, and a Simple Transformation or XSLT named in its place maps to any shape you need — with the identity's asXML format being lossless and nobody else's.

## The shapes

```abap
CALL TRANSFORMATION id SOURCE data = ls_order RESULT XML DATA(lv_xml).
CALL TRANSFORMATION id SOURCE XML lv_xml RESULT data = ls_back.

CALL TRANSFORMATION zst_order SOURCE order = ls_order RESULT XML lv_partner_xml.

DATA(lo_writer) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).
CALL TRANSFORMATION id SOURCE data = ls_order RESULT XML lo_writer.
DATA(lv_json) = lo_writer->get_output( ).
```

`id` produces **asXML** — SAP's canonical XML for ABAP data, with `<asx:abap>` around it. It round-trips anything, including references, and no external partner wants it. A Simple Transformation (`STRANS`) is a declarative template for the shape you actually agreed on, and it works in both directions from one definition; XSLT is for XML you did not design.

## Why it earns a page

Every OData, SOAP and file interface serialises somewhere, and `CALL TRANSFORMATION` is the primitive underneath most of them. The trap is the one on the [JSON and XML](../../03_Topics/json_and_xml/README.md) page: ABAP names are upper case, initial values are not absent, and dates come out as `20260922` unless a transformation says otherwise.

## What this page still needs

- [ ] a `snippets/` program round-tripping a nested structure through `id`, XML and JSON
- [ ] a Simple Transformation for a fixed schema, with the `tt:` vocabulary explained
- [ ] `OPTIONS` (`initial_components`, `value_handling`) and what each changes

## See also

- [JSON and XML](../../03_Topics/json_and_xml/README.md) — the topic page, with the alternatives
- [Strings and text](../../03_Topics/strings_and_text/README.md) — `string` and `xstring`, which is which
- [Dates and times](../../03_Topics/dates_and_times/README.md) — the date format decision
- [HTTP client](../../03_Topics/http_client/README.md) — where the payload usually goes
