REPORT z_tp_itab_kinds.

TYPES: BEGIN OF ty_row,
         id     TYPE i,
         region TYPE string,
         name   TYPE string,
       END OF ty_row.

" The three kinds are three different promises about lookup, order and duplicates.
TYPES ty_standard TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
TYPES ty_sorted   TYPE SORTED   TABLE OF ty_row WITH UNIQUE KEY id.
TYPES ty_hashed   TYPE HASHED   TABLE OF ty_row WITH UNIQUE KEY id.

" A secondary key buys a fast lookup on a table that still keeps insertion
" order for everything else. The cost is paid on every change to the table.
TYPES ty_both TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY
              WITH NON-UNIQUE SORTED KEY by_region COMPONENTS region.

DATA(lt_std)    = VALUE ty_standard( ( id = 2 region = `EU` name = `Grace` )
                                     ( id = 1 region = `US` name = `Ada` ) ).
DATA lt_sorted TYPE ty_sorted.
DATA lt_hashed TYPE ty_hashed.
DATA lt_both   TYPE ty_both.

" A sorted table keeps itself in key order: INSERT ... INTO TABLE, never APPEND.
INSERT LINES OF lt_std INTO TABLE lt_sorted.
INSERT LINES OF lt_std INTO TABLE lt_hashed.
INSERT LINES OF lt_std INTO TABLE lt_both.

" Reading by the full key: the hashed table gets there in one step whatever the
" table's size; the sorted table halves the search; the standard table walks.
DATA(ls_hash) = VALUE #( lt_hashed[ id = 1 ] OPTIONAL ).
DATA(ls_sort) = VALUE #( lt_sorted[ id = 1 ] OPTIONAL ).
DATA(ls_walk) = VALUE #( lt_std[ id = 1 ]    OPTIONAL ).

" The secondary key is named explicitly, or the read falls back to the walk.
DATA(ls_by_region) = VALUE #( lt_both[ KEY by_region region = `EU` ] OPTIONAL ).

WRITE: / 'hashed  ', ls_hash-name.
WRITE: / 'sorted  ', ls_sort-name.
WRITE: / 'standard', ls_walk-name.
WRITE: / 'secondary key', ls_by_region-name.

" A hashed table has no index at all: reading by position is a syntax error,
" and that is the point -- there is no position to read.
LOOP AT lt_hashed INTO DATA(ls_any).
  WRITE: / 'hashed row', ls_any-id, ls_any-name.
ENDLOOP.
