# `INTERFACE` and `INTERFACES` — the contract, and the tilde

**Level:** 201 · working knowledge

**Status:** stub — the shape is here; the worked program is not yet.

**One line:** An interface declares methods without implementing them, a class takes it on with `INTERFACES lif_x.` and implements each method as `lif_x~method`, and a reference typed to the interface is how code stops depending on which class it was handed.

## What it does

```abap
INTERFACE lif_shape.
  METHODS area RETURNING VALUE(rv_area) TYPE i.
ENDINTERFACE.

CLASS lcl_square DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif_shape.
ENDCLASS.

CLASS lcl_square IMPLEMENTATION.
  METHOD lif_shape~area.
    rv_area = mv_side * mv_side.
  ENDMETHOD.
ENDCLASS.
```

The `~` is ABAP's way of saying "this method, seen through that interface". It appears in the implementation, and in a call when a class has a method of its own with the same name. `ALIASES area FOR lif_shape~area.` gives it a plain name on the class.

A class may implement any number of interfaces — this is how ABAP gets multiple inheritance of *contract* while keeping single inheritance of *implementation*.

## Why it earns a page

A reference typed `REF TO lif_shape` can hold any implementation, which is what makes a test double possible: the test passes its own class implementing the same interface, and the code under test cannot tell. Without an interface, the dependency is on a concrete class, and the test needs the real thing — which usually means the real database. That single consequence is why [ABAP Unit](../../03_Topics/abap_unit/README.md) and interfaces are the same conversation.

Interfaces can also hold `CONSTANTS`, `TYPES` and `DATA`, and can extend other interfaces. A constant on an interface is a common way to publish a set of allowed values next to the contract that uses them.

## What this page still needs

- [ ] a `snippets/` program with two implementations behind one interface reference
- [ ] `ALIASES`, and when the `~` form should be left visible
- [ ] interface composition, and what happens to a method name inherited twice

## See also

- [`CLASS`](../class/README.md) — the implementing side, and why a factory returns the interface
- [`METHODS` and parameters](../methods/README.md) — what the contract's methods look like
- [ABAP Unit](../../03_Topics/abap_unit/README.md) — the test double an interface makes possible
- [Object-oriented ABAP](../../03_Topics/oo_abap/README.md) — the design argument
