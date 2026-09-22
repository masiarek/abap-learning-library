# Which release am I writing for?

**Level:** 101 · newcomer

**One line:** ABAP's defining fact is that it never removes anything: `DATA(x)` is ordinary on 7.40 and a syntax error on 7.02, `PCRE` needs 7.55, `RAISE EXCEPTION NEW` needs 7.52 — so "is this correct ABAP?" is not a question with one answer, and half the confusing advice online is someone else's release.

## Where to look it up in your own system

`SAP_BASIS` is the component that carries the ABAP release. `System → Status → Component information` shows it; `SE38` running `RSUVM005`, or a look at table `CVERS`, says the same. Note both the release and the support package: some additions arrive inside an SP.

Write the answer down in the code you produce. A page in this library that says "7.58" is making a claim about one system; a program that assumes 7.40 in a 7.02 system does not compile, and one that assumes 7.02 in a 7.58 system merely looks twenty years old.

## What arrived when — the additions you will actually miss

| Release | Brought |
|---|---|
| 7.02 / 7.03 | string functions, `CASE TYPE OF`, regular expressions (`REGEX`) |
| **7.40** | inline `DATA( )`, `VALUE`, `FOR`, `REDUCE`, `COND`, `SWITCH`, `NEW`, `CAST`, `CONV`, table expressions `itab[ ]`, `GROUP BY`, `@` in Open SQL, string templates |
| 7.50 | `FILTER`, CDS view enhancements, AMDP maturing |
| 7.51 | enumerated types (`BEGIN OF ENUM`), more CDS |
| 7.52 | `RAISE EXCEPTION NEW`, `MESSAGE` in more contexts, CDS table functions |
| 7.55 | `PCRE` regular expressions |
| 7.56+ / cloud | ABAP Cloud restrictions, released-API enforcement, RAP maturing |

7.40 is the watershed. Nearly everything that makes modern ABAP look unlike 1998 arrived in that one release, which is why a system on 7.31 feels like a different language rather than an older version of this one.

## The two questions to ask before writing anything

1. **Which release is the *oldest* system this code will run on?** Not the development system — the oldest one in the transport route, and any system it will be copied into later.
2. **Is this code destined for ABAP Cloud?** If so, the release is not the only limit: only *released* APIs may be used, and a large part of classic ABAP — `OPEN DATASET`, `WRITE` lists, `CALL FUNCTION` on unreleased modules, `FORM` — is out regardless of release. See [ABAP Cloud](../abap_cloud/README.md).

## What this page still needs

- [ ] the release of each construct checked against SAP's own documentation rather than recalled
- [ ] a small program, recorded on two systems of different releases, showing the same source failing on one
- [ ] where the ATC's "syntax check against a target release" setting lives, and how to use it in a mixed landscape

## See also

- [ABAP Cloud](../abap_cloud/README.md) — the other axis: not how old, but how restricted
- [Keywords](../../02_Keywords/README.md) — every page names the release its construct needs
- [ATC and Code Inspector](../atc_and_code_inspector/README.md) — checking against a target release automatically
- [Clean ABAP](../clean_abap/README.md) — which of the new constructs are worth adopting first
