REPORT z_kw_field_symbols.

TYPES: BEGIN OF ty_row,
         id   TYPE i,
         name TYPE string,
       END OF ty_row.
TYPES ty_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

DATA(lt_rows) = VALUE ty_tab( ( id = 1 name = `Ada` )
                              ( id = 2 name = `Grace` ) ).

" A field symbol is another name for a piece of memory, not a copy of it.
" Declared up front and typed, so the compiler can check what you do with it.
FIELD-SYMBOLS <ls_row> TYPE ty_row.
LOOP AT lt_rows ASSIGNING <ls_row>.
  <ls_row>-name = to_upper( <ls_row>-name ).
ENDLOOP.

" Untyped, it can point at anything -- and nothing about it is checked until
" the ASSIGN runs. Power and the bill for it, in one declaration.
FIELD-SYMBOLS <lv_any> TYPE any.

" A component named at runtime: this is the shape of every generic table tool.
ASSIGN COMPONENT `NAME` OF STRUCTURE lt_rows[ 1 ] TO <lv_any>.
IF sy-subrc = 0.
  WRITE: / 'by name  ', <lv_any>.
ENDIF.

" ...and by position, which is how you walk a structure you have never seen.
ASSIGN COMPONENT 1 OF STRUCTURE lt_rows[ 2 ] TO <lv_any>.
IF <lv_any> IS ASSIGNED.
  WRITE: / 'by number', <lv_any>.
ENDIF.

" IS INITIAL asks about the VALUE. Ask about the pointer with IS ASSIGNED --
" using an unassigned field symbol is a short dump, not an initial value.
UNASSIGN <lv_any>.
IF <lv_any> IS NOT ASSIGNED.
  WRITE: / 'unassigned now'.
ENDIF.

" A whole variable, named as text at runtime.
ASSIGN ('SY-UZEIT') TO <lv_any>.
IF sy-subrc = 0.
  WRITE: / 'dynamic  ', <lv_any>.
ENDIF.
