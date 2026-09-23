# File handling — which machine is the file on?

**Level:** 201 · working knowledge

**Status:** stub — the split is here; the worked example is not yet.

**One line:** ABAP reads and writes files in two completely different places — the **application server**, with `OPEN DATASET`, and the **user's PC**, with `cl_gui_frontend_services` — and only the first one works in a background job, which is the distinction most file bugs come down to.

## The two worlds

| | Application server | Presentation server |
|---|---|---|
| Statements / API | `OPEN DATASET`, `READ`/`TRANSFER`, `CLOSE DATASET` | `cl_gui_frontend_services`, `GUI_UPLOAD`/`GUI_DOWNLOAD` |
| Works in background | yes | **no** — there is no GUI |
| Authorization | `S_DATASET` | the user's own filesystem |
| Path | logical file name (`FILE`, `SF01`) → physical path | whatever the user picked |
| Encoding | named explicitly, or the system default | the frontend's |

A program that downloads to the user's PC cannot be scheduled. A program that writes to the server and expects the user to see it needs a second step — a transfer, an email, or a report that displays the content.

## The parts that go wrong

- **Encoding.** `ENCODING DEFAULT` is the system's code page, so the same program produces different bytes on different systems. Name `UTF-8`, and agree on the BOM explicitly.
- **Hard-coded paths.** A path that works in development is a path that does not exist in production. Logical file names exist so the mapping is configuration.
- **Line endings.** A file written on Unix and read on Windows, or the reverse, is the oldest interface defect there is.
- **Cloud.** `OPEN DATASET` is not released in ABAP Cloud; see [ABAP Cloud](../abap_cloud/README.md).

## What this page still needs

- [ ] a `snippets/` program writing and reading a UTF-8 file with full error handling
- [ ] a recorded run showing the bytes produced with `ENCODING DEFAULT` on a named system
- [ ] logical file names end to end, with `FILE_GET_NAME`
- [ ] the cloud-ready alternatives, and what they cost

## See also

- [`OPEN DATASET`](../../02_Keywords/open_dataset/README.md) — the statement, in detail
- [How long is a string?](../../01_Foundations/how_long_is_a_string/README.md) — bytes against characters, with a program
- [Background jobs](../background_jobs/README.md) — why the frontend option disappears
- [Authorizations](../authorizations/README.md) — `S_DATASET`
- [Unicode and code pages](../unicode_and_code_pages/README.md) — characters, bytes, and naming the code page
- [Security](../security/README.md) — injection in dynamic SQL, code and file paths
