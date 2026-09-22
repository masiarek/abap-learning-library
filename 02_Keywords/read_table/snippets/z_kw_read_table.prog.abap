REPORT z_kw_read_table.

TYPES: BEGIN OF ty_row,
         id   TYPE i,
         name TYPE string,
       END OF ty_row.
TYPES ty_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

DATA(lt_rows) = VALUE ty_tab( ( id = 1 name = `Ada` )
                              ( id = 2 name = `Grace` )
                              ( id = 3 name = `Katherine` ) ).

" The statement form reports through sy-subrc, and says nothing if you forget
" to look. The work area keeps its previous contents when the read misses.
READ TABLE lt_rows INTO DATA(ls_hit) WITH KEY id = 2.
IF sy-subrc = 0.
  WRITE: / 'found', ls_hit-name.
ENDIF.

" The expression form has no sy-subrc: a miss is an exception.
TRY.
    DATA(ls_two) = lt_rows[ id = 2 ].
    WRITE: / 'expr ', ls_two-name.
    DATA(ls_gone) = lt_rows[ id = 99 ].
    WRITE: / 'never reached', ls_gone-name.
  CATCH cx_sy_itab_line_not_found.
    WRITE: / 'no row with id 99'.
ENDTRY.

" OPTIONAL turns a miss into an initial row; DEFAULT into a row you choose.
DATA(ls_opt) = VALUE #( lt_rows[ id = 99 ] OPTIONAL ).
DATA(ls_def) = VALUE #( lt_rows[ id = 99 ] DEFAULT lt_rows[ 1 ] ).

" Asking first costs a second search, so prefer it for a test, not for a read.
IF line_exists( lt_rows[ id = 3 ] ).
  WRITE: / 'index', line_index( lt_rows[ id = 3 ] ).
ENDIF.

" ASSIGNING reads without copying the row.
READ TABLE lt_rows ASSIGNING FIELD-SYMBOL(<ls_first>) INDEX 1.
IF <ls_first> IS ASSIGNED.
  WRITE: / 'first', <ls_first>-name.
ENDIF.

WRITE: / 'opt id', ls_opt-id.
WRITE: / 'def   ', ls_def-name.
