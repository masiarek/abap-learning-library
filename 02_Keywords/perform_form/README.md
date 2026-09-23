# `FORM` and `PERFORM` — obsolete, everywhere, and worth reading fluently

**Level:** 201 · working knowledge

**Status:** stub — the shape is here; the worked program is not yet.

**One line:** Subroutines are the pre-object way to modularize a program, SAP has marked them obsolete and forbids them in ABAP Cloud, and you will still read thousands of them — so the goal of this page is fluency in `FORM`, not fluency in writing new ones.

## What it does

```abap
PERFORM calculate USING lv_gross CHANGING lv_net.

FORM calculate USING p_gross TYPE ty_amount
               CHANGING p_net TYPE ty_amount.
  p_net = p_gross / '1.20'.
ENDFORM.
```

`USING` passes in, `CHANGING` passes in and out — and both are **by reference by default**, so a `USING` parameter can be modified by the subroutine and the caller will see it. `VALUE(p_x)` forces a copy. That single default is the source of a whole genre of bug in old reports.

Worse: parameters may be declared without a type. An untyped `USING p_x` accepts anything, and a mismatch becomes a runtime conversion or a dump rather than a syntax error.

## Why it is obsolete, and what replaces it

A `FORM` has no visibility rules, no instance state, no constructor, cannot be unit tested in isolation, and sits in a program's global namespace where it can see and change every global variable. A private method on a local class fixes all of that and costs two extra lines.

Still: `PERFORM` is how classic user exits, many SAPscript routines and countless reports are written, and a system that has run since 2005 is full of them. Reading them accurately — especially which parameters are by reference — is a working skill.

## What this page still needs

- [ ] a `snippets/` program showing by-reference `USING` modifying the caller's variable
- [ ] `PERFORM … IN PROGRAM`, the dynamic form, and where SAP's own exits use it
- [ ] a worked conversion of one `FORM` into a method, with the test that becomes possible
- [ ] what the ATC says about `FORM` under the ABAP Cloud rules

## See also

- [Modularization](../../03_Topics/modularization/README.md) — the topic page: includes, function modules, classes
- [`METHODS` and parameters](../methods/README.md) — the replacement, with typed directions
- [`CALL FUNCTION`](../call_function/README.md) — the other classic modularization unit
- [ABAP Cloud](../../03_Topics/abap_cloud/README.md) — where `FORM` no longer compiles
- [Obsolete declarations](../obsolete_declarations/README.md) — `TABLES`, `OCCURS`, header lines, `RANGES`
- [Obsolete statements](../move_add_compute/README.md) — `MOVE`, `ADD`, `COMPUTE` — recognise, do not write
- [Macros](../define_macro/README.md) — `DEFINE`, and why not
