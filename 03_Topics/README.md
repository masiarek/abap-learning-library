# Topics

**One line:** One page per idea — the things you have to understand rather than look up, each pulling together the keywords that serve it.

[Keywords](../02_Keywords/README.md) cuts the language by vocabulary. This shelf cuts it by *problem*: what an internal table costs, what a LUW is, why a date arrives empty, what to write in 2026 and what to only be able to read. Where a keyword page answers "what does `LOOP AT` do", a topic page answers "how do I hold a few thousand rows without the program falling over".

Pages here follow the same rule as everywhere else in this library: a program in `snippets/` is **syntax-checked and never run**, so no page shows output it has not earned. See [Keywords](../02_Keywords/README.md#what-the-machine-checks-here-and-what-it-cannot) for exactly where that gate stops.

## The core

| Topic | Level | In one line |
|---|---|---|
| [Internal tables](internal_tables/README.md) | 201 | Three table kinds, three promises about lookup cost — pick the one your access pattern needs |
| [Open SQL](open_sql/README.md) | 201 | The database is not a file: what to push down, and the two silent traps in `FOR ALL ENTRIES` |
| [Strings and text](strings_and_text/README.md) | 201 | `string` grows, `c` is padded forever, and the functions that work on both |
| [Dates and times](dates_and_times/README.md) | 201 | `d` is eight characters you can do arithmetic on — and a time zone you have to name |
| [Numbers and currency](numbers_and_currency/README.md) | 201 | `i` rounds, `p` is exact, `f` lies, and SAP stores amounts with a decimal shift |
| [Object-oriented ABAP](oo_abap/README.md) | 201 | Classes, interfaces, and why a new program starts with one even when it is a report |
| [Exceptions](exceptions/README.md) | 201 | Three exception flavours, and what each one asks of the caller |
| [ABAP Unit](abap_unit/README.md) | 201 | Tests that ship with the program, and the design pressure that makes them possible |
| [Which release am I writing for?](releases_and_syntax_levels/README.md) | 101 | The question behind half the confusing answers online |

## The Dictionary and the data model

| Topic | Level | In one line |
|---|---|---|
| [DDIC, domains and data elements](ddic_and_domains/README.md) | 201 | A type that carries its own label, help and check table |
| [CDS views](cds_views/README.md) | 201 | The data model as source code, versioned and transported like everything else |
| [AMDP and code pushdown](amdp_and_code_pushdown/README.md) | 301 | Writing SQLScript in an ABAP class, and when that is the wrong idea |
| [RAP — the RESTful Application Programming model](rap/README.md) | 301 | Behaviour definitions, drafts, and what replaced BOPF |

## Building applications

| Topic | Level | In one line |
|---|---|---|
| [Selection screens](selection_screens/README.md) | 101 | The free UI every report gets, and its events |
| [ALV](alv/README.md) | 201 | The grid that gives sorting, filtering and Excel export for nothing |
| [Modularization](modularization/README.md) | 201 | Function modules, includes, classes — what to reach for now |
| [Enhancements and BAdIs](enhancements_and_badis/README.md) | 301 | Changing SAP's behaviour without modifying SAP's code |
| [BAPIs and RFC](bapis_and_rfc/README.md) | 201 | Calling into SAP, and the `BAPI_TRANSACTION_COMMIT` everyone forgets |
| [IDocs](idocs/README.md) | 201 | Asynchronous documents, their status codes, and where they queue up |
| [JSON and XML](json_and_xml/README.md) | 201 | Serialising ABAP data, and the name-casing surprise |
| [File handling](file_handling/README.md) | 201 | Application server versus presentation server, and the encoding question |

## Correctness, safety and speed

| Topic | Level | In one line |
|---|---|---|
| [LUW and locking](luw_and_locking/README.md) | 301 | Where a transaction really ends, and the enqueue that is only advisory |
| [Authorizations](authorizations/README.md) | 201 | The check nobody does for you, and where it belongs |
| [Performance](performance/README.md) | 201 | The nested loop, the SELECT in a loop, and how to measure instead of guess |
| [Debugging](debugging/README.md) | 201 | Breakpoints that survive, watchpoints, and debugging something you cannot start |
| [ATC and Code Inspector](atc_and_code_inspector/README.md) | 201 | The checks your transport will be judged by anyway |
| [Clean ABAP](clean_abap/README.md) | 201 | SAP's own style guide, and the handful of rules that pay immediately |
| [Dynamic programming](dynamic_programming/README.md) | 301 | Names decided at runtime — and every check that moves there with them |
| [Regular expressions](regular_expressions/README.md) | 201 | PCRE since 7.55, and what changed from the POSIX engine before it |

## Around the code

| Topic | Level | In one line |
|---|---|---|
| [Background jobs](background_jobs/README.md) | 201 | What changes when nobody is watching the screen |
| [Transports](transports/README.md) | 201 | How code moves between systems, and what a transport cannot carry |
| [ABAP Cloud](abap_cloud/README.md) | 301 | Released APIs only — the rules that decide what still compiles in 2026 |
| [Resources](resources/README.md) | reference | Books, courses and references worth the time, with what each is actually good for |

## See also

- [Keywords](../02_Keywords/README.md) — the same language, one page per keyword
- [Foundations](../01_Foundations/README.md) — pages with a recorded run behind them
- [Glossary](../GLOSSARY.md) — short definitions that point at the page that earns them
