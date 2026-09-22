REPORT z_kw_cast_conv.

INTERFACE lif_shape.
  METHODS area RETURNING VALUE(rv_area) TYPE i.
ENDINTERFACE.

CLASS lcl_square DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif_shape.
    METHODS constructor IMPORTING iv_side TYPE i.
    METHODS side RETURNING VALUE(rv_side) TYPE i.
  PRIVATE SECTION.
    DATA mv_side TYPE i.
ENDCLASS.

CLASS lcl_square IMPLEMENTATION.
  METHOD constructor.
    mv_side = iv_side.
  ENDMETHOD.
  METHOD side.
    rv_side = mv_side.
  ENDMETHOD.
  METHOD lif_shape~area.
    rv_area = mv_side * mv_side.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  " Up the hierarchy is free: a square is a shape.
  DATA(lo_shape) = CAST lif_shape( NEW lcl_square( 3 ) ).
  WRITE: / 'area', lo_shape->area( ).

  " Down it is a claim, and CAST checks it at runtime.
  TRY.
      DATA(lo_square) = CAST lcl_square( lo_shape ).
      WRITE: / 'side', lo_square->side( ).
    CATCH cx_sy_move_cast_error.
      WRITE: / 'that object was not a square'.
  ENDTRY.

  " CONV converts a VALUE where ABAP would not convert on its own.
  DATA lv_chars TYPE c LENGTH 10 VALUE 'ABAP'.
  WRITE: / 'c len     ', strlen( lv_chars ).
  WRITE: / 'string len', strlen( CONV string( lv_chars ) ).

  " EXACT refuses a conversion that would lose something, instead of rounding.
  TRY.
      DATA(lv_ok) = EXACT i( '42' ).
      WRITE: / 'exact', lv_ok.
      DATA(lv_lossy) = EXACT i( '42.7' ).
      WRITE: / 'never reached', lv_lossy.
    CATCH cx_sy_conversion_error.
      WRITE: / '42.7 does not fit in an integer without losing something'.
  ENDTRY.
