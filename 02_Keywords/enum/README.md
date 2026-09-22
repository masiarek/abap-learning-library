# Enumerations — `TYPES BEGIN OF ENUM`

**Level:** 301 · deep dive

**Status:** stub — the shape is here; the worked program is not yet.

**One line:** Since 7.51 ABAP has a real enumerated type whose values the compiler enforces — you cannot assign an arbitrary value to an enum variable — which is the check the traditional structured `CONSTANTS` block never had.

## What it does

```abap
TYPES: BEGIN OF ENUM ty_status,
         open,
         paid,
         cancelled,
       END OF ENUM ty_status.

DATA lv_status TYPE ty_status.
lv_status = paid.          " fine
" lv_status = 42.          " syntax error, which is the whole point
```

`BEGIN OF ENUM … STRUCTURE gc_status` additionally groups the constants into a structure, so they can be referred to as `gc_status-paid`. The underlying type is `i` by default and can be a character type with `BASE TYPE`, which matters when the values must match something stored in the database.

## Why it earns a page, and why it is rare

The enum type is checked. The structured `CONSTANTS` block that ABAP used for twenty years is not:

```abap
CONSTANTS: BEGIN OF gc_status,
             open TYPE string VALUE `OPEN`,
           END OF gc_status.
```

Nothing stops a variable typed `string` from holding `` `OEPN` ``. The enum makes that a syntax error — at the cost of a type that cannot hold a value read from the database without an explicit conversion, which is exactly the boundary you want the conversion at, and exactly the friction that keeps enums rarer in ABAP than they deserve to be.

## What this page still needs

- [ ] a `snippets/` program with an enum, a `BASE TYPE`, and the conversion at a database boundary
- [ ] what happens in a `CASE` over an enum when a value is added later
- [ ] the release check: 7.51 is required, which rules out plenty of systems

## See also

- [`TYPES` and `CONSTANTS`](../types/README.md) — the structured constant this replaces
- [`COND` and `SWITCH`](../cond_switch/README.md) — branching over the values, and the missing `ELSE`
- [Which release am I writing for?](../../03_Topics/releases_and_syntax_levels/README.md) — 7.51, and what to do below it
- [DDIC, domains and data elements](../../03_Topics/ddic_and_domains/README.md) — the Dictionary's own fixed-value lists
