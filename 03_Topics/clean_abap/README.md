# Clean ABAP — the style guide, and the rules that pay immediately

**Level:** 201 · working knowledge

**Status:** stub — the summary is here; the worked example is not yet.

**One line:** *Clean ABAP* is SAP's own open style guide — a Clean Code reading applied to this language — and the handful of rules that pay for themselves on the first day are: prefer objects to procedures, prefer returning parameters, keep methods short, say what you mean instead of encoding it in a prefix, and write the test.

## The rules worth adopting first

- **Descriptive names over Hungarian prefixes.** `lv_`, `lt_`, `ls_` encode what the compiler already knows. The guide says drop them; a system where every line has them says otherwise. Adopt the local convention and argue for the change separately.
- **One returning parameter** instead of `EXPORTING`. It is what lets a method be used inside an expression. See [`METHODS`](../../02_Keywords/methods/README.md).
- **Short methods, one level of abstraction.** The practical version: if you need a comment to say what a block does, that block is a method with that name.
- **`IF … RETURN.` over `CHECK`** in a method — because `CHECK` is read as a test and behaves as a jump. See [`CHECK`, `CONTINUE`, `EXIT`, `RETURN`](../../02_Keywords/check_continue_exit/README.md).
- **Do not comment what the code says.** Comment why, and delete the block of commented-out code — the version history has it.
- **Write the test.** Every other rule on the list is easier to keep in code that has one.

## Where the guide and reality disagree

Most ABAP is maintained, not written. A file whose style is consistent — even in an old style — is easier to read than one that is half-converted, and a "modernisation" commit mixed into a bug fix is a review nobody can do. The usable version of the guide's advice is: **new code by the guide, touched code left consistent, and a separate deliberate change when a module is genuinely being reworked.**

## What this page still needs

- [ ] a before/after of one real method, with the guide's rules applied one at a time
- [ ] which of the rules the ATC can check automatically, and which are judgement
- [ ] the naming argument settled for this library's own examples, and applied consistently
- [ ] the parts of the guide that are *specific* to ABAP rather than inherited from Clean Code

## See also

- [Object-oriented ABAP](../oo_abap/README.md) — the first rule, argued out
- [ABAP Unit](../abap_unit/README.md) — the last rule, which makes the others stick
- [ATC and Code Inspector](../atc_and_code_inspector/README.md) — the automated half
- [Resources](../resources/README.md) — where to find the guide itself
