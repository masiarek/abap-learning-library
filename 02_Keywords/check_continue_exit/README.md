# `CHECK`, `CONTINUE`, `EXIT`, `RETURN` — four ways out, and two of them surprise people

**Level:** 201 · working knowledge

**Status:** stub — the table is here; the worked program is not yet.

**One line:** `CONTINUE` skips to the next loop pass, `EXIT` leaves the loop, `RETURN` leaves the whole method or program, and `CHECK` does something different depending on **where it stands** — which is why it is the one to be careful with.

## The table that settles it

| Statement | Inside a loop | Outside a loop |
|---|---|---|
| `CONTINUE` | next pass | syntax error |
| `EXIT` | leaves the loop | leaves the processing block (behaves like `RETURN`) |
| `RETURN` | leaves the whole method/block, loop and all | leaves the method/block |
| `CHECK cond` | false → next pass (like `CONTINUE`) | false → leaves the processing block |

`CHECK` reads as "verify this" but means "carry on only if"; a `CHECK` at the top of a method is an early return with no `IF` around it, and a `CHECK` in a loop silently skips rows. Both are legitimate. Both are misread regularly, and [Clean ABAP](../../03_Topics/clean_abap/README.md) argues for an explicit `IF … RETURN.` on that basis.

`EXIT` is the sharper one: outside a loop it does **not** mean "exit the program" — it leaves the current processing block, which in a `FORM` or a method is a return. `EXIT` inside a `SELECT … ENDSELECT` also closes the cursor, which is one of the few places it is exactly right.

## What this page still needs

- [ ] a `snippets/` program showing each of the four in and out of a loop
- [ ] the interaction of `CHECK` with `AT SELECTION-SCREEN`, where it is idiomatic
- [ ] `STOP` and `LEAVE`, the two older relatives, and why they are not on this list

## See also

- [`LOOP AT`](../loop_at/README.md) — the loop these statements steer
- [`DO` and `WHILE`](../do_while/README.md) — the counting loops
- [`IF` and `CASE`](../case_if/README.md) — the explicit form to prefer
- [Clean ABAP](../../03_Topics/clean_abap/README.md) — the style argument about `CHECK`
