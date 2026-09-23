# `DEFINE` — macros

**Level:** 201 · working knowledge

**Status:** stub — read for recognition; the worked example is not yet.

**One line:** `DEFINE name. … END-OF-DEFINITION.` declares a textual macro with up to nine positional placeholders `&1`…`&9`, expanded at compile time wherever `name` is used — it saves keystrokes, cannot be debugged (the debugger steps over the whole expansion), and SAP's guidelines say not to write new ones.

## What it does

```abap
DEFINE write_pair.
  WRITE: / &1, &2.
END-OF-DEFINITION.

write_pair 'total' lv_total.
write_pair 'count' lv_count.
```

Expansion is text substitution. There is no type, no scope, no return, and no breakpoint inside a macro — a runtime error inside one is reported at the line of the *use*. Macros can call macros; they cannot be recursive.

## Why it is still here

SAP's own type pools carried macros for years (`ABAP` itself has none, but many older ones do), and old reports use them for repeated `WRITE` and `CLEAR` sequences. Reading them is a skill; writing a new one is what a method, or a [string template](../string_templates/README.md), does better.

## What this page still needs

- [ ] a `snippets/` program showing a macro, and the same thing as a method
- [ ] the ATC finding a new macro triggers, recorded
- [ ] where SAP's own code still relies on macros, so a reader recognises them

## See also

- [Obsolete declarations](../obsolete_declarations/README.md) — the rest of the "read, do not write" shelf
- [`METHODS` and parameters](../methods/README.md) — the replacement
- [Debugging](../../03_Topics/debugging/README.md) — why a macro is invisible there
- [Clean ABAP](../../03_Topics/clean_abap/README.md) — the guideline
