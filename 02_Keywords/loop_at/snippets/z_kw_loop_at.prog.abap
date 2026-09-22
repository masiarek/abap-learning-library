REPORT z_kw_loop_at.

TYPES ty_amount TYPE p LENGTH 9 DECIMALS 2.
TYPES: BEGIN OF ty_row,
         region TYPE string,
         amount TYPE ty_amount,
       END OF ty_row.
TYPES ty_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

DATA(lt_rows) = VALUE ty_tab( ( region = `EU` amount = '10.00' )
                              ( region = `US` amount = '20.00' )
                              ( region = `EU` amount = '30.00' ) ).

" INTO copies the row into a work area. Writing to the copy changes nothing in
" the table -- the commonest silent bug in ABAP.
LOOP AT lt_rows INTO DATA(ls_copy).
  ls_copy-amount = 0.
ENDLOOP.

" ASSIGNING points a field symbol AT the row itself. No copy, and writes land.
LOOP AT lt_rows ASSIGNING FIELD-SYMBOL(<ls_row>).
  <ls_row>-amount = <ls_row>-amount * 2.
ENDLOOP.

" WHERE filters before the copy is made; an IF inside the loop filters after it.
LOOP AT lt_rows INTO DATA(ls_eu) WHERE region = `EU`.
  WRITE: / 'eu row', sy-tabix, ls_eu-amount.
ENDLOOP.

" GROUP BY replaces the AT NEW / control-break dance, and needs no SORT first.
LOOP AT lt_rows INTO DATA(ls_any)
     GROUP BY ( region = ls_any-region )
     INTO DATA(ls_group).
  DATA(lv_total) = REDUCE ty_amount( INIT s = 0
                                     FOR <ls_member> IN GROUP ls_group
                                     NEXT s = s + <ls_member>-amount ).
  WRITE: / 'group', ls_group-region, lv_total.
ENDLOOP.
