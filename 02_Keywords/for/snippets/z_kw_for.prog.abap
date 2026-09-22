REPORT z_kw_for.

TYPES ty_amount TYPE p LENGTH 9 DECIMALS 2.
TYPES: BEGIN OF ty_order,
         id     TYPE i,
         region TYPE string,
         amount TYPE ty_amount,
       END OF ty_order.
TYPES ty_orders TYPE STANDARD TABLE OF ty_order WITH EMPTY KEY.
TYPES ty_ints   TYPE STANDARD TABLE OF i WITH EMPTY KEY.
TYPES ty_names  TYPE STANDARD TABLE OF string WITH EMPTY KEY.

DATA(lt_orders) = VALUE ty_orders( ( id = 1 region = `EU` amount = '100.00' )
                                   ( id = 2 region = `US` amount = '250.50' )
                                   ( id = 3 region = `EU` amount = '75.25' ) ).

" Map: one output row per input row.
DATA(lt_ids) = VALUE ty_ints( FOR ls_o IN lt_orders ( ls_o-id ) ).

" Filter: WHERE decides which input rows are visited at all.
DATA(lt_eu) = VALUE ty_orders( FOR ls_e IN lt_orders WHERE ( region = `EU` ) ( ls_e ) ).

" No table to walk: an index of your own, counting with UNTIL or WHILE.
DATA(lt_squares) = VALUE ty_ints( FOR lv_i = 1 UNTIL lv_i > 5 ( lv_i * lv_i ) ).

" Nested FOR is a cross product, read left to right.
DATA(lt_labels) = VALUE ty_names( FOR ls_p IN lt_orders
                                  FOR lv_n = 1 UNTIL lv_n > 2
                                  ( |{ ls_p-id }-{ lv_n }| ) ).

" LET names a value once so the expression does not repeat itself.
DATA(lt_tagged) = VALUE ty_names( LET lv_tag = `order` IN
                                  FOR ls_t IN lt_orders ( |{ lv_tag } { ls_t-id }| ) ).

WRITE: / 'ids     ', lines( lt_ids ).
WRITE: / 'eu      ', lines( lt_eu ).
WRITE: / 'squares ', lines( lt_squares ).
WRITE: / 'labels  ', lines( lt_labels ).
LOOP AT lt_tagged INTO DATA(lv_label).
  WRITE: / lv_label.
ENDLOOP.
