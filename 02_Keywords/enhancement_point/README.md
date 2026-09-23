# `ENHANCEMENT-POINT` and `ENHANCEMENT-SECTION` — source-level hooks, explicit and implicit

**Level:** 301 · deep dive

**Status:** stub — the vocabulary is here; the worked example is not yet.

**One line:** SAP marks places in its own source where customer code may be inserted — explicit `ENHANCEMENT-POINT`s, `ENHANCEMENT-SECTION`s that can be *replaced*, and implicit points at the start and end of every method, form and include — and an enhancement implementation there runs as if it were part of the standard, without being a modification.

## The vocabulary

| Construct | Means |
|---|---|
| `ENHANCEMENT-POINT name SPOTS spot.` | insert code here |
| `ENHANCEMENT-SECTION … END-ENHANCEMENT-SECTION.` | insert, or **replace** the whole section |
| Implicit enhancement point | start/end of every method, form, function module, include — no marker needed |
| `ENHANCEMENT n zenh_impl. … ENDENHANCEMENT.` | what the enhancement looks like in the standard source once implemented |
| Enhancement spot / implementation (`SE18`/`SE19`, ADT) | the repository objects that own it |

In the editor, *Enhance* mode (spiral icon) shows the points; in ADT, the enhancement view. An implementation is a separate transportable object, which is what distinguishes it from a modification.

## The traps

- A replaced `ENHANCEMENT-SECTION` **removes** SAP's code. An upgrade that changes the section leaves your replacement in place and SAP's fix out.
- Implicit enhancements at the end of a method run after `RETURN`s have already left it — check the flow before assuming the code runs.
- Variables in scope are SAP's, with SAP's names, which change between releases without notice.

## What this page still needs

- [ ] a worked implicit enhancement on a demo program, with the source as the editor shows it afterwards
- [ ] `SPAU` behaviour on upgrade for each kind, recorded
- [ ] the ABAP Cloud position: which of these survive (none), and what replaces them

## See also

- [Enhancements and BAdIs](../../03_Topics/enhancements_and_badis/README.md) — the whole ladder
- [`GET BADI`, `CALL BADI`](../get_badi/README.md) — the interface-based alternative
- [Transports](../../03_Topics/transports/README.md) — how an implementation travels
- [ABAP Cloud](../../03_Topics/abap_cloud/README.md) — where source-level enhancement ends
