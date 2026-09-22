# `IF` and `CASE` — the statements

**Level:** 101 · newcomer

**Status:** stub — the shape is here; the worked program is not yet.

**One line:** `IF`/`ELSEIF`/`ELSE` tests conditions and `CASE`/`WHEN` compares one operand against values, exactly as elsewhere — the ABAP-specific parts are the word operators (`IS INITIAL`, `IS BOUND`, `IS ASSIGNED`, `BETWEEN`, `CO`, `CS`) and the fact that `CASE` cannot express a range.

## What it does

```abap
IF lv_amount > 0 AND lo_handler IS BOUND.
ELSEIF lv_amount IS INITIAL.
ELSE.
ENDIF.

CASE lv_status.
  WHEN 'A' OR 'B'.
  WHEN OTHERS.
ENDCASE.
```

`CASE … WHEN OTHERS` is not required, and leaving it out is how an unexpected status does nothing at all rather than being reported. `WHEN TYPE lcl_thing` (7.02+) branches on an object's class, which is occasionally the right tool and usually a sign that the class hierarchy is missing a method.

## The operators worth knowing

`IS INITIAL` (the value is its type's initial value — not null, ABAP has no null), `IS BOUND` (a reference points at something), `IS ASSIGNED` (a field symbol points at something), `IS SUPPLIED` (an optional parameter was actually passed), `BETWEEN a AND b`, and the character-comparison family `CO`, `CN`, `CA`, `NA`, `CS`, `NS`, `CP`, `NP` — of which `CS` (contains string) and `CP` (covers pattern, with `*` and `+`) are the two that earn their keep.

## What this page still needs

- [ ] a `snippets/` program exercising `IS INITIAL` against `IS BOUND` against `IS ASSIGNED`
- [ ] the `CO`/`CA`/`CS` family with a worked example each, and `sy-fdpos`
- [ ] when `CASE TYPE OF` is right and when it is a missing method

## See also

- [`COND` and `SWITCH`](../cond_switch/README.md) — the same two choices as expressions
- [`CHECK`, `CONTINUE`, `EXIT`, `RETURN`](../check_continue_exit/README.md) — leaving early instead of nesting
- [`FIELD-SYMBOLS` and `ASSIGN`](../field_symbols/README.md) — why `IS ASSIGNED` is a different question from `IS INITIAL`
