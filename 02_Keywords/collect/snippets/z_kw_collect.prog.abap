REPORT z_kw_collect.

TYPES ty_amount TYPE p LENGTH 9 DECIMALS 2.
TYPES: BEGIN OF ty_total,
         region TYPE string,
         amount TYPE ty_amount,
         count  TYPE i,
       END OF ty_total.

" COLLECT splits a row into key and numbers: the non-numeric components are
" the key, every numeric component is summed into the row with that key. A
" hashed table declared on exactly those key fields says so out loud.
TYPES ty_totals TYPE HASHED TABLE OF ty_total WITH UNIQUE KEY region.

DATA lt_totals TYPE ty_totals.
DATA ls_row    TYPE ty_total.

ls_row = VALUE #( region = `EU` amount = '10.00' count = 1 ).
COLLECT ls_row INTO lt_totals.
ls_row = VALUE #( region = `US` amount = '20.00' count = 1 ).
COLLECT ls_row INTO lt_totals.
ls_row = VALUE #( region = `EU` amount = '30.00' count = 1 ).
COLLECT ls_row INTO lt_totals.

" Two rows, not three: the second EU row was added into the first.
LOOP AT lt_totals INTO DATA(ls_total).
  WRITE: / ls_total-region, ls_total-amount, ls_total-count.
ENDLOOP.

" The same fold as an expression, for comparison. COLLECT is shorter when the
" table's key already IS the grouping; REDUCE or GROUP BY when it is not.
DATA(lv_grand) = REDUCE ty_amount( INIT s = 0
                                   FOR ls_t IN lt_totals
                                   NEXT s = s + ls_t-amount ).
WRITE: / 'grand total', lv_grand.
