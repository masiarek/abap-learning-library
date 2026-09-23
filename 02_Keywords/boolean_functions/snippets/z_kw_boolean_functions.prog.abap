REPORT z_kw_boolean_functions.

DATA(lv_qty) = 3.

" There is no boolean TYPE. abap_bool is a one-character c; abap_true is 'X'
" and abap_false is ' ' -- constants from the type pool ABAP, and the
" convention every SAP interface uses.
DATA lv_flag TYPE abap_bool.

" xsdbool( ) turns a logical expression into that convention, as a value.
lv_flag = xsdbool( lv_qty > 0 ).
WRITE: / 'positive:', lv_flag.

" boolc( ) does the same and returns a STRING. The documented catch: a false
" boolc( ) is a one-blank string, and comparing it with abap_false is not the
" comparison it looks like. This program reports what your system does.
DATA(lv_text) = boolc( lv_qty > 100 ).
IF lv_text = abap_false.
  WRITE: / 'boolc( false ) = abap_false held on this system'.
ELSE.
  WRITE: / 'boolc( false ) = abap_false did NOT hold -- use xsdbool( )'.
ENDIF.

" A predicate function is tested directly; no flag variable is needed.
DATA(lt_names) = VALUE string_table( ( `Ada` ) ).
IF line_exists( lt_names[ 1 ] ) AND lv_flag = abap_true.
  WRITE: / 'predicate and flag, in one condition'.
ENDIF.

" A flag passed to a method that expects abap_bool: xsdbool( ) keeps the call
" a single expression instead of an IF that sets a variable first.
WRITE: / 'is initial:', xsdbool( lt_names IS INITIAL ).
