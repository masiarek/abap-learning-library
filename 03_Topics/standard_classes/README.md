# Standard classes worth knowing — the `CL_ABAP_*` you will reach for

**Level:** 201 · working knowledge

**Status:** stub — the shelf is here; each entry wants a program.

**One line:** A short list of SAP-delivered classes that solve a problem you will otherwise solve worse — type description, code page conversion, timestamps, random numbers, ALV, JSON, HTTP, mail — with what each is for, so the search starts from a name rather than from the class browser.

## The shelf

| Class | For | Page |
|---|---|---|
| `cl_abap_typedescr`, `cl_abap_structdescr`, `cl_abap_tabledescr`, `cl_abap_elemdescr` | RTTI: describe a type, list its components, build a new one | [Dynamic programming](../dynamic_programming/README.md) |
| `cl_abap_conv_codepage`, `cl_abap_conv_in_ce=>uccp` | characters ↔ bytes; a character from its code point | [Unicode and code pages](../unicode_and_code_pages/README.md) |
| `cl_abap_char_utilities` | `newline`, `horizontal_tab`, `cr_lf` as constants | [File handling](../file_handling/README.md) |
| `cl_abap_tstmp` | timestamp arithmetic and conversion | [Dates and times](../dates_and_times/README.md) |
| `cl_abap_math` | rounding-mode constants, min/max of types | [Numeric functions](../../02_Keywords/numeric_functions/README.md) |
| `cl_abap_random`, `cl_abap_random_int` | random numbers with a seed | — |
| `cl_abap_regex`, `cl_abap_matcher` | stateful regular expressions | [Regular expressions](../regular_expressions/README.md) |
| `cl_abap_dyn_prg` | escaping and whitelists for dynamic SQL and code | [Security](../security/README.md) |
| `cl_abap_unit_assert`, `cl_abap_testdouble` | tests and doubles | [ABAP Unit](../abap_unit/README.md) |
| `cl_salv_table` | ALV in five lines | [ALV](../alv/README.md) |
| `cl_demo_output` | quick output in ADT and SAP GUI, better than `WRITE` for development | [`WRITE`](../../02_Keywords/write/README.md) |
| `/ui2/cl_json`, `cl_sxml_string_writer`, `xco_cp_json` | JSON | [JSON and XML](../json_and_xml/README.md) |
| `cl_http_client`, `cl_web_http_client_manager` | HTTP out | [HTTP client](../http_client/README.md) |
| `cl_bcs`, `cl_document_bcs` | email | [Email from ABAP](../email_from_abap/README.md) |
| `cl_gui_frontend_services` | files and dialogs on the user's PC | [File handling](../file_handling/README.md) |
| `cl_bali_log` | the released application log | [Application log](../application_log/README.md) |
| `cl_system_uuid` | GUIDs | — |
| `cl_abap_context_info` | user, date, time in ABAP Cloud, where `sy` fields are restricted | [ABAP Cloud](../abap_cloud/README.md) |
| `xco_cp_*` | the XCO library: the cloud-era utility layer for strings, JSON, time, generation | [ABAP Cloud](../abap_cloud/README.md) |

Most of these are documented in the class itself (ADT: `F2` on the name) and in the keyword documentation under *ABAP → Classes*. Note that abaplint in this repository cannot resolve any of them, so a snippet calling one is checked for syntax only — see [Keywords](../../02_Keywords/README.md#what-the-machine-checks-here-and-what-it-cannot).

## What this page still needs

- [ ] one `snippets/` program per row that has no page, starting with `cl_abap_random` and `cl_system_uuid`
- [ ] the released/unreleased status of each in ABAP Cloud, checked
- [ ] the XCO library as its own page, since it is large

## See also

- [Dynamic programming](../dynamic_programming/README.md) — the RTTI family
- [ABAP Cloud](../abap_cloud/README.md) — which of these are released
- [Resources](../resources/README.md) — where the class documentation lives
