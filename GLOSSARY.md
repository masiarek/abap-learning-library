# Glossary

Short definitions. Every entry links to the page that explains it properly — a definition that dead-ends hides the lesson that already exists, so an entry arrives *with* its lesson rather than ahead of it.

Where an entry points at a page marked **stub**, the definition here is the whole of what this library currently says about it.

## A – C

**ABAP Cloud** — the restricted development model in which only *released* APIs and tables may be used; rules out much of classic ABAP regardless of release. → [ABAP Cloud](03_Topics/abap_cloud/README.md)

**ABAP Unit** — the xUnit framework built into the language; a local class marked `FOR TESTING`, invisible in production. → [ABAP Unit](03_Topics/abap_unit/README.md)

**ALV** — the ABAP List Viewer: an internal table displayed as a grid with sorting, filtering, totals and Excel export, for a handful of lines of code. → [ALV](03_Topics/alv/README.md)

**AMDP** — an ABAP Managed Database Procedure: a method whose body is SQLScript, executed by HANA. The last step of code pushdown, and the first that ties you to one database. → [AMDP and code pushdown](03_Topics/amdp_and_code_pushdown/README.md)

**ATC** — the ABAP Test Cockpit, which runs Code Inspector checks over your objects and usually gates the transport. → [ATC and Code Inspector](03_Topics/atc_and_code_inspector/README.md)

**BAdI** — Business Add-In: an SAP-provided hook where customer logic may be implemented without modifying SAP's code. → [Enhancements and BAdIs](03_Topics/enhancements_and_badis/README.md)

**BAPI** — a released, RFC-enabled function module with a documented interface and a `RETURN` table; it deliberately does not commit. → [BAPIs and RFC](03_Topics/bapis_and_rfc/README.md)

**`BAPIRET2`** — the structure a BAPI reports problems in: type, message id, number, text and four variables — the same pieces `MESSAGE` leaves in `sy-msg…`. → [`MESSAGE`](02_Keywords/message/README.md)

**Behaviour definition** — the RAP artefact declaring what may be created, updated, deleted, validated and determined for an entity. → [RAP](03_Topics/rap/README.md)

**CDS view** — a SQL view defined as versioned, transportable source, carrying annotations, associations and access control alongside the query. → [CDS views](03_Topics/cds_views/README.md)

**Classic exception** — a function module's non-object exception: a number assigned at the call site and read back from `sy-subrc`. → [`CALL FUNCTION`](02_Keywords/call_function/README.md)

**Clean ABAP** — SAP's open style guide, and the book of it. → [Clean ABAP](03_Topics/clean_abap/README.md)

**Code pushdown** — doing the work on the database — Open SQL, then CDS, then AMDP — instead of transferring rows to loop over them. → [AMDP and code pushdown](03_Topics/amdp_and_code_pushdown/README.md)

**Control break** — the `AT NEW` / `AT END OF` way of totalling per group inside a `LOOP`, replaced by `GROUP BY`. → [`LOOP AT`](02_Keywords/loop_at/README.md)

## D – I

**Data element** — the DDIC layer that adds field labels, F1 help and a search help to a domain's technical type. → [DDIC, domains and data elements](03_Topics/ddic_and_domains/README.md)

**DDIC** — the ABAP Dictionary: the system's own type system, with documentation, check tables and conversion routines attached. → [DDIC, domains and data elements](03_Topics/ddic_and_domains/README.md)

**Domain** — the DDIC layer holding the technical type and value range that one or more data elements share. → [DDIC, domains and data elements](03_Topics/ddic_and_domains/README.md)

**Enqueue lock** — SAP's advisory lock: it blocks only code that asks for the same lock, and every `COMMIT WORK` releases it. → [LUW and locking](03_Topics/luw_and_locking/README.md)

**Field symbol** — an alias for a piece of memory, written `<fs>`; `ASSIGNING` in a loop writes into the table rather than into a copy. → [`FIELD-SYMBOLS` and `ASSIGN`](02_Keywords/field_symbols/README.md)

**`FOR ALL ENTRIES`** — an Open SQL addition driving a `WHERE` from an internal table; an empty driver table selects **everything**, and the result is de-duplicated. → [Open SQL](03_Topics/open_sql/README.md)

**Function module** — a globally callable unit inside a function group, with a typed interface; the unit BAPIs and RFC are built from. → [Modularization](03_Topics/modularization/README.md)

**Hashed table** — an internal table with one-step lookup by full key, no index and no duplicates. → [Internal tables](03_Topics/internal_tables/README.md)

**IDoc** — a structured document moved asynchronously between systems and stored with a status history, so a failure can be corrected and reprocessed. → [IDocs](03_Topics/idocs/README.md)

**Inline declaration** — `DATA(x) = …`, which creates the variable at the point of first write and infers its type from the operand. 7.40 and later. → [`DATA`](02_Keywords/data/README.md)

**Internal table** — ABAP's only collection type, declared `STANDARD`, `SORTED` or `HASHED`; the kind is a promise about lookup cost and duplicates. → [Internal tables](03_Topics/internal_tables/README.md)

## L – R

**LUW** — Logical Unit of Work. The *database* LUW ends at every commit; the *SAP* LUW spans a business transaction, bridged by the update task. → [LUW and locking](03_Topics/luw_and_locking/README.md)

**Message class** — the `SE91` container holding numbered, translatable message texts, referenced as `e001(zfin)`. → [`MESSAGE`](02_Keywords/message/README.md)

**Open SQL** — SQL that runs on any supported database and speaks ABAP's types, with `@` escaping host variables in the strict syntax. → [Open SQL](03_Topics/open_sql/README.md)

**Packed number** — `TYPE p LENGTH n DECIMALS d`: exact decimal arithmetic, and the only safe type for money. → [Numbers and currency](03_Topics/numbers_and_currency/README.md)

**PCRE** — the regular-expression flavour available from 7.55 and recommended over the older POSIX `REGEX`. → [Regular expressions](03_Topics/regular_expressions/README.md)

**Ranges table** — the `SIGN`/`OPTION`/`LOW`/`HIGH` table behind `SELECT-OPTIONS`, usable directly in an Open SQL `IN`. → [`PARAMETERS` and `SELECT-OPTIONS`](02_Keywords/parameters_select_options/README.md)

**RAP** — the RESTful Application Programming model: CDS model plus behaviour definition plus generated OData service, with the framework owning the transaction. → [RAP](03_Topics/rap/README.md)

**RFC** — Remote Function Call: a function module called with `DESTINATION`, synchronously, queued or asynchronously. → [BAPIs and RFC](03_Topics/bapis_and_rfc/README.md)

**RTTI** — Run Time Type Information: `cl_abap_typedescr` and its family, describing a value's type and building new types at runtime. → [Dynamic programming](03_Topics/dynamic_programming/README.md)

## S – Z

**Secondary key** — an extra index declared on an internal table, used only by reads that name it. → [Internal tables](03_Topics/internal_tables/README.md)

**Selection screen** — the input screen a report gets free from its `PARAMETERS` and `SELECT-OPTIONS`, with its own event order. → [Selection screens](03_Topics/selection_screens/README.md)

**Sorted table** — an internal table kept in key order, searched by binary search, with optional uniqueness. → [Internal tables](03_Topics/internal_tables/README.md)

**Standard table** — an internal table in insertion order, searched linearly by default, allowing duplicates. → [Internal tables](03_Topics/internal_tables/README.md)

**String template** — `|text { expression }|`: text with expressions and formatting options, always producing a `string`. → [String templates](02_Keywords/string_templates/README.md)

**`sy-subrc`** — the system field most ABAP statements report success or failure in; ignoring it is the most common way an error becomes a wrong answer. → [`READ TABLE` and table expressions](02_Keywords/read_table/README.md)

**Table expression** — `itab[ … ]`, reading a row as an expression; a miss raises `CX_SY_ITAB_LINE_NOT_FOUND` rather than setting `sy-subrc`. → [`READ TABLE` and table expressions](02_Keywords/read_table/README.md)

**Transport request** — the record of a change, released in development and imported into test and production in order. → [Transports](03_Topics/transports/README.md)

**Update task** — the mechanism that defers database work registered with `IN BACKGROUND TASK` until `COMMIT WORK`. → [LUW and locking](03_Topics/luw_and_locking/README.md)

**Variant** — a saved set of selection-screen values; usually the only input a background job has. → [Background jobs](03_Topics/background_jobs/README.md)

## See also

- [Keywords](02_Keywords/README.md) — one page per keyword
- [Topics](03_Topics/README.md) — one page per idea
- [Foundations](01_Foundations/README.md) — the pages with a recorded run behind them
