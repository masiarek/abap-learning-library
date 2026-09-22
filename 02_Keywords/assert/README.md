# `ASSERT` — a claim that ends the program when it is false

**Level:** 201 · working knowledge

**Status:** stub — the shape and the trap are here; the worked program is not yet.

**One line:** `ASSERT cond.` short-dumps when the condition is false, and that is the point: an assertion is for a state that is **impossible** unless the program is wrong, never for input that might legitimately be bad.

## What it does

```abap
ASSERT lo_handler IS BOUND.
ASSERT lines( lt_rows ) > 0.
```

No message, no `sy-subrc`, no recovery: a failed `ASSERT` raises `ASSERTION_FAILED` and produces a dump with the full call stack and variable contents — which is far more useful for finding a bug than a caught exception that was logged and swallowed.

With an activation ID, an assertion can be switched on per system, so expensive checks live in development and cost nothing in production:

```abap
ASSERT ID zfin_checks CONDITION lv_total = lv_expected.
```

## Why it has its own page

The line between `ASSERT` and an exception is a design decision people get wrong in both directions:

- **A user typed something odd** → not an assertion. That is a [`MESSAGE`](../message/README.md) or an [exception](../try_catch/README.md).
- **A method was called with a reference that must have been set by its own caller three lines earlier** → an assertion. If it is unbound, the program is broken, and continuing means corrupting data instead of stopping.

Assertions in production code are a statement of confidence, not of paranoia — which is why they belong on invariants and not on inputs.

## What this page still needs

- [ ] a `snippets/` program with a satisfied and an unsatisfied assertion
- [ ] the exact dump text a failed `ASSERT` produces, recorded from a real system
- [ ] how `ASSERT ID` interacts with the checkpoint group settings in `SAAB`

## See also

- [`TRY`, `CATCH`, `RAISE`](../try_catch/README.md) — for failures the caller can handle
- [`MESSAGE`](../message/README.md) — for failures a user caused
- [ABAP Unit](../../03_Topics/abap_unit/README.md) — assertions in tests, where they are the whole mechanism
- [`CHECK`, `CONTINUE`, `EXIT`, `RETURN`](../check_continue_exit/README.md) — the statements `ASSERT` is often confused with
