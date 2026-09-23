# `CLASS` — definition, implementation, and what is visible from where

**Level:** 201 · working knowledge

**One line:** An ABAP class is written twice — `CLASS … DEFINITION` says what exists and `CLASS … IMPLEMENTATION` says how — with three visibility sections that mean what they do elsewhere, `CLASS-METHODS` for static members, and a factory method as the idiomatic way to keep a caller from depending on the class name forever.

## The two halves

```abap
CLASS lcl_plain DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif_greeter.
    CLASS-METHODS create RETURNING VALUE(ro_greeter) TYPE REF TO lif_greeter.
  PROTECTED SECTION.
    METHODS salutation RETURNING VALUE(rv_word) TYPE string.
ENDCLASS.

CLASS lcl_plain IMPLEMENTATION.
  METHOD salutation.
    rv_word = `Hello`.
  ENDMETHOD.
ENDCLASS.
```

The split is not a header file: both halves live in the same source, and the compiler checks that every method defined is implemented. The order of the sections is fixed — `PUBLIC`, then `PROTECTED`, then `PRIVATE` — and a method's visibility is declared in the section it is written in, not on the method.

**Local versus global.** `lcl_…` classes live inside one program and are invisible outside it; a global class is its own repository object (`SE24` or ADT), named `ZCL_…`, and reusable everywhere. Local classes are the right place for a helper that belongs to one report — including the test class, which is also local. See [ABAP Unit](../../03_Topics/abap_unit/README.md).

## Static members

`CLASS-METHODS` and `CLASS-DATA` belong to the class rather than to any instance and are called with `=>` instead of `->`: `lcl_plain=>create( )`. `CLASS-DATA` is shared by everything in the session — convenient for a cache, and the reason a static that holds state is the first thing to suspect when a job behaves differently on the second run.

## Inheritance, and why interfaces usually win

```abap
CLASS lcl_loud DEFINITION INHERITING FROM lcl_plain.
  PROTECTED SECTION.
    METHODS salutation REDEFINITION.
ENDCLASS.
```

`REDEFINITION` overrides; `super->salutation( )` calls the version above. It works, and it ties the subclass to the superclass's internals forever. An `INTERFACES` declaration gives the same polymorphism without the coupling, which is why the factory above returns `REF TO lif_greeter` rather than `REF TO lcl_plain` — the caller depends on the contract, not the class. See [`INTERFACE` and `INTERFACES`](../interfaces/README.md).

`FINAL` on a class means nobody may inherit from it. It is a reasonable default for a class you did not design to be extended.

## The constructor

`METHODS constructor IMPORTING …` runs when the object is created with [`NEW`](../new/README.md). There is also `CLASS-CONSTRUCTOR`, which runs once, the first time the class is touched in a session — a good place for genuinely constant setup, and a bad place for anything that can fail or read the database, because you cannot predict when it runs.

A constructor that does work is a constructor that can fail in a caller that did not expect it. A factory method can validate, return a different implementation, or raise a proper exception — which is why `create( )` is the shape shown here.

<!-- snippet:z_kw_class -->
*[`z_kw_class.prog.abap`](snippets/z_kw_class.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_class.

INTERFACE lif_greeter.
  METHODS greet IMPORTING iv_name        TYPE string
                RETURNING VALUE(rv_text) TYPE string.
ENDINTERFACE.

CLASS lcl_plain DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif_greeter.
    " A factory method instead of a public constructor: the class decides how
    " it is built, and the caller is not tied to the class name forever.
    CLASS-METHODS create RETURNING VALUE(ro_greeter) TYPE REF TO lif_greeter.
    CLASS-DATA gv_created TYPE i READ-ONLY.
  PROTECTED SECTION.
    METHODS salutation RETURNING VALUE(rv_word) TYPE string.
ENDCLASS.

CLASS lcl_plain IMPLEMENTATION.
  METHOD create.
    ro_greeter = NEW lcl_plain( ).
    gv_created = gv_created + 1.
  ENDMETHOD.
  METHOD salutation.
    rv_word = `Hello`.
  ENDMETHOD.
  METHOD lif_greeter~greet.
    rv_text = |{ salutation( ) }, { iv_name }!|.
  ENDMETHOD.
ENDCLASS.

" Inheritance: only the difference is written down. REDEFINITION needs the
" method to be non-final in the superclass, and PROTECTED is what makes it
" visible here at all.
CLASS lcl_loud DEFINITION INHERITING FROM lcl_plain.
  PROTECTED SECTION.
    METHODS salutation REDEFINITION.
ENDCLASS.

CLASS lcl_loud IMPLEMENTATION.
  METHOD salutation.
    rv_word = |{ super->salutation( ) CASE = UPPER }|.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  " Both objects are used through the interface, so the code below does not
  " know or care which class it got.
  DATA lt_greeters TYPE STANDARD TABLE OF REF TO lif_greeter WITH EMPTY KEY.
  APPEND lcl_plain=>create( ) TO lt_greeters.
  APPEND NEW lcl_loud( ) TO lt_greeters.

  LOOP AT lt_greeters INTO DATA(lo_greeter).
    WRITE: / lo_greeter->greet( `Ada` ).
  ENDLOOP.

  WRITE: / 'objects made by the factory:', lcl_plain=>gv_created.
```
<!-- /snippet -->

## If you are coming from another language

- **Java / C#.** Almost everything transfers: visibility, `static`, `final`, constructors, single inheritance plus multiple interfaces. The surprises are the two-part declaration, `=>` versus `->`, and the absence of `null` — ABAP tests references with `IS BOUND`.
- **Python.** No decorators, no multiple inheritance, no duck typing: a method is callable only if the *static type* of the reference declares it.
- **Rust.** `INTERFACES` is `trait`, `REDEFINITION` is a default trait method being overridden, and ABAP's implementation inheritance has no Rust equivalent by design.

## See also

- [`INTERFACE` and `INTERFACES`](../interfaces/README.md) — the contract, and the `~` that names a method through it
- [`METHODS` and parameters](../methods/README.md) — `IMPORTING`, `RETURNING`, and which to use
- [`NEW`](../new/README.md) — creating the instance
- [Object-oriented ABAP](../../03_Topics/oo_abap/README.md) — when a report should be a class at all
- [ABAP Unit](../../03_Topics/abap_unit/README.md) — the local test class, and the design it pushes you towards
- [Events](../events/README.md) — `EVENTS`, `RAISE EVENT`, `SET HANDLER`
- [The class additions](../friends_aliases_abstract/README.md) — `FRIENDS`, `ALIASES`, `ABSTRACT`, `FINAL`
- [`CASE TYPE OF`](../case_type_of/README.md) — branching on an object's class, and when not to
- [`STATICS`](../statics/README.md) — a local variable that survives between calls
