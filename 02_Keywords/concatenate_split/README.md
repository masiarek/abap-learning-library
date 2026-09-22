# `CONCATENATE` and `SPLIT` — the statements, and what replaced one of them

**Level:** 201 · working knowledge

**Status:** stub — the shape is here; the worked program is not yet.

**One line:** `CONCATENATE a b INTO c` still works and has been largely replaced by `&&` and [string templates](../string_templates/README.md), while `SPLIT … INTO TABLE` has no expression equivalent at all and remains the normal way to cut text apart.

## What it does

```abap
CONCATENATE lv_a lv_b INTO lv_c SEPARATED BY space.
SPLIT lv_line AT `,` INTO TABLE DATA(lt_parts).
SPLIT lv_line AT `,` INTO lv_first lv_second.
```

`SEPARATED BY` is the addition worth remembering; without it the parts are joined with nothing between them, and the trailing blanks of a `c` field are **dropped** on the way in — the behaviour that differs from `&&` and surprises people who switch between the two.

`SPLIT … INTO` with a fixed list of targets silently discards anything past the last one. `SPLIT … INTO TABLE` keeps everything, which is almost always what was meant.

## The modern relatives

``concat_lines_of( table = lt sep = `,` )`` is the inverse of `SPLIT … INTO TABLE` as an expression. `segment( val = … index = … sep = … )` picks one piece without building a table. Both are functions, so they compose; the statements do not.

## What this page still needs

- [ ] a `snippets/` program comparing `CONCATENATE`, `&&` and a template on `c` fields with trailing blanks
- [ ] `SPLIT` against a multi-character separator, and against a regular expression
- [ ] the empty-string edge cases: what `SPLIT` makes of an empty string, and of `a,,b`

## See also

- [String templates](../string_templates/README.md) — the usual replacement for `CONCATENATE`
- [Strings and text](../../03_Topics/strings_and_text/README.md) — the whole function library, and `string` versus `c`
- [`FIND` and `REPLACE`](../find_replace/README.md) — searching rather than cutting
