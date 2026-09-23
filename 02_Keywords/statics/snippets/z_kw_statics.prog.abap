REPORT z_kw_statics.

CLASS lcl_counter DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS next RETURNING VALUE(rv_n) TYPE i.
    CLASS-METHODS next_visible RETURNING VALUE(rv_n) TYPE i.
  PRIVATE SECTION.
    CLASS-DATA gv_calls TYPE i.
ENDCLASS.

CLASS lcl_counter IMPLEMENTATION.
  METHOD next.
    " STATICS is declared like DATA, initialised ONCE, and keeps its value
    " between calls: a local name with a global lifetime. Nothing outside this
    " method can see it, which is both the point and the problem.
    STATICS sv_calls TYPE i.
    sv_calls = sv_calls + 1.
    rv_n = sv_calls.
  ENDMETHOD.

  METHOD next_visible.
    " The same behaviour with CLASS-DATA: the state is declared where a
    " reader will look for it, and a test can reset it.
    gv_calls = gv_calls + 1.
    rv_n = gv_calls.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  WRITE: / 'statics   ', lcl_counter=>next( ).
  WRITE: / 'statics   ', lcl_counter=>next( ).
  WRITE: / 'statics   ', lcl_counter=>next( ).
  WRITE: / 'class-data', lcl_counter=>next_visible( ).
  WRITE: / 'class-data', lcl_counter=>next_visible( ).
