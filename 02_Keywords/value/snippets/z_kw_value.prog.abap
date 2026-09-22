REPORT z_kw_value.

TYPES: BEGIN OF ty_line,
         id   TYPE i,
         name TYPE string,
       END OF ty_line.
TYPES ty_tab TYPE STANDARD TABLE OF ty_line WITH EMPTY KEY.

" A structure, filled in one expression. Components not named stay initial.
DATA(ls_one) = VALUE ty_line( id = 1 name = `Ada` ).

" A table: one pair of parentheses per row.
DATA(lt_people) = VALUE ty_tab( ( id = 1 name = `Ada` )
                                ( id = 2 name = `Grace` )
                                ( id = 3 name = `Katherine` ) ).

" BASE keeps what is already there; without it the value starts empty.
DATA(lt_more) = VALUE ty_tab( BASE lt_people ( id = 4 name = `Dorothy` ) ).

" LINES OF splices another table in rather than nesting it.
DATA(lt_all) = VALUE ty_tab( ( LINES OF lt_more ) ( id = 5 name = `Mary` ) ).

" The # stands for "the type is obvious here" -- obvious to the compiler, that
" is, from the context. lines( ) takes a table, so # is ty_tab.
DATA(lv_rows) = lines( VALUE ty_tab( ( id = 9 name = `Solo` ) ) ).

LOOP AT lt_all INTO DATA(ls_row).
  WRITE: / ls_row-id, ls_row-name.
ENDLOOP.
WRITE: / 'first  :', ls_one-name.
WRITE: / 'inline :', lv_rows.
