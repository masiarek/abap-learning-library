# `MOVE`, `ADD`, `SUBTRACT`, `COMPUTE` — the obsolete statements

**Level:** 101 · newcomer

**Status:** stub — for recognition; the worked example is deliberately absent.

**One line:** `MOVE a TO b.`, `ADD 1 TO n.`, `SUBTRACT`, `MULTIPLY`, `DIVIDE` and `COMPUTE x = y + z.` are the statement spellings of assignment and arithmetic from before operators existed — every one of them is `=` today, they are flagged as obsolete by the ATC and by this library's linter, and you will read them in every report older than you are.

## Recognition table

| You read | It means |
|---|---|
| `MOVE lv_a TO lv_b.` | `lv_b = lv_a.` |
| `MOVE-CORRESPONDING` | **not** obsolete — see [`CORRESPONDING`](../corresponding/README.md) |
| `ADD 1 TO lv_n.` | `lv_n = lv_n + 1.` |
| `SUBTRACT 1 FROM lv_n.` | `lv_n = lv_n - 1.` |
| `MULTIPLY lv_n BY 2.` / `DIVIDE lv_n BY 2.` | `lv_n = lv_n * 2.` / `lv_n = lv_n / 2.` |
| `COMPUTE lv_x = lv_y + lv_z.` | `lv_x = lv_y + lv_z.` — `COMPUTE` was always optional |
| `ADD-CORRESPONDING`, `ADD … THEN … UNTIL …` | the truly odd relatives; look them up when you meet them |
| `CLEAR lv WITH 'X'.` | fill with a character; a rare form worth recognising |

`MOVE … TO` also had `?TO` for a checked downcast of references, which [`CAST`](../cast_conv/README.md) replaced.

## The one honest note

None of these is wrong. A `ADD 1 TO lv_count.` does exactly what it says and always will. They are on this shelf because a reader fluent in `=` stumbles on them, because the ATC reports them, and because ABAP Cloud refuses some of them — not because they misbehave. Do not convert them in a bug-fix commit; do convert them when the module is being reworked anyway. See [Clean ABAP](../../03_Topics/clean_abap/README.md).

## What this page still needs

- [ ] an old-style block beside its rewrite (shown, not linted — abaplint refuses the obsolete forms, which proves the point)
- [ ] the exact ATC and abaplint messages, recorded

## See also

- [Obsolete declarations](../obsolete_declarations/README.md) — the declarations on the same shelf
- [`DATA` — and `DATA( )`](../data/README.md) — assignment today
- [Numeric functions and operators](../numeric_functions/README.md) — arithmetic today
- [Modern versus classic](../../03_Topics/modern_vs_classic/README.md) — the whole rewrite table
