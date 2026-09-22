REPORT z_tp_performance.

TYPES: BEGIN OF ty_order,
         id       TYPE i,
         customer TYPE i,
       END OF ty_order.
TYPES: BEGIN OF ty_customer,
         id   TYPE i,
         name TYPE string,
       END OF ty_customer.

TYPES ty_orders TYPE STANDARD TABLE OF ty_order WITH EMPTY KEY.
" The same rows, twice: once with no key at all, once with one. That difference
" is the whole experiment -- the code around them is identical.
TYPES ty_unkeyed TYPE STANDARD TABLE OF ty_customer WITH EMPTY KEY.
TYPES ty_keyed   TYPE HASHED   TABLE OF ty_customer WITH UNIQUE KEY id.

DATA lt_orders  TYPE ty_orders.
DATA lt_unkeyed TYPE ty_unkeyed.
DATA lt_keyed   TYPE ty_keyed.

DO 1000 TIMES.
  APPEND VALUE #( id = sy-index customer = sy-index ) TO lt_orders.
  APPEND VALUE #( id = sy-index name = |Customer { sy-index }| ) TO lt_unkeyed.
  INSERT VALUE #( id = sy-index name = |Customer { sy-index }| ) INTO TABLE lt_keyed.
ENDDO.

" The shape to avoid: with no key to search on, the inner LOOP walks the whole
" inner table for every row of the outer one -- 1000 x 1000 row comparisons
" here, growing as the square while a ten-row test system stays instant.
DATA lv_slow TYPE i.
LOOP AT lt_orders INTO DATA(ls_order).
  LOOP AT lt_unkeyed INTO DATA(ls_walk) WHERE id = ls_order-customer.
    lv_slow = lv_slow + 1.
  ENDLOOP.
ENDLOOP.

" The same answer, with the key doing the work: one hash lookup per order.
DATA lv_fast TYPE i.
LOOP AT lt_orders INTO DATA(ls_o).
  IF line_exists( lt_keyed[ id = ls_o-customer ] ).
    lv_fast = lv_fast + 1.
  ENDIF.
ENDLOOP.

WRITE: / 'matches found by the nested loop', lv_slow.
WRITE: / 'matches found by the keyed read ', lv_fast.
WRITE: / 'Measure it yourself: SE30 / SAT, or GET RUN TIME FIELD.'.
