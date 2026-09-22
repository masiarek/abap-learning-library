REPORT z_kw_itab_changes.

TYPES: BEGIN OF ty_row,
         id   TYPE i,
         name TYPE string,
       END OF ty_row.
TYPES ty_std    TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
TYPES ty_sorted TYPE SORTED TABLE OF ty_row WITH UNIQUE KEY id.

DATA lt_std    TYPE ty_std.
DATA lt_sorted TYPE ty_sorted.

" APPEND puts a row at the end. It only makes sense for a standard table --
" a sorted or hashed table decides the position itself.
APPEND VALUE #( id = 2 name = `Grace` ) TO lt_std.
APPEND VALUE #( id = 1 name = `Ada` )   TO lt_std.

" INSERT ... INTO TABLE lets the table place the row. On a unique key a
" duplicate does not dump: it sets sy-subrc = 4 and inserts nothing.
INSERT VALUE #( id = 1 name = `Ada` )     INTO TABLE lt_sorted.
INSERT VALUE #( id = 1 name = `Ada II` )  INTO TABLE lt_sorted.
WRITE: / 'duplicate rejected with sy-subrc', sy-subrc.

" MODIFY by key changes the row that matches; TRANSPORTING limits what moves.
MODIFY TABLE lt_sorted FROM VALUE #( id = 1 name = `Ada Lovelace` )
       TRANSPORTING name.

" DELETE by condition is one statement, and much faster than a LOOP with a
" DELETE inside it -- which also renumbers the index under your feet.
DELETE lt_std WHERE id > 1.

" INSERT at an index is the standard-table form, and shifts everything after it.
INSERT VALUE #( id = 9 name = `Nine` ) INTO lt_std INDEX 1.

LOOP AT lt_std INTO DATA(ls_std).
  WRITE: / 'std', ls_std-id, ls_std-name.
ENDLOOP.
LOOP AT lt_sorted INTO DATA(ls_sorted).
  WRITE: / 'srt', ls_sorted-id, ls_sorted-name.
ENDLOOP.

CLEAR lt_std.
WRITE: / 'cleared to', lines( lt_std ).
