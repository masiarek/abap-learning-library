# `OPEN DATASET` — files on the application server

**Level:** 201 · working knowledge

**Status:** stub — the shape is here; the worked program is not yet.

**One line:** `OPEN DATASET` reads and writes files on the **application server**, not on the user's PC, and the addition that decides whether the file is readable elsewhere is the encoding — `IN TEXT MODE ENCODING UTF-8` versus `DEFAULT`, where "default" means the system's own code page and therefore something different on the next system.

## What it does

```abap
OPEN DATASET lv_path FOR OUTPUT IN TEXT MODE ENCODING UTF-8.
IF sy-subrc = 0.
  TRANSFER lv_line TO lv_path.
  CLOSE DATASET lv_path.
ENDIF.
```

`FOR INPUT`, `FOR OUTPUT`, `FOR APPENDING`; `IN TEXT MODE` with an `ENCODING`, or `IN BINARY MODE` for bytes. Reading is `READ DATASET … INTO … MAXIMUM LENGTH …`, and every statement reports through `sy-subrc`: a missing file is not an exception.

The user's own machine is a different mechanism entirely — `cl_gui_frontend_services` or `GUI_DOWNLOAD`, which only work where there is a SAP GUI, and therefore not in a background job.

## Why it earns a page

- **Encoding.** `ENCODING DEFAULT` is the system code page, so the same program writes a different file on two systems. Name `UTF-8` and say so in the interface agreement.
- **Byte order mark.** `WITH BYTE-ORDER MARK` is needed by some Windows consumers and breaks others. This is a decision, not a default.
- **Authorization.** File access is checked by `S_DATASET`, and the physical path is usually mapped through logical file names (`FILE`, `SF01`) so that a path is not hard-coded per system.
- **ABAP Cloud.** `OPEN DATASET` is **not** released in ABAP Cloud. Code moving to the cloud model needs a different answer entirely. See [ABAP Cloud](../../03_Topics/abap_cloud/README.md).

## What this page still needs

- [ ] a `snippets/` program writing and reading back a UTF-8 file with error handling
- [ ] a recorded run showing what `ENCODING DEFAULT` produced on a named system
- [ ] logical file names: `FILE_GET_NAME` and why the hard-coded path always survives to production
- [ ] the same job done with `cl_abap_conv_codepage` for in-memory conversion

## See also

- [File handling](../../03_Topics/file_handling/README.md) — the topic page, including the frontend side
- [How long is a string?](../../01_Foundations/how_long_is_a_string/README.md) — bytes against characters, with a program
- [Authorizations](../../03_Topics/authorizations/README.md) — `S_DATASET`
- [Background jobs](../../03_Topics/background_jobs/README.md) — why the frontend alternative is not available there
