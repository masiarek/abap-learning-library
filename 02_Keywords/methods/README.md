# `METHODS` and its parameters — `IMPORTING`, `EXPORTING`, `CHANGING`, `RETURNING`

**Level:** 201 · working knowledge

**Status:** stub — the shape is here; the worked program is not yet.

**One line:** ABAP names the direction of every parameter, and the one to prefer is `RETURNING` — a method with a single returning parameter can be called inside an expression, while one with `EXPORTING` parameters cannot, which quietly decides how the rest of your code reads.

## What it does

```abap
METHODS net_of_tax
  IMPORTING iv_gross      TYPE ty_amount
            iv_rate       TYPE ty_amount OPTIONAL
  RETURNING VALUE(rv_net) TYPE ty_amount
  RAISING   zcx_bad_rate.
```

| Direction | Means | Notes |
|---|---|---|
| `IMPORTING` | in | read-only inside the method |
| `EXPORTING` | out | cleared on entry — an unset one comes back initial |
| `CHANGING` | in and out | the caller's variable, modified |
| `RETURNING` | out, as a value | at most one, must be `VALUE(…)`, makes the call an expression |

`OPTIONAL` allows omission and `IS SUPPLIED` tests for it; `DEFAULT` supplies a value instead. `PREFERRED PARAMETER` names the one that may be passed positionally.

## The part that shapes your code

`DATA(lv_net) = lo_calc->net_of_tax( iv_gross = … ).` is possible only because the result is `RETURNING`. With `EXPORTING`, every call needs its own statement and its own variable declared first, and the method can never appear inside a [`COND`](../cond_switch/README.md), a [`VALUE`](../value/README.md) or a [string template](../string_templates/README.md). Two or three such methods are enough to make a whole module read like 1998.

By value or by reference matters too: `VALUE(…)` copies, the default for `IMPORTING` and `CHANGING` is by reference. A large table passed by reference costs nothing; the same table returned `VALUE(…)` is copied on every call.

## What this page still needs

- [ ] a `snippets/` program contrasting an `EXPORTING` API with a `RETURNING` one at the call site
- [ ] `IS SUPPLIED` versus `OPTIONAL` versus `DEFAULT`, worked through
- [ ] the cost of `VALUE(…)` on a large internal table, measured rather than asserted

## See also

- [`CLASS`](../class/README.md) — where methods live
- [`INTERFACE` and `INTERFACES`](../interfaces/README.md) — the same signatures, as a contract
- [`CALL FUNCTION`](../call_function/README.md) — the function-module equivalents, and `TABLES`
- [Clean ABAP](../../03_Topics/clean_abap/README.md) — the argument for few parameters and one return
