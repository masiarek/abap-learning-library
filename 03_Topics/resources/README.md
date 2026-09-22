# Resources — what to read, and what each one is good for

**Level:** reference

**One line:** A short, opinionated shelf: the reference to keep open, the two books that teach modern ABAP, the SAP training courses worth their numbers, and the online sources that are actually maintained — each with what it is good *for*, because "read ABAP to the Future" is not advice.

## Keep this one open while you work

- **ABAP Keyword Documentation** — SAP's own reference, the authority on every statement, its additions and the release each arrived in. In a system it is the transaction `ABAPDOCU`; online it is the [ABAP keyword documentation on help.sap.com](https://help.sap.com/doc/abapdocu_latest_index_htm/latest/en-US/index.htm). When this library and the keyword documentation disagree, the keyword documentation is right.
- **Clean ABAP** — SAP's open style guide, maintained on GitHub at [SAP/styleguides](https://github.com/SAP/styleguides). Free, short, and argued rather than asserted. See [Clean ABAP](../clean_abap/README.md).
- **ABAP cheat sheets** — SAP's own runnable examples for modern syntax, at [SAP-samples/abap-cheat-sheets](https://github.com/SAP-samples/abap-cheat-sheets). The closest thing to this library published by SAP, and a good place to check a construct quickly.

## Books

| Book | Good for |
|---|---|
| **ABAP to the Future** — Paul Hardy (SAP PRESS, 4th ed.) | the modern-syntax tour: what changed since 7.40 and why. Opinionated, readable, wide. The book to give an experienced ABAPer who last looked in 2010 |
| **Clean ABAP** — Haeuptle, Hoffmann, Jordao et al. (SAP PRESS) | the book of the style guide, with the reasoning spelled out |
| **The Official ABAP Reference** — Horst Keller (SAP PRESS) | the printed form of the keyword documentation, for reading rather than looking up |
| **Official ABAP Programming Guidelines** — Keller and Thümmel (SAP PRESS) | why the language is the way it is; the rules with their rationale |
| **Complete ABAP** — Kiran Bandari (SAP PRESS) | a single broad course-like treatment, good as a first book |
| **Object-Oriented Programming with ABAP Objects** — James Wood (SAP PRESS) | the OO half done properly, for someone who writes classes but is not sure why |
| **Design Patterns in ABAP Objects** — Igor Barbaric (SAP PRESS) | patterns in this language rather than translated from Java |
| **ABAP Development for SAP HANA** — Hermann Gahm et al. (SAP PRESS) | code pushdown, AMDP, and what actually changes on HANA |
| **Core Data Services for ABAP** — Renzo Colle et al. (SAP PRESS) | CDS in depth, beyond the annotations you copied |
| **ABAP RESTful Application Programming Model** — Stefan Haas, Bince Mathew (SAP PRESS) | RAP end to end, which the online tutorials cover only in fragments |
| **Beginner's Guide to SAP ABAP** — Peter Moxon | a gentle start for someone with no SAP context at all |

## SAP training courses

The course codes turn up constantly in job adverts and in older colleagues' shorthand. The ones worth knowing by number:

| Code | Covers |
|---|---|
| **BC400** | ABAP Workbench foundations — the standard entry course |
| **BC401** | ABAP Objects |
| **BC402** | advanced ABAP: types, dynamic programming, unit testing |
| **BC403** | the debugger, in depth |
| **BC405** | reporting: selection screens, lists, ALV |
| **BC410** | classic Dynpro programming |
| **BC414** | database changes: LUWs, locking, update task |
| **BC425** | enhancements and modifications |
| **BC430** | the ABAP Dictionary |
| **BC490** | performance analysis and tuning |
| **HA400** | ABAP for SAP HANA |
| **TAW10 / TAW12** | the certification curricula, which bundle the above |

## Online, and maintained

- **SAP Community** — [community.sap.com](https://community.sap.com): the Q&A and blog archive. Quality varies wildly; check the date and the release before trusting an answer, because [half the confusing advice is someone else's release](../releases_and_syntax_levels/README.md).
- **SAP Developer tutorials** — [developers.sap.com](https://developers.sap.com): step-by-step, current, and the fastest route into RAP and CDS.
- **SAP Learning** — [learning.sap.com](https://learning.sap.com): SAP's own free learning journeys, which absorbed the openSAP course catalogue.
- **abapGit** — [abapgit.org](https://abapgit.org): Git for ABAP, and how code like this library's examples actually reaches a system.
- **abaplint** — [abaplint.org](https://abaplint.org): the linter this repository's CI runs, usable in an editor and on a laptop.

## Getting a system to run things on

Everything on this shelf is easier with a system to type into. The usual routes are an **SAP BTP ABAP environment** trial, the **ABAP Platform developer edition** image (the one people call A4H) run locally, or an employer's sandbox client. This library's own rule — that a claim about output needs a recorded run in a named system — exists precisely because getting one is the hard part; see [CONTRIBUTING](../../CONTRIBUTING.md).

## See also

- [Keywords](../../02_Keywords/README.md) — this library's own reference shelf
- [Topics](../README.md) — the same material by idea
- [Clean ABAP](../clean_abap/README.md) — the style guide, summarised
- [Which release am I writing for?](../releases_and_syntax_levels/README.md) — the question to ask of every source above
