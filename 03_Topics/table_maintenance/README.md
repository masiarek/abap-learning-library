# Table maintenance — `SM30`, the maintenance generator, and its events

**Level:** 201 · working knowledge

**Status:** stub — the mechanism is here; the worked example is not yet.

**One line:** The table maintenance generator (`SE11` → Utilities → Table Maintenance Generator) builds an `SM30` dialog for any table or view — screens, function group, authorization group — and its **events** are where a developer adds validation, defaulting or logging without writing a screen.

## The mechanism

1. Generate: choose a function group (yours), an authorization group (`S_TABU_DIS`), one-step or two-step maintenance, and screen numbers.
2. Maintain: `SM30` (or `SM31`, or a parameter transaction pointing at it) with the table name.
3. Extend: *Environment → Modification → Events* — numbered events (`01` before save, `05` on creating a new entry, `21` fill hidden fields…) each bound to a `FORM` in the generated function group.
4. Transport: customizing tables (delivery class `C`) prompt for a customizing request on save, if *Standard recording routine* was chosen.

A **maintenance view** (`SE11`, view type maintenance) over several tables gives one dialog for a header-and-items pair; a **view cluster** (`SE54`) chains dialogs with navigation.

## Why it earns a page

Because every project has a dozen `Z` customizing tables and `SM30` is the cheapest correct UI for them — with authorization, transport recording and change logging (if the technical setting is on) for free. And because the events are `FORM`s in generated code: obsolete in form, unavoidable here, and regenerated if you are not careful (they survive regeneration; the screens do not always).

## What this page still needs

- [ ] a generated dialog on a demo table, with event `01` validating a field
- [ ] the authorization object `S_TABU_DIS` / `S_TABU_NAM` and what each restricts
- [ ] the "generated screens overwritten" trap, and how to keep screen changes

## See also

- [Table types and buffering](../table_types_and_buffering/README.md) — delivery class, logging
- [Authorizations](../authorizations/README.md) — `S_TABU_DIS`
- [Transports](../transports/README.md) — customizing requests
- [`FORM` and `PERFORM`](../../02_Keywords/perform_form/README.md) — the event routines' shape
