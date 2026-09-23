# `NEW` — an object, in one expression

**Level:** 201 · working knowledge

**One line:** `NEW lcl_thing( … )` creates an instance and returns the reference, replacing `CREATE OBJECT` plus its separate `DATA` declaration — and it builds data references too, which is how you get a reference to a plain integer or a table.

## Instead of two statements

```abap
" before 7.40
DATA lo_counter TYPE REF TO lcl_counter.
CREATE OBJECT lo_counter EXPORTING iv_start = 10.

" 7.40 onward
DATA(lo_counter) = NEW lcl_counter( iv_start = 10 ).
```

The type of `lo_counter` is inferred from the class being instantiated. Parameters are passed the way a method call passes them: named, or positionally when there is exactly one and no ambiguity — `NEW lcl_counter( 0 )`.

`NEW #( … )` is the same expression with the type taken from the context, which is what you write when appending to a typed table of references or passing to a typed parameter.

## Data references, not only objects

```abap
DATA(lr_number) = NEW i( 42 ).
WRITE lr_number->*.
```

`NEW i( )` allocates an integer on the heap and hands back a `REF TO i`. The `->*` dereferences it. This is the expression form of `CREATE DATA`, and it is how generic containers get built — a table of `REF TO data` can hold rows of any type at all, which [Dynamic programming](../../03_Topics/dynamic_programming/README.md) needs and ordinary code should not.

## What it does not do

`NEW` does not check whether an object already exists, and it has no concept of a shared instance. A `NEW` inside a loop makes one object per pass, all of them alive as long as something references them. For "one instance, reused", write a factory method or a singleton and let the class decide — see [`CLASS`](../class/README.md), where the factory is the shape shown.

The constructor is called during the expression, so a constructor that raises an exception aborts it. A `NEW` inside a `VALUE` inside a `FOR` can therefore fail halfway through building a table, leaving nothing — which is usually what you want, and always worth knowing.

<!-- snippet:z_kw_new -->
*[`z_kw_new.prog.abap`](snippets/z_kw_new.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_new.

CLASS lcl_counter DEFINITION.
  PUBLIC SECTION.
    METHODS constructor IMPORTING iv_start TYPE i DEFAULT 0.
    METHODS tick RETURNING VALUE(rv_value) TYPE i.
  PRIVATE SECTION.
    DATA mv_value TYPE i.
ENDCLASS.

CLASS lcl_counter IMPLEMENTATION.
  METHOD constructor.
    mv_value = iv_start.
  ENDMETHOD.
  METHOD tick.
    mv_value = mv_value + 1.
    rv_value = mv_value.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  " NEW is CREATE OBJECT plus the declaration, as one expression. The type of
  " lo_counter is inferred from the class being created.
  DATA(lo_counter) = NEW lcl_counter( iv_start = 10 ).
  WRITE: / lo_counter->tick( ).
  WRITE: / lo_counter->tick( ).

  " A single unnamed argument goes in positionally.
  DATA(lo_from_zero) = NEW lcl_counter( 0 ).
  WRITE: / lo_from_zero->tick( ).

  " NEW also builds a data reference, not only an object.
  DATA(lr_number) = NEW i( 42 ).
  WRITE: / lr_number->*.
```
<!-- /snippet -->

## If you are coming from another language

- **Java / C#.** `new Thing(…)`, including the constructor call and the reference semantics. ABAP has no `null` keyword: an unbound reference is tested with `IS BOUND` / `IS NOT BOUND`, and dereferencing one is a short dump.
- **Python.** `Thing(…)`. Python's garbage collection and ABAP's are both reference-based at the language level; ABAP references die when the last one goes out of scope.
- **Rust.** `Box::new(…)` is closer than it looks — `NEW i( 42 )` is a heap allocation with a reference to it. ABAP has no ownership rules, so nothing stops two references from sharing.

## See also

- [`CLASS`](../class/README.md) — what you are instantiating, and the factory that often should be
- [`CAST`, `CONV` and `EXACT`](../cast_conv/README.md) — what to do with the reference afterwards
- [`VALUE`](../value/README.md) — the same family, for structures and tables
- [Object-oriented ABAP](../../03_Topics/oo_abap/README.md) — when a program should be a class at all
- [Data references](../data_references/README.md) — `REF`, `REF TO data`, `->*`
- [Constructor expressions](../../03_Topics/constructor_expressions/README.md) — the `VALUE`/`NEW`/`COND` family as a family
