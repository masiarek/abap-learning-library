# Topics

**One line:** One page per idea — the things you have to understand rather than look up, each pulling together the keywords that serve it.

[Keywords](../02_Keywords/README.md) cuts the language by vocabulary. This shelf cuts it by *problem*: what an internal table costs, what a LUW is, why a date arrives empty, what to write in 2026 and what to only be able to read. Where a keyword page answers "what does `LOOP AT` do", a topic page answers "how do I hold a few thousand rows without the program falling over".

Pages here follow the same rule as everywhere else in this library: a program in `snippets/` is **syntax-checked and never run**, so no page shows output it has not earned. See [Keywords](../02_Keywords/README.md#what-the-machine-checks-here-and-what-it-cannot) for exactly where that gate stops.

## The core

| Topic | Level | In one line |
|---|---|---|
| [Types at a glance](types_at_a_glance/README.md) | 101 | Every elementary type, its initial value, and the three pairs that get confused |
| [Initial values and null](initial_values_and_null/README.md) | 101 | ABAP has no null — every variable has a value from birth, and SQL `NULL` stops at the boundary |
| [Conversion and comparison rules](conversion_and_comparison_rules/README.md) | 201 | What happens between two types, silently, on assignment and on comparison |
| [Internal tables](internal_tables/README.md) | 201 | Three table kinds, three promises about lookup cost — pick the one your access pattern needs |
| [Open SQL](open_sql/README.md) | 201 | The database is not a file: what to push down, and the two silent traps in `FOR ALL ENTRIES` |
| [Strings and text](strings_and_text/README.md) | 201 | `string` grows, `c` is padded forever, and the functions that work on both |
| [Dates and times](dates_and_times/README.md) | 201 | `d` is eight characters you can do arithmetic on — and a time zone you have to name |
| [Numbers and currency](numbers_and_currency/README.md) | 201 | `i` rounds, `p` is exact, `f` lies, and SAP stores amounts with a decimal shift |
| [Constructor expressions](constructor_expressions/README.md) | 201 | The `VALUE`/`NEW`/`CONV`/`COND` family: one grammar, one `#`, one readability limit |
| [Modern versus classic](modern_vs_classic/README.md) | 201 | What to write instead — every old construct beside its replacement and the release it needs |
| [Object-oriented ABAP](oo_abap/README.md) | 201 | Classes, interfaces, and why a new program starts with one even when it is a report |
| [Exceptions](exceptions/README.md) | 201 | Three exception flavours, and what each one asks of the caller |
| [ABAP Unit](abap_unit/README.md) | 201 | Tests that ship with the program, and the design pressure that makes them possible |
| [Test doubles](test_doubles/README.md) | 301 | Replacing the class, the database, the function module — and the seam each one needs |
| [Which release am I writing for?](releases_and_syntax_levels/README.md) | 101 | The question behind half the confusing answers online |

## The Dictionary and the data model

| Topic | Level | In one line |
|---|---|---|
| [DDIC, domains and data elements](ddic_and_domains/README.md) | 201 | A type that carries its own label, help and check table |
| [Conversion routines](conversion_routines/README.md) | 201 | `ALPHA`, and why a `SELECT` with the display form finds nothing |
| [Table types and buffering](table_types_and_buffering/README.md) | 201 | Transparent, pooled, cluster — and the per-server buffer that goes stale |
| [Table maintenance](table_maintenance/README.md) | 201 | `SM30`, the generator, and its events |
| [Number ranges](number_ranges/README.md) | 201 | The next document number, the buffer that leaves gaps, and the rollback that does not give one back |
| [Change documents](change_documents/README.md) | 201 | Who changed what — written by transactions and BAPIs, never by a direct `UPDATE` |
| [CDS views](cds_views/README.md) | 201 | The data model as source code, versioned and transported like everything else |
| [AMDP and code pushdown](amdp_and_code_pushdown/README.md) | 301 | Writing SQLScript in an ABAP class, and when that is the wrong idea |
| [Native SQL](native_sql/README.md) | 301 | When Open SQL is not enough, and the six things you give up |
| [HANA specifics](hana_specifics/README.md) | 301 | What changes on a column store — including the `ORDER BY` that was never written |
| [RAP — the RESTful Application Programming model](rap/README.md) | 301 | Behaviour definitions, drafts, and what replaced BOPF |
| [BOPF](bopf/README.md) | 301 | The framework before RAP, for the maintainers of what was built on it |

## Building applications

| Topic | Level | In one line |
|---|---|---|
| [Program types](program_types/README.md) | 101 | Executable, module pool, function group, class pool — what each may hold and how it starts |
| [Selection screens](selection_screens/README.md) | 101 | The free UI every report gets, and its events |
| [Classic reports](classic_reports/README.md) | 201 | Lists, pages, `HIDE` and `AT LINE-SELECTION` — the model under thousands of shipped reports |
| [ALV](alv/README.md) | 201 | The grid that gives sorting, filtering and Excel export for nothing |
| [Dynpro screens](dynpro_screens/README.md) | 301 | Flow logic, field transport by name, and why every classic transaction still runs on it |
| [Web Dynpro and legacy UI](web_dynpro_and_legacy_ui/README.md) | 201 | BSP, Web Dynpro ABAP and FPM — what came between dynpros and Fiori |
| [OData, Gateway and Fiori](odata_and_fiori/README.md) | 201 | How ABAP reaches a browser: `SEGW` and RAP, and the annotations that draw the app |
| [Forms and printing](forms_and_printing/README.md) | 201 | SAPscript, Smart Forms, Adobe Forms, and the spool they all end in |
| [Text elements and translation](text_elements_and_translation/README.md) | 101 | Nothing a user reads belongs in a literal |
| [Modularization](modularization/README.md) | 201 | Function modules, includes, classes — what to reach for now |
| [Enhancements and BAdIs](enhancements_and_badis/README.md) | 301 | Changing SAP's behaviour without modifying SAP's code |
| [BAPIs and RFC](bapis_and_rfc/README.md) | 201 | Calling into SAP, and the `BAPI_TRANSACTION_COMMIT` everyone forgets |
| [IDocs](idocs/README.md) | 201 | Asynchronous documents, their status codes, and where they queue up |
| [Batch input and BDC](batch_input/README.md) | 201 | Driving a transaction as if you were typing — fragile, and sometimes the only way |
| [Logical databases](logical_databases/README.md) | 201 | `GET` events, and why old HR and FI reports look strange |
| [Workflow](workflow/README.md) | 301 | Tasks, agents and events — and which part of it is the developer's |
| [Application log](application_log/README.md) | 201 | Messages that outlive the run, readable in `SLG1` |
| [JSON and XML](json_and_xml/README.md) | 201 | Serialising ABAP data, and the name-casing surprise |
| [HTTP client](http_client/README.md) | 201 | Calling a REST API: the destination, the certificate, and the status you must read |
| [Email from ABAP](email_from_abap/README.md) | 201 | `cl_bcs`, the commit that sends it, and `SOST` when nothing arrives |
| [File handling](file_handling/README.md) | 201 | Application server versus presentation server, and the encoding question |

## Correctness, safety and speed

| Topic | Level | In one line |
|---|---|---|
| [LUW and locking](luw_and_locking/README.md) | 301 | Where a transaction really ends, and the enqueue that is only advisory |
| [ABAP memory and SAP memory](abap_memory_and_sap_memory/README.md) | 201 | Four memories between programs, each with its own lifetime and its own way to go stale |
| [Authorizations](authorizations/README.md) | 201 | The check nobody does for you, and where it belongs |
| [Security](security/README.md) | 301 | Injection in dynamic SQL, code and file paths — the ABAP-specific holes, and the fix for each |
| [Performance](performance/README.md) | 201 | The nested loop, the SELECT in a loop, and how to measure instead of guess |
| [Parallel processing](parallel_processing/README.md) | 301 | No threads: `STARTING NEW TASK`, bgRFC, server groups, and every question they raise |
| [Unicode and code pages](unicode_and_code_pages/README.md) | 201 | Characters, bytes, and which code page you meant |
| [Debugging](debugging/README.md) | 201 | Breakpoints that survive, watchpoints, and debugging something you cannot start |
| [Short dumps](short_dumps/README.md) | 201 | Reading `ST22` in the right order |
| [ATC and Code Inspector](atc_and_code_inspector/README.md) | 201 | The checks your transport will be judged by anyway |
| [Clean ABAP](clean_abap/README.md) | 201 | SAP's own style guide, and the handful of rules that pay immediately |
| [Dynamic programming](dynamic_programming/README.md) | 301 | Names decided at runtime — and every check that moves there with them |
| [Regular expressions](regular_expressions/README.md) | 201 | PCRE since 7.55, and what changed from the POSIX engine before it |

## Around the code

| Topic | Level | In one line |
|---|---|---|
| [How ABAP runs](how_abap_runs/README.md) | 201 | Work processes, dialog steps, and why "per application server" explains so much |
| [Background jobs](background_jobs/README.md) | 201 | What changes when nobody is watching the screen |
| [Transports](transports/README.md) | 201 | How code moves between systems, and what a transport cannot carry |
| [Packages and namespaces](packages_and_namespaces/README.md) | 201 | Where an object lives, and who may use it |
| [Naming conventions](naming_conventions/README.md) | 101 | `Z`, `Y`, `/NAMESPACE/`, and the prefixes inside the code |
| [Documentation and pragmas](documentation_and_pragmas/README.md) | 201 | `"!`, `##NO_TEXT`, `"#EC` — and comments that say why |
| [ADT and SE80](tooling_adt_and_se80/README.md) | 101 | The two workbenches, and what exists only in one of them |
| [abapGit](abapgit/README.md) | 201 | Git for ABAP, and the file naming this library borrows |
| [Standard classes worth knowing](standard_classes/README.md) | 201 | The `CL_ABAP_*` shelf, each with what it is for |
| [S/4HANA custom code migration](s4hana_custom_code/README.md) | 301 | What breaks, and the ATC variant that finds it first |
| [ABAP Cloud](abap_cloud/README.md) | 301 | Released APIs only — the rules that decide what still compiles in 2026 |
| [Resources](resources/README.md) | reference | Books, courses and references worth the time, with what each is actually good for |

## See also

- [Keywords](../02_Keywords/README.md) — the same language, one page per keyword
- [Foundations](../01_Foundations/README.md) — pages with a recorded run behind them
- [Glossary](../GLOSSARY.md) — short definitions that point at the page that earns them
