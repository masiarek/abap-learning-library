# Object-oriented ABAP — why a report should still be a class

**Level:** 201 · working knowledge

**Status:** stub — the argument is here; the worked example is not yet.

**One line:** ABAP Objects has been in the language since 4.6 and is now the only part of it that is fully supported in new development — and the practical reason to use classes in a report that nobody will ever subclass is not purity, it is that a class can be tested, and a `START-OF-SELECTION` cannot.

## The shape of a modern report

```abap
REPORT z_something.

PARAMETERS p_bukrs TYPE bukrs.

CLASS lcl_app DEFINITION.
  PUBLIC SECTION.
    METHODS run IMPORTING iv_bukrs TYPE bukrs.
ENDCLASS.
" ... implementation ...

START-OF-SELECTION.
  NEW lcl_app( )->run( p_bukrs ).
```

Three lines of ceremony buy: local variables that are actually local, methods small enough to name, a place for a [unit test](../abap_unit/README.md) to attach, and a program that can later become a global class without being rewritten.

## The design pressure worth knowing

- **Separate deciding from fetching.** A method that both selects and calculates can only be tested against a database.
- **Depend on an [interface](../../02_Keywords/interfaces/README.md), not a class**, wherever a test or a second implementation is plausible.
- **Prefer composition to inheritance.** ABAP allows single inheritance and any number of interfaces, and the deep hierarchies written in the 2000s are the ones nobody dares touch now.
- **Static state is session state.** `CLASS-DATA` survives between calls within a session, which makes it a cache and a source of "works the first time" bugs.

## What this page still needs

- [ ] a worked before/after: a procedural report and the same logic as a class with tests
- [ ] the object lifecycle: garbage collection, `IS BOUND`, and what keeps an object alive
- [ ] `CL_ABAP_*` design patterns already in the system worth reusing rather than reinventing
- [ ] events (`EVENTS`, `RAISE EVENT`, `SET HANDLER`), which nothing else in this library covers yet

## See also

- [`CLASS`](../../02_Keywords/class/README.md) — the syntax, with a program
- [`INTERFACE` and `INTERFACES`](../../02_Keywords/interfaces/README.md) — contracts and test seams
- [ABAP Unit](../abap_unit/README.md) — the payoff
- [Modularization](../modularization/README.md) — what classes replaced, and what is still around
- [Clean ABAP](../clean_abap/README.md) — SAP's own guidance, which assumes all of the above
- [Events](../../02_Keywords/events/README.md) — `EVENTS`, `RAISE EVENT`, `SET HANDLER`
- [The class additions](../../02_Keywords/friends_aliases_abstract/README.md) — `FRIENDS`, `ALIASES`, `ABSTRACT`, `FINAL`
- [`CASE TYPE OF`](../../02_Keywords/case_type_of/README.md) — branching on an object's class, and when not to
