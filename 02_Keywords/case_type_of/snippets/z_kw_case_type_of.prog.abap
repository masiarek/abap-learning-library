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
