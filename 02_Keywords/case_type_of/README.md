# `CASE TYPE OF` and `IS INSTANCE OF` — branching on an object's class

**Level:** 301 · deep dive

**One line:** `IS INSTANCE OF` asks whether a reference points at an object of a class (or one of its subclasses, or an implementer of an interface); `CASE TYPE OF` asks the same question for several classes and **casts** in the same step, binding an `INTO` variable typed to the matching branch — and both are usually a sign that a method is missing from an interface.

## The two forms

```abap
IF lo_shape IS INSTANCE OF lcl_circle.
  DATA(lo_c) = CAST lcl_circle( lo_shape ).       " still needed
ENDIF.

CASE TYPE OF lo_shape.
  WHEN TYPE lcl_circle INTO DATA(lo_circle).      " cast done for you
    WRITE lo_circle->mv_radius.
  WHEN TYPE lcl_square INTO DATA(lo_square).
    WRITE lo_square->mv_side.
  WHEN OTHERS.
ENDCASE.
```

Both are 7.50. Before that, the test was a `TRY … CAST … CATCH cx_sy_move_cast_error`, which is the shape you will find in older code and should read as "is instance of".

Branches are tested in order, so a superclass `WHEN` placed before its subclass catches everything — the same rule as `CATCH` blocks.

## Why it is usually the wrong tool

A `CASE TYPE OF` over your own classes lists their names in a place that has to change every time a class is added. The polymorphic version — a method on the interface that each class implements — needs no such list, and the compiler checks that every class provides it. When you find yourself writing the `CASE`, the question is what the method would be called.

It earns its place at **boundaries**: over exception classes in a `CATCH` chain, over objects handed to you by a framework you do not own, in a generic tool that must handle a closed set of SAP types. There, the list of classes is not yours to extend anyway.

<!-- snippet:z_kw_case_type_of -->
*[`z_kw_case_type_of.prog.abap`](snippets/z_kw_case_type_of.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_case_type_of.

INTERFACE lif_shape.
  METHODS name RETURNING VALUE(rv_name) TYPE string.
ENDINTERFACE.

CLASS lcl_circle DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif_shape.
    DATA mv_radius TYPE i.
ENDCLASS.

CLASS lcl_circle IMPLEMENTATION.
  METHOD lif_shape~name.
    rv_name = `circle`.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_square DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif_shape.
    DATA mv_side TYPE i.
ENDCLASS.

CLASS lcl_square IMPLEMENTATION.
  METHOD lif_shape~name.
    rv_name = `square`.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA lt_shapes TYPE STANDARD TABLE OF REF TO lif_shape WITH EMPTY KEY.

  DATA(lo_c) = NEW lcl_circle( ).
  lo_c->mv_radius = 2.
  APPEND lo_c TO lt_shapes.
  DATA(lo_s) = NEW lcl_square( ).
  lo_s->mv_side = 3.
  APPEND lo_s TO lt_shapes.

  LOOP AT lt_shapes INTO DATA(lo_shape).
    " IS INSTANCE OF only asks. CASE TYPE OF asks and casts in one step: the
    " INTO variable is typed to the class of the branch, no CAST needed.
    IF lo_shape IS INSTANCE OF lcl_circle.
      WRITE: / '(a circle is coming)'.
    ENDIF.

    CASE TYPE OF lo_shape.
      WHEN TYPE lcl_circle INTO DATA(lo_circle).
        WRITE: / lo_shape->name( ), 'radius', lo_circle->mv_radius.
      WHEN TYPE lcl_square INTO DATA(lo_square).
        WRITE: / lo_shape->name( ), 'side', lo_square->mv_side.
      WHEN OTHERS.
        WRITE: / 'a shape this code has never heard of'.
    ENDCASE.
  ENDLOOP.

  " The honest note: a CASE TYPE OF over your own classes is usually a method
  " that belongs on the interface. It earns its place at boundaries -- over
  " exception classes, or objects that arrive from code you do not own.
```
<!-- /snippet -->

## If you are coming from another language

- **Java.** `instanceof` with pattern matching (`if (o instanceof Circle c)`) is exactly `CASE TYPE OF … INTO`. The design advice — prefer a virtual method — is the same.
- **Rust.** `match` on an enum is the right tool there because the set of variants is closed by definition; ABAP's class hierarchy is open, which is why the same construct is suspect here.
- **Python.** `isinstance`, with the same reputation.

## See also

- [`CAST`, `CONV` and `EXACT`](../cast_conv/README.md) — the downcast `CASE TYPE OF` performs for you
- [`INTERFACE` and `INTERFACES`](../interfaces/README.md) — the method that replaces the `CASE`
- [`IF` and `CASE`](../case_if/README.md) — the ordinary `CASE`
- [Exceptions](../../03_Topics/exceptions/README.md) — where a type dispatch is legitimate
