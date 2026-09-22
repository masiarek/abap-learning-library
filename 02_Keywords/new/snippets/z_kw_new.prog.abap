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
