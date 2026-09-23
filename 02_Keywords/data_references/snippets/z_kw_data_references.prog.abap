REPORT z_kw_data_references.

DATA lv_total TYPE i VALUE 10.

" REF #( ) takes a reference to a variable that already exists. No copy: the
" reference and the variable are the same memory.
DATA(lr_total) = REF #( lv_total ).
lr_total->* = lr_total->* + 5.
WRITE: / 'via the reference', lv_total.

" NEW allocates a fresh, anonymous object; the reference is its only name.
DATA(lr_fresh) = NEW i( 42 ).
WRITE: / 'anonymous', lr_fresh->*.

" A reference to a structure reaches its components with ->.
TYPES: BEGIN OF ty_row,
         id   TYPE i,
         name TYPE string,
       END OF ty_row.
DATA(lr_row) = NEW ty_row( id = 1 name = `Ada` ).
WRITE: / lr_row->id, lr_row->name.

" REF TO data holds anything -- and gives nothing back without a cast or a
" field symbol, because the compiler no longer knows what is behind it.
DATA lr_any TYPE REF TO data.
lr_any = lr_row.
FIELD-SYMBOLS <ls_row> TYPE ty_row.
ASSIGN lr_any->* TO <ls_row>.
WRITE: / 'through REF TO data', <ls_row>-name.

" IS BOUND is the test. Dereferencing an unbound reference is a short dump.
DATA lr_unset TYPE REF TO i.
IF lr_unset IS NOT BOUND.
  WRITE: / 'unbound, and tested before use'.
ENDIF.

" A reference into a table row stays valid as long as the row does, which is
" how a LOOP ... REFERENCE INTO keeps hold of a row after the loop ends.
DATA lt_rows TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
APPEND lr_row->* TO lt_rows.
LOOP AT lt_rows REFERENCE INTO DATA(lr_kept).
  lr_kept->name = to_upper( lr_kept->name ).
ENDLOOP.
WRITE: / 'kept after the loop', lr_kept->name.
